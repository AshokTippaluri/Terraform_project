variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  type    = string
  default = "ap-south-1"
}
variable "AMIS" {
  type = map(any)
  default = {
    "ap-south-1" = "ami-00c7878b181453e4d"
    "us-east-1"          = "ami-0f01974d5fd3b4530"
    "eu-west-1"          = "ami-099b1e41f3043ce3a"
  }
}

variable "vm_size" {
  type = string
  default = "t2.micro"
}
