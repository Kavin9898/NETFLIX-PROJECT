# ---------------- VPC ----------------
resource "aws_vpc" "NET_VPC" {
  cidr_block           = "192.168.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "NET-VPC"
  }
}

# ---------------- Public Subnets ----------------
resource "aws_subnet" "PUBLIC_NET_SUBNET" {
  vpc_id                  = aws_vpc.NET_VPC.id
  cidr_block              = "192.168.0.128/26"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "Public-Subnet-1"
  }
}

resource "aws_subnet" "PUBLIC_NET_SUBNET1" {
  vpc_id                  = aws_vpc.NET_VPC.id
  cidr_block              = "192.168.0.192/26"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1b"

  tags = {
    Name = "Public-Subnet-2"
  }
}

# ---------------- Private Subnets ----------------
resource "aws_subnet" "PRIVATE_NET_SUBNET" {
  vpc_id            = aws_vpc.NET_VPC.id
  cidr_block        = "192.168.0.0/26"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Private-Subnet-1"
  }
}

resource "aws_subnet" "PRIVATE_NET_SUBNET1" {
  vpc_id            = aws_vpc.NET_VPC.id
  cidr_block        = "192.168.0.64/26"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Private-Subnet-2"
  }
}

# ---------------- Internet Gateway ----------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.NET_VPC.id

  tags = {
    Name = "NET-IGW"
  }
}

# ---------------- Elastic IP for NAT ----------------
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

# ---------------- NAT Gateway ----------------
resource "aws_nat_gateway" "NET_NAT" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.PUBLIC_NET_SUBNET.id

  tags = {
    Name = "NET-NAT"
  }

  depends_on = [aws_internet_gateway.igw]
}

# ---------------- Public Route Table ----------------
resource "aws_route_table" "PUBLIC_RT" {
  vpc_id = aws_vpc.NET_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-Route-Table"
  }
}

# Associate Public Subnets
resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.PUBLIC_NET_SUBNET.id
  route_table_id = aws_route_table.PUBLIC_RT.id
}

resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.PUBLIC_NET_SUBNET1.id
  route_table_id = aws_route_table.PUBLIC_RT.id
}

# ---------------- Private Route Table ----------------
resource "aws_route_table" "PRIVATE_RT" {
  vpc_id = aws_vpc.NET_VPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NET_NAT.id
  }

  tags = {
    Name = "Private-Route-Table"
  }
}

# Associate Private Subnets
resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.PRIVATE_NET_SUBNET.id
  route_table_id = aws_route_table.PRIVATE_RT.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.PRIVATE_NET_SUBNET1.id
  route_table_id = aws_route_table.PRIVATE_RT.id
}
