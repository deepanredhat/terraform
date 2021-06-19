resource "aws_launch_configuration" "app1-prod-lc" {
  name_prefix   = "webserver-"
  image_id      = "ami-09e67e426f25ce0d7"
  instance_type = "t3.micro"
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install nginx -y
              sudo systemctl start nginx
              echo "Wellcome to App1" > /var/www/html/index.html
              EOF
  key_name = "terraform"
  security_groups = [aws_security_group.app1-prod-sg.id]
  

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app1-asg" {
  name                 = "app1-asg"
  launch_configuration = aws_launch_configuration.app1-prod-lc.name
  min_size             = 2
  max_size             = 2
  vpc_zone_identifier  = ["subnet-0b0a99ae4b068ab75", "subnet-0523264af94da1ed9", "subnet-0f2cd9a68da577524"] 
  load_balancers       = [aws_elb.app1-prod-lb.name]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "app1-prod-sg" {
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

resource "aws_security_group" "app1-prod-loadbalancer-sg" {
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


resource "aws_elb" "app1-prod-lb" {
  name               = "app1-prod-lb"
  subnets            = ["subnet-05302a8da2a6a6799", "subnet-0b5ab645d998715e8", "subnet-0544a83359f2966a3"]
  security_groups    = [aws_security_group.app1-prod-loadbalancer-sg.id]
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
    Name = "app1-prod"
    Env  = "prod"
    Team = "nginx"
  }
}

resource "aws_db_parameter_group" "app1-rds-pg" {
  name   = "app-rds-pg"
  family = "postgres12"
}

resource "aws_db_instance" "app1-prod-rds" {
  identifier = "app1-prod"
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "12"
  instance_class       = "db.t3.micro"
  parameter_group_name = aws_db_parameter_group.app1-rds-pg.id
  skip_final_snapshot  = true
  db_subnet_group_name = "prod-dbgroup"
  username = "dbuser"
  password =  "DbUser007"
  vpc_security_group_ids = [aws_security_group.app1-prod-rds-sg.id]
}

resource "aws_security_group" "app1-prod-rds-sg" {
  vpc_id      = "vpc-0712d909a4f1c5c59"

  ingress {
    from_port        = "5432"
    to_port          = "5432"
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
