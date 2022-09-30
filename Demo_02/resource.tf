resource "aws_instance" "webserver1" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = var.vm_size
  key_name      = "aws-key"

  provisioner "remotelocal-exec" {
    inline = [
      "yum update -y",
      "yum install -y httpd",
      "systemctl start httpd.service",
      "systemctl enable httpd.service"
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = var.Instance_username
    private_key = file("./aws-key.pem")
  }
}


