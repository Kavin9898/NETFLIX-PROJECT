terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
resource "aws_vpc" "NET_VPC" {
  cidr_block = "192.168.0.0/24"
  tags = {
    Name = "NET-VPC"

  }
}

resource "aws_subnet" "PRIVATE_NET_SUBNET" {
  vpc_id     = aws_vpc.NET_VPC.id
  cidr_block = "192.168.0.0/26"
  tags = {
    Name = "NET-SUBNET"
  }
}
resource "aws_subnet" "PRIVATE_NET_SUBNET1" {
  vpc_id     = aws_vpc.NET_VPC.id
  cidr_block = "192.168.0.64/26"
  tags = {
    Name = "NET-SUBNET"
  }
}
resource "aws_subnet" "PUBLIC_NET_SUBNET" {
  vpc_id     = aws_vpc.NET_VPC.id
  cidr_block = "192.168.0.128/26"
  map_public_ip_on_launch = true
  tags = {
    Name = "NET-SUBNET"
  }
}
resource "aws_subnet" "PUBLIC_NET_SUBNET1" {
  vpc_id     = aws_vpc.NET_VPC.id
  cidr_block = "192.168.0.192/26"
  map_public_ip_on_launch = true
  tags = {
    Name = "NET-SUBNET"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.NET_VPC.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "NET_NAT" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.PUBLIC_NET_SUBNET.id

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_route_table" "NET_RT" {
  vpc_id = aws_vpc.NET_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "NET_RT"
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.NET_SUBNET.id
  route_table_id = aws_route_table.NET_RT.id
}

