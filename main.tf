# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = "Aws_acess_key"
  secret_key = "aws_seceret_key"
}

# 1. create custom vpc for ec2
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main_vpc"
  }
}

#2.create a internet gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "main_igw"
  }
}

#3. Create custom route table
resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "main_route_table"
  }
}

#4.create a subnet

resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.aws_subnet
  availability_zone = var.availability_zone
  tags = {
    Name = "main_subnet"
  }
}

#5. route table association
resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_route_table.id
}

#6. create a security group
resource "aws_security_group" "allow_main_web" {
  name        = "main_web"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    to_port          = 22
    from_port        = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

# 7. create a network interface card
resource "aws_network_interface" "network_interface" {
  subnet_id       = aws_subnet.main_subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_main_web.id]

}

#8. assign a Elastic IP
resource "aws_eip" "main_elastic_ip" {
  network_interface         = aws_network_interface.network_interface.id
  associate_with_private_ip = "10.0.1.50"
  vpc                       = true
  depends_on                = [aws_internet_gateway.main_igw]
  tags = {
    Name = "web_elasticIP"
  }
}

#9.create ec2 instance
resource "aws_instance" "web_server" {
  ami               = "ami-052efd3df9dad4825"
  availability_zone = var.availability_zone
  instance_type     = "t2.micro"
  key_name          = "main"
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.network_interface.id
  }
  tags = {
    Name = "main_web-server"
  }
  user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update -y
                sudo apt-get upgrade -y
                sudo apt-get install apache2 -y
                sudo systemctl start apache2
                sudo systemctl enable apache2
                sudo bash -c 'echo Welcome to web-server > /var/www/html/index.html'
                EOF


}

output "publicIP" {
  value = aws_eip.main_elastic_ip.public_ip

}

output "praviteIP" {
  value = aws_instance.web_server.private_ip
}

output "instance_id" {
  value = aws_instance.web_server.id

}
