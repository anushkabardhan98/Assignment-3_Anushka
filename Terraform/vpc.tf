# For VPC creation
resource "aws_vpc" "main" {
  cidr_block = "10.100.0.0/16"

  tags = {
    Name = "anushka_vpc"
  }
}

# Public Subnet creation
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.100.1.0/24"

  tags = {
    Name = "public-subnet-1"
  }
}
resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.100.2.0/24"

  tags = {
    Name = "public-subnet-2"
  }
}

# Private Subnet creation
resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.100.3.0/24"

  tags = {
    Name = "private-subnet-1"
  }
}
resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.100.4.0/24"

  tags = {
    Name = "private-subnet-2"
  }
}

# Internet Gateway creation
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "anushka-igw"
  }
}

# Nat Gateway creation
resource "aws_eip" "eip" {
  domain   = "vpc"
}
resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.eip.id}"
  subnet_id     = "${aws_subnet.public1.id}"

  tags = {
    Name = "anushka-nat"
  }
}

# Route table creation
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-rt"
  }
}
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}