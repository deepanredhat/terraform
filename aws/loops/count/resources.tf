resource "aws_instance" "demo1" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  count = 3
  tags = {
    Name = "demomachine1"
  }
}
