variable "instance_type" {
  type = string
}

locals {
  project_name = "getting started with terraform"
}

variable "ami_ubuntu" {
  type = string
}