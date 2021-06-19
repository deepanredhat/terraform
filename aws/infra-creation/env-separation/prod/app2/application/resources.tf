data "terraform_remote_state" "lb" {
   backend = "s3"
   config = {
     bucket = "codezippy-terraform-prod-statefile"
     key = "app2/loadbalancer/terraform.tfstate"
     region = "us-east-1"
  }
}

resource "aws_launch_configuration" "app2-prod-lc" {
  name_prefix   = "webserver-"
  image_id      = "ami-09e67e426f25ce0d7"
  instance_type = "t3.micro"
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install nginx -y
              sudo systemctl start nginx
              echo "Wellcome to App2" > /var/www/html/index.html
              EOF
  key_name = "terraform"
  security_groups = [aws_security_group.app2-prod-sg.id]
  

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app2-prod-asg" {
  name                 = "app2-prod-asg"
  launch_configuration = aws_launch_configuration.app2-prod-lc.name
  min_size             = 2
  max_size             = 2
  vpc_zone_identifier  = ["subnet-0b0a99ae4b068ab75", "subnet-0523264af94da1ed9", "subnet-0f2cd9a68da577524"] 
  load_balancers       = [ data.terraform_remote_state.lb.outputs.id ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "app2-prod-sg" {
  vpc_id      = "vpc-0712d909a4f1c5c59"

  ingress {
    from_port        = 22
    to_port          = 22
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
  tags = local.common_tags
}


locals {
  common_tags = {
    Name = "app2-prod"
    Env  = "prod"
    Team = "nginx"
  }
}
