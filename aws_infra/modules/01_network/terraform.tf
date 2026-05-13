# terraform.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "aws09-terraform-state-bucket"
    key            = "network/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "aws09-terraform-locks"
    encrypt = true
  }
}
provider "aws" {
  region = var.region
}