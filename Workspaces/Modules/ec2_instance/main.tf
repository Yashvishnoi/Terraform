provider "aws"{
    region = "us-east-1"
}
variable "ami" {
    description = "This is AMI for the Instance"
}

variable "instance_type" {
    description = "This is instance type for the instance"
}
resource "aws_instance" "example" {
    ami = var.ami
    instance_type = var.instance_type
}