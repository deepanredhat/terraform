data "aws_ami" "example" {
  most_recent      = true
  owners           = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.example.id
  instance_type = "t3.micro"
  key_name = "terraform"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get -y install nginx",
      "sudo systemctl start nginx"
    ]
  
    connection {
      type     = "ssh"
      host = self.public_ip
      user     = "ubuntu"
      private_key = "${file("./terraform.pem")}"
  }
  }
  tags = {
    Name = "HelloWorld"
  }
}