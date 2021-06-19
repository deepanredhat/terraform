
resource "aws_security_group" "app2-prod-loadbalancer-sg" {
  vpc_id      = "vpc-0712d909a4f1c5c59"

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


resource "aws_elb" "app2-prod-lb" {
  name               = "app2-prod-lb"
  subnets            = ["subnet-05302a8da2a6a6799", "subnet-0b5ab645d998715e8", "subnet-0544a83359f2966a3"]
  security_groups    = [aws_security_group.app2-prod-loadbalancer-sg.id]
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
    Name = "app2-prod"
    Env  = "prod"
    Team = "nginx"
  }
}

