provider "aws" {

}

resource "aws_instance" "ubuntu" {
  ami           = var.amis
  instance_type = var.instance_size
  key_name      = var.key
  user_data     = file("apache.sh")
}

output "publicIP" {
  value = aws_instance.ubuntu.public_ip
}
