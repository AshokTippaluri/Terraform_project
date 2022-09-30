provider "aws" {

}

resource "aws_instance" "count" {
  count         = 2
  ami           = "ami-01216e7612243e0ef"
  instance_type = "t2.micro"

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y amazon-linux-extras
    sudo amazon-linux-extras enable httpd_modules
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    EOF
  
  tags = {
    "Name" = "server-${count.index}"
  }
}

output "public_ip0" {
  value = aws_instance.count[*].public_ip
}

