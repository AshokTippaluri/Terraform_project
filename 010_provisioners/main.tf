terraform {
  cloud {
    organization = "acoinweb"

    workspaces {
      name = "Provisioners"
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

}

resource "aws_instance" "provising" {
  ami           = "ami-01216e7612243e0ef"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  # user_data     = data.template_file.user_data.rendered
  tags = {
    "name" = "provisioners"
  }
  # provisioner "local-exec" {
  #   command = "echo ${self.private_ip} >> private_ips.txt"
  # }
  provisioner "remote-exec" {
    inline = [
      "echo hostname >> hostname.txt"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = "self.public_ip"
    private_key = "${file("/root/.ssh/terraform")}"
  }
}


resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEcbE+Whce13k0k8d7MQe6I99NLKBaAQypdjJaqjWvQ8EZjCH7VFoFNPdoEvnwZrERY2hMNW49b6u2R45mzo24+FSLTIwYLzlCdUOw5Qab++zxb3sNPO8Yzchb5cre8RWc+RErBrOLz3zTA6v3dJb+SoBppWmr9M/hduVRA4jp9zmqiu5cvvnDJK3eDJ3ekDqBVX5QA7kejr+80R84kwy4Gl+DM9ZrTUtHG8Htc4JtKjKFPRwzpIxPZV/s/MNc7rKT6ACx+r2zSP+8LSW4T1jChZ7pE6kirkmF3HLIT3U14tXol6oxaZLfVlSELRQuEvAZljHhzXSqcrQ+3obfn84DL0AFQmi24QEuHjdD40BC6AhdOAgthoFlWXtX3OrKkf/ovdw/e6IgUZ/JsFwCk/F/IhsGAejmdemOfKRRhVqvJ3UQgkHi5oxzTVD2RX+hLv9Wt7hvFv1YPu/VMGelO3N4aGOG/BKY6Z2kYaUiIwLWPDihRxLirryMuLTyVxQxWnU= root@devops-box"
}

data "template_file" "user_data" {
  template = file("./provision.yaml")
}

output "public_ip" {
  value = aws_instance.provising.public_ip
}
