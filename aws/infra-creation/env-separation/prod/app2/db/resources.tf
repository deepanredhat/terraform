
resource "aws_db_parameter_group" "app2-rds-pg" {
  name   = "app2-rds-pg"
  family = "postgres12"
}

resource "aws_db_instance" "app2-prod-rds" {
  identifier = "app2-prod"
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "12"
  instance_class       = "db.t3.micro"
  parameter_group_name = aws_db_parameter_group.app2-rds-pg.id
  skip_final_snapshot  = true
  db_subnet_group_name = "prod-dbgroup"
  username = "dbuser"
  password =  "DbUser007"
  vpc_security_group_ids = [ aws_security_group.app2-prod-rds-sg.id ]
}

resource "aws_security_group" "app2-prod-rds-sg" {
  vpc_id      = "vpc-0712d909a4f1c5c59"
  name = "app2-prod-rds-sg"
  description = "app2-prod-rds-sg"

  ingress {
    from_port        = "5432"
    to_port          = "5432"
    protocol         = "tcp"
    self             = "true"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
