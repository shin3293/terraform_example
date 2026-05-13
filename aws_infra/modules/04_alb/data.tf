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
