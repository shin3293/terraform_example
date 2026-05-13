# aws_infra/asg/data.tf
# Remote State

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = "network/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "ec2" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = "ec2/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = "iam/terraform.tfstate"
    region = var.region
  }
}
data "terraform_remote_state" "alb" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    key    = "alb/terraform.tfstate"
    region = var.region
  }
}
data "aws_iam_instance_profile" "aws09_ec2_profile" {
  name = "${var.prefix}-ec2-instance-profile"
}