variable "region" { type = string }
variable "prefix" { type = string }
variable "key_name" { type = string }
variable "instance_type" { type = string }
variable "ami_id" {
  default = "ami-0765f9741eed9c7b"
}

