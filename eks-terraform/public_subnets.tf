locals {
  public_subnets = {
    "ap-southeast-1a" = "192.168.32.0/19"
    "ap-southeast-1b" = "192.168.0.0/19"
    "ap-southeast-1c" = "192.168.64.0/19"
  }
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name                     = "SubnetPublic${replace(upper(each.key), "-", "")}"
    "kubernetes.io/role/elb" = "1"
  }
}
