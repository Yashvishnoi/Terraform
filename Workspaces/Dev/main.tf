provider "aws" {
    region = "us-east-1"
}

variable "ami" {
    description = "value"
}

variable "instance_type" {
  description = "value"
}

module "ec2_instance" {
  source = "../Modules/ec2_instance"
  ami = var.ami
  instance_type = var.instance_type
}

