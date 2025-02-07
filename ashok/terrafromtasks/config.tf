terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket               = "ddm-automation-terraform-state"
    key                  = "ashok/terraform.tfstate"
    region               = "us-east-1"
    dynamodb_table       = "terraform-state-lock"
    workspace_key_prefix = "ashok-"
  }
}

provider "aws" {
  region = var.aws_region
}
