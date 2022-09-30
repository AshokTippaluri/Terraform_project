resource "aws_instance" "webserver1" {
  ami = "${lookup(var.AMIS,var.AWS_REGION)}"
  instance_type = var.vm_size
}