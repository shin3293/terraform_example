# aws_infra/asg/data.tf
data "aws_vpc" "aws09_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-vpc"]
  }
}
data "aws_subnets" "aws09_private_subnets" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-private-subnet-*"]
  }
}
data "aws_security_group" "aws09_ssh_sg" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-ssh-sg"]
  }
}
data "aws_security_group" "aws09_http_sg" {
  filter {
    name   = "tag:Name"
    values = ["${var.prefix}-http-sg"]
  }
}
data "aws_iam_instance_profile" "aws09_ec2_instance_profile" {
    name   ="${var.prefix}-ec2-instance-profile"
  }

data "aws_ami" "aws09_instance_ami" {
  most_recent = true
  owners = ["self"]
  filter {
    name   = "tag:name"
    values = ["${var.prefix}-instance-ami"]
  }
}
data "aws_lb_target_group" "aws09_alb_was_group" {
    name   = "${var.prefix}-alb-was-group"
}
