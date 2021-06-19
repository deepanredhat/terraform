resource "aws_launch_configuration" "webserver-lc" {
  name_prefix   = "webserver-"
  image_id      = "ami-09e67e426f25ce0d7"
  instance_type = "t3.micro"
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install nginx -y
              sudo systemctl start nginx
              EOF
  key_name = "terraform"
  security_groups = [aws_security_group.webserver-sg.id]
  

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "webserver-asg" {
  name                 = "terraform-asg-example"
  launch_configuration = aws_launch_configuration.webserver-lc.name
  min_size             = 2
  max_size             = 2
  availability_zones   = ["us-east-1a", "us-east-1b", "us-east-1c"] 
  load_balancers       = [aws_elb.webserver-lb.name]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "webserver-sg" {
  vpc_id      = "vpc-e35ed599"

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

resource "aws_security_group" "loadbalancer-sg" {
  vpc_id      = "vpc-e35ed599"

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


resource "aws_elb" "webserver-lb" {
  name               = "webserver-lb"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  security_groups    = [aws_security_group.loadbalancer-sg.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }


  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  tags = local.common_tags
}

locals {
  common_tags = {
    Name = "Webserver"
    Env  = "dev"
    Team = "nginx"
  }
}
