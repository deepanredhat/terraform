resource "aws_instance" "demo1" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  for_each = toset(var.name)
  tags = {
    Name = each.value
  }
}
