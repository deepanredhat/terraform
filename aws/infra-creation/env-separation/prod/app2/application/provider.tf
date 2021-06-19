terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  backend "s3" {
    bucket = "codezippy-terraform-prod-statefile"
    region = "us-east-1"
    encrypt = "true"
    key = "app2/application/terraform.tfstate"
    dynamodb_table = "terraform-prod-locks"
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
}
