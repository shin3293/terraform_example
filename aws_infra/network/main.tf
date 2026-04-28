# # main.tf
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
# }

#1. VPC 생성
resource "aws_vpc" "aws09-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.prefix}vpc"
  }
}
#2. 퍼블릭 서브넷과 프라이빗 서브넷 생성
resource "aws_subnet" "aws09-public-subnet" {
  count = length(var.public_subnet_cidr_blocks)
  vpc_id            = aws_vpc.aws09-vpc.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name = "${var.prefix}public-subnet-${count.index + 1}"
  }
}
resource "aws_subnet" "aws09-private-subnet" {
  count = length(var.private_subnet_cidr_blocks)
  vpc_id            = aws_vpc.aws09-vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name = "${var.prefix}private-subnet-${count.index + 1}"
  }
}
# 3. 인터넷 게이트웨이 생성 및 VPC에 연결
resource "aws_internet_gateway" "aws09-igw" {
  vpc_id = aws_vpc.aws09-vpc.id 
  tags = {
    Name = "${var.prefix}igw"
  }
} 
# 4. NAT 게이트웨이 생성 및 퍼블릭 서브넷에 연결
resource "aws_eip" "aws09-nat-eip" {
  domain = "vpc"
  tags = {
    Name = "${var.prefix}nat-eip"
  }
}
resource "aws_nat_gateway" "aws09-nat-gw" {
  allocation_id = aws_eip.aws09-nat-eip.id
  subnet_id     = aws_subnet.aws09-public-subnet[0].id
  tags = {
    Name = "${var.prefix}nat-gw"
  }
}
# 5. 라우트 테이블 생성 및 라우팅 설정(Public 1개, Private 2개)
resource "aws_route_table" "aws09-public-rt" {
  vpc_id = aws_vpc.aws09-vpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws09-igw.id
  }
  tags = {
    Name = "${var.prefix}public-rt"
  }
} 
resource "aws_route_table_association" "aws09-public-rt-association" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.aws09-public-subnet[count.index].id
  route_table_id = aws_route_table.aws09-public-rt.id
}
resource "aws_route_table" "aws09-private-rt" {
  count = length(var.private_subnet_cidr_blocks)
  vpc_id = aws_vpc.aws09-vpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.aws09-nat-gw.id
  }
  tags = {
    Name = "${var.prefix}private-rt-${count.index + 1}"
  }
}
resource "aws_route_table_association" "aws09-private-rt-association" {
  count          = length(var.private_subnet_cidr_blocks)
  subnet_id      = aws_subnet.aws09-private-subnet[count.index].id
  route_table_id = aws_route_table.aws09-private-rt[count.index].id
}
#6. Security Group 생성 - SSH, HTTP, HTTPS-SG
resource "aws_security_group" "aws09-ssh-sg" {
  name        = "${var.prefix}ssh-sg"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.aws09-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "aws09-http-sg" {
  name        = "${var.prefix}http-sg"
  description = "Allow HTTP access"
  vpc_id      = aws_vpc.aws09-vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]    
  }
}   