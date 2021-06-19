locals {

 default = {
  Name = "dev-vpc"
  Env = "Dev"
}
 public = {
  Name = "dev-vpc-public"
  Env = "Dev"
  purpose = "Expose the service to outside world"
  Placement = "public"
}
 private = {
  Name = "dev-vpc-private"
  Env = "Dev"
  Purpose = "App Layer"
  Placement = "private"
}
 dbprivate = {
  Name = "dev-vpc-dbprivate"
  Env = "Dev"
  Purpose = "Db Layer"
  Placement = "private"
}

}
resource "aws_vpc" "terraform-vpc" {
  cidr_block       = var.vpc_cidr_block
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  tags = local.default
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.terraform-vpc.id
  tags = local.default

  }

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.terraform-vpc.id
  for_each = var.public_subnets_cidr
  cidr_block = each.value
  availability_zone = each.key

  tags = {
    Name = "dev-vpc-public-${each.key}"
    Env = "Dev"
    Purpose = "Expose the service to outside world"
    Placement = "public"
  
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.terraform-vpc.id
  for_each = var.private_subnets_cidr
  cidr_block = each.value
  availability_zone = each.key

  tags = {
    Name = "dev-vpc-private-${each.key}"
    Env = "Dev"
    Purpose = "Expose the service to outside world"
    Placement = "public"
  
  }

}

resource "aws_subnet" "db_private" {
  vpc_id     = aws_vpc.terraform-vpc.id
  for_each = var.db_private_subnets_cidr
  cidr_block = each.value
  availability_zone = each.key

  tags = {
    Name = "dev-vpc-db-private-${each.key}"
    Env = "Dev"
    Purpose = "Expose the service to outside world"
    Placement = "public"
  
  }
}

resource "aws_eip" "nat-gateway-public-ip" {
  public_ipv4_pool = "amazon"
  vpc      = true
  depends_on  = [aws_internet_gateway.gw]
  tags = {
    Name = "nat-gateway-public-ip"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat-gateway-public-ip.id
  subnet_id     = aws_subnet.public["us-east-1a"].id

  tags = {
    Name = "dev-vpc-nat-gateway"
  }

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }


  tags = {
    Name = "public-route"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }


  tags = {
    Name = "dev-vpc-private-route"
  }
}

resource "aws_route_table_association" "public_association" {
  for_each = var.public_subnets_cidr
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_association" {
  for_each = var.private_subnets_cidr
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "db_private_association" {
  for_each = var.db_private_subnets_cidr
  subnet_id      = aws_subnet.db_private[each.key].id
  route_table_id = aws_route_table.private.id
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "dbgroup"
  #for_each   = var.db_private_subnets_cidr
  subnet_ids = [ aws_subnet.db_private["us-east-1a"].id, aws_subnet.db_private["us-east-1b"].id, aws_subnet.db_private["us-east-1c"].id]

  tags = {
    Name = "dbgroup"
    Env = "dev"
    Purpose = "Subnets to create Db instance"
  }
}
