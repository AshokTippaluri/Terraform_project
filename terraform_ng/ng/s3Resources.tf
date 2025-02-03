terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {

}

resource "aws_s3_bucket" "aws_bucket_resources" {
  bucket = "ashok-s3-test-bucket-123"

  tags = {
    Name        = "My first bucket"
    Environment = "Learning"
    CreatedFrom = "Terraform"
  }
}
