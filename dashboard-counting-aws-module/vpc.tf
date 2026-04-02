resource "aws_vpc" "dashboard_counting" {
  cidr_block           = var.address_space
  enable_dns_hostnames = true

  tags = {
    name        = "${var.prefix1}-${var.prefix2}-vpc-${var.region}"
    environment = "${var.environment}"
  }
}

resource "aws_subnet" "dashboard_public_subnet" {
  vpc_id     = aws_vpc.dashboard_counting.id
  cidr_block = var.public_subnet

  tags = {
    name = "${var.prefix1}-public-subnet"
  }
}

resource "aws_subnet" "counting_private_subnet" {
  vpc_id     = aws_vpc.dashboard_counting.id
  cidr_block = var.private_subnet

  tags = {
    name = "${var.prefix2}-private-subnet"
  }
}

resource "aws_internet_gateway" "dashboard_igw" {
  vpc_id = aws_vpc.dashboard_counting.id

  tags = {
    Name = "${var.prefix1}-${var.prefix2}-igw"
  }
}

resource "aws_route_table" "dashboard_rtb" {
  vpc_id = aws_vpc.dashboard_counting.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dashboard_igw.id
  }
}

resource "aws_route_table_association" "dashboard_public_subnet" {
  subnet_id      = aws_subnet.dashboard_public_subnet.id
  route_table_id = aws_route_table.dashboard_rtb.id
}

resource "aws_route_table" "counting_rtb" {
  vpc_id = aws_vpc.dashboard_counting.id
}

resource "aws_route_table_association" "counting_private_subnet" {
  subnet_id      = aws_subnet.counting_private_subnet.id
  route_table_id = aws_route_table.counting_rtb.id
}
