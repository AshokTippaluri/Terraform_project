variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  type    = string
  default = "ap-south-1"
}
variable "AMIS" {
  type = map(any)
  default = {
    "ap-south-1" = "ami-01216e7612243e0ef"
    "us-east-1"  = "ami-0f01974d5fd3b4530"
    "eu-west-1"  = "ami-099b1e41f3043ce3a"
  }
}

variable "vm_size" {
  type    = string
  default = "t2.micro"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "Instance_username" {
  default = "ec2-user"
}
