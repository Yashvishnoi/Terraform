terraform {
  backend "s3" {
    bucket = "yash-s3-bucket-xyz"
    region = "us-east-1"
    key = "yash/terraform.tfstate"
    dynamodb_table = "terraform_lock"
  }
}