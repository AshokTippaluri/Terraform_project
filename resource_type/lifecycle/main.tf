provider "aws" {
}

resource "aws_security_group" "sg1" {
  name        = "sg1"
  description = "Allow HTTPS inbound traffic"

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name = "sg1"
  }
}


resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  depends_on = [
    aws_security_group.sg1
  ]
}