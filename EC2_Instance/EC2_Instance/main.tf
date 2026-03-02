provider "aws" {
    region = "us-east-1"
}

module "ec2_instance" {
    source = "./module/ec2"
    ami_value = "ami-0ad50334604831820"
    instance_type_value = "t3.small"
}