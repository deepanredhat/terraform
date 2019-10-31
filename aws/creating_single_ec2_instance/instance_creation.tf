provider "aws" {
	region = "us-east-1"
}

resource "aws_instance" "firstmachine" {
	ami = "ami-04b9e92b5572fa0d1"
	instance_type = "t2.micro"
	key_name = "botokey3"
	tags = {
    Name = "firstmachine"
		env = "dev"
		team = "devops"
  }
}
