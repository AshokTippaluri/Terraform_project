terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "acoinweb"

    workspaces {
      name = "getting-started"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.32.0"
    }
  }
}


provider "aws" {
  region  = "ap-south-1"
}