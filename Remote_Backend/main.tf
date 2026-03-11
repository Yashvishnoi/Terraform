provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "yash_instance" {
    instance_type = "t3.micro"
    ami="ami-0ad50334604831820"
}

resource "aws_s3_bucket" "s3_bucket" {
    bucket = "yash-s3-bucket-xyz"
}

resource "aws_dynamodb_table" "terraform_lock" {
    name = "terraform_lock"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
      name = "LockID"
      type = "S"  // String type of lock ID.
    }
}