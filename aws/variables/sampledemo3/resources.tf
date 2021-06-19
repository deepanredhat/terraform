resource "aws_instance" "demo1" {
  ami           = var.ami
  instance_type = var.instance_type[1]
  key_name      = var.key_name
}