provider "aws" {

}

resource "aws_instance" "loop" {
  for_each = {
    nano  = "t2.nano"
    micro = "t2.micro"
  }
  ami           = "ami-01216e7612243e0ef"
  instance_type = each.value

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
    "Name" = "server-${each.key}"
  }
}

output "public_ip" {
  value = values(aws_instance.loop)[*].public_ip
}

