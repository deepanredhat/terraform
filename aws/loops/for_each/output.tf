output "public_ip" {
  value = {
    for name in aws_instance.demo1:
      name.id => name.public_ip
  }
}
