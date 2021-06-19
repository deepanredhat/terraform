data "aws_ami" "ubuntu" {
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

data "aws_ami" "amazonlinux" {
    most_recent = true
    owners = ["amazon"]

    filter {
       name = "architecture"
       values = ["x86_64"]
     }

   filter {
     name = "name"
     values = ["amzn2-ami-hvm-*"]
  }
}

resource "aws_instance" "mac0" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "ubuntu"
  }
}

resource "aws_instance" "mac1" {
  ami           = data.aws_ami.amazonlinux.id
  instance_type = "t3.micro"

  tags = {
    Name = "amazonlinux"
  }
}

