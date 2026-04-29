resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.cluster_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public["ap-southeast-1b"].id

  tags = {
    Name = "${var.cluster_name}-nat-gw"
  }

  depends_on = [aws_internet_gateway.main]
}