resource "aws_vpc" "vpc_obligatorio" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.name_vpc
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc_obligatorio.id
  availability_zone       = var.availability_zone
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet publica"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.vpc_obligatorio.id
  availability_zone       = var.availability_zone
  cidr_block              = var.private_subnet_cidr
  map_public_ip_on_launch = false
  tags = {
    Name = "subnet privada"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.vpc_obligatorio.id
  availability_zone       = var.availability_zone2
  cidr_block              = var.public_subnet_cidr2
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet publica 2"
  }
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.vpc_obligatorio.id
  availability_zone       = var.availability_zone2
  cidr_block              = var.private_subnet_cidr2
  map_public_ip_on_launch = false
  tags = {
    Name = "subnet privada 2"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.vpc_obligatorio.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc_obligatorio.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat1" {
  associate_with_private_ip = true
  tags = {
    Name = "main-eip1"
  }
}

resource "aws_nat_gateway" "main1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "main-nat-gateway1"
  }
}

resource "aws_eip" "nat2" {
  associate_with_private_ip = true
  tags = {
    Name = "main-eip2"
  }
}

resource "aws_nat_gateway" "main2" {
  allocation_id = aws_eip.nat2.id
  subnet_id     = aws_subnet.public2.id

  tags = {
    Name = "main-nat-gateway2"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc_obligatorio.id

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.vpc_obligatorio.id

  tags = {
    Name = "private-route-table2"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private2.id
}

resource "aws_route" "private_internet_access" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main1.id
}

resource "aws_route" "private_internet_access2" {
  route_table_id         = aws_route_table.private2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main2.id
}
