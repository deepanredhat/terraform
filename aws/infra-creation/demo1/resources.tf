resource "aws_instance" "server1-prod" {
    ami = "ami-09e67e426f25ce0d7"
    instance_type = "t3.micro"
    key_name = "terraform"
    vpc_security_group_ids = [ aws_security_group.server1-prod-sg.id ]
    user_data = <<-EOF
                  #!/bin/bash
                  sudo apt-get update -y
                  sudo apt-get install nginx -y
                  sudo systemctl start nginx
                  sudo echo "prod-server" > /var/www/html/index.html
                EOF
    tags = {
      Name = "server2"
    }

}

resource "aws_security_group" "server1-prod-sg" {
  name = "server1-prod-sg"
  vpc_id      = "vpc-e35ed599"
  
  ingress {
    from_port        = "22"
    to_port          = "22"
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = "80"
    to_port          = "80"
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "server1-prod-sg"
  }
}
