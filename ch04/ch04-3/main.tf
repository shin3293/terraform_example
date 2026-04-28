terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0"

}

provider "aws" {
  region = "ap-northeast-2"
}

# data "aws_ami" "al2023" {
#     most_recent = true
#     owners  = ["amazon"]

#     filter {
#         name    = "owner-alias"
#         values  = ["al2023-ami-2023*-kernel-6.1-x86_64"]
#     }
#     filter {
#         name    = "architecture"
#         values  = ["X86_64"]
#     }
#     filter {
#         name    = "virtualization-type"
#         values  = ["hvm"]
#     }
# }

resource "aws_instance" "api_server" {
  ami           = "ami-0c003e98ceffee43e"
  instance_type = "t3.micro"

  tags = {
    Name = "aws09-app-server"
  }
}

output "public_ip" {
  value = aws_instance.api_server.public_ip
}