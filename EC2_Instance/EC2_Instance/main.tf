variable "ami_value" {
    description = "Value for ami"
}

variable "instance_type_value" {
    description = "Value  for instance type"
}


provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "example" {
    ami           = "var.ami_value"
    instance_type = "var.instance_type_value"
}