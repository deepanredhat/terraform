variable "vpc_cidr_block" {
  type = string
}

variable "region" {
  type = string
}

variable "public_subnets_cidr" {
  type = map(string)
  default = {
    "us-east-1a" = "20.0.1.0/24"
    "us-east-1b" = "20.0.2.0/24"
    "us-east-1c" = "20.0.3.0/24"
}
}

variable "private_subnets_cidr" {
  type = map(string)
  default = {
    "us-east-1a" = "20.0.11.0/24"
    "us-east-1b" = "20.0.12.0/24"
    "us-east-1c" = "20.0.13.0/24"
  }
}

variable "db_private_subnets_cidr" {
  type = map(string)
  default = {
    "us-east-1a" = "20.0.21.0/24"
    "us-east-1b" = "20.0.22.0/24"
    "us-east-1c" = "20.0.23.0/24"
  }
}
