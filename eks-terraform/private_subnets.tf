locals {
  private_subnets = {
    "ap-southeast-1a" = "192.168.128.0/19"
    "ap-southeast-1b" = "192.168.96.0/19"
    "ap-southeast-1c" = "192.168.160.0/19"
  }
}

resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    Name                              = "SubnetPrivate${replace(upper(each.key), "-", "")}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}
