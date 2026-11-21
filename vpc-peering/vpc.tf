// Create VPCs per region with subnets, IGW, NAT, and route tables

resource "aws_vpc" "customer" {
  provider = aws.customer
  cidr_block = local.vpcs.customer.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(local.common_tags, { Name = local.vpcs.customer.name })
}

resource "aws_internet_gateway" "customer_igw" {
  provider = aws.customer
  vpc_id = aws_vpc.customer.id
  tags = merge(local.common_tags, { Name = "${local.vpcs.customer.name}-igw" })
}

resource "aws_eip" "customer_nat_eip" {
  provider = aws.customer
  tags = merge(local.common_tags, { Name = "${local.vpcs.customer.name}-nat-eip" })
}

resource "aws_subnet" "customer_public" {
  provider = aws.customer
  for_each = { for s in local.vpcs.customer.public_subnets : s.name => s }
  vpc_id            = aws_vpc.customer.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  map_public_ip_on_launch = true
  tags = merge(local.common_tags, { Name = each.value.name })
}

resource "aws_subnet" "customer_private" {
  provider = aws.customer
  for_each = { for s in local.vpcs.customer.private_subnets : s.name => s }
  vpc_id            = aws_vpc.customer.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags = merge(local.common_tags, { Name = each.value.name })
}

resource "aws_nat_gateway" "customer_nat" {
  provider = aws.customer
  allocation_id = aws_eip.customer_nat_eip.id
  subnet_id     = aws_subnet.customer_public[local.vpcs.customer.public_subnets[0].name].id
  tags = merge(local.common_tags, { Name = "${local.vpcs.customer.name}-nat" })
}

resource "aws_route_table" "customer_public_rt" {
  provider = aws.customer
  vpc_id = aws_vpc.customer.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.customer_igw.id
  }
  tags = merge(local.common_tags, { Name = "public-customer-rtb" })
}

resource "aws_route_table" "customer_private_rt" {
  provider = aws.customer
  vpc_id = aws_vpc.customer.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.customer_nat.id
  }
  tags = merge(local.common_tags, { Name = "private-customer-rtb" })
}

resource "aws_route_table_association" "customer_public_assoc" {
  provider = aws.customer
  for_each = aws_subnet.customer_public
  subnet_id = each.value.id
  route_table_id = aws_route_table.customer_public_rt.id
}

resource "aws_route_table_association" "customer_private_assoc" {
  provider = aws.customer
  for_each = aws_subnet.customer_private
  subnet_id = each.value.id
  route_table_id = aws_route_table.customer_private_rt.id
}

// ACCOUNT VPC (Malaysia)
resource "aws_vpc" "account" {
  provider = aws.account
  cidr_block = local.vpcs.account.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(local.common_tags, { Name = local.vpcs.account.name })
}

resource "aws_internet_gateway" "account_igw" {
  provider = aws.account
  vpc_id = aws_vpc.account.id
  tags = merge(local.common_tags, { Name = "${local.vpcs.account.name}-igw" })
}

resource "aws_eip" "account_nat_eip" {
  provider = aws.account
  tags = merge(local.common_tags, { Name = "${local.vpcs.account.name}-nat-eip" })
}

resource "aws_subnet" "account_public" {
  provider = aws.account
  for_each = { for s in local.vpcs.account.public_subnets : s.name => s }
  vpc_id = aws_vpc.account.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  map_public_ip_on_launch = true
  tags = merge(local.common_tags, { Name = each.value.name })
}

resource "aws_subnet" "account_private" {
  provider = aws.account
  for_each = { for s in local.vpcs.account.private_subnets : s.name => s }
  vpc_id = aws_vpc.account.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  tags = merge(local.common_tags, { Name = each.value.name })
}

resource "aws_nat_gateway" "account_nat" {
  provider = aws.account
  allocation_id = aws_eip.account_nat_eip.id
  subnet_id     = aws_subnet.account_public[local.vpcs.account.public_subnets[0].name].id
  tags = merge(local.common_tags, { Name = "${local.vpcs.account.name}-nat" })
}

resource "aws_route_table" "account_public_rt" {
  provider = aws.account
  vpc_id = aws_vpc.account.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.account_igw.id
  }
  tags = merge(local.common_tags, { Name = "public-account-rtb" })
}

resource "aws_route_table" "account_private_rt" {
  provider = aws.account
  vpc_id = aws_vpc.account.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.account_nat.id
  }
  tags = merge(local.common_tags, { Name = "private-account-rtb" })
}

resource "aws_route_table_association" "account_public_assoc" {
  provider = aws.account
  for_each = aws_subnet.account_public
  subnet_id = each.value.id
  route_table_id = aws_route_table.account_public_rt.id
}

resource "aws_route_table_association" "account_private_assoc" {
  provider = aws.account
  for_each = aws_subnet.account_private
  subnet_id = each.value.id
  route_table_id = aws_route_table.account_private_rt.id
}

// STATEMENT VPC (Thailand)
resource "aws_vpc" "statement" {
  provider = aws.statement
  cidr_block = local.vpcs.statement.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(local.common_tags, { Name = local.vpcs.statement.name })
}

resource "aws_internet_gateway" "statement_igw" {
  provider = aws.statement
  vpc_id = aws_vpc.statement.id
  tags = merge(local.common_tags, { Name = "${local.vpcs.statement.name}-igw" })
}

resource "aws_eip" "statement_nat_eip" {
  provider = aws.statement
  tags = merge(local.common_tags, { Name = "${local.vpcs.statement.name}-nat-eip" })
}

resource "aws_subnet" "statement_public" {
  provider = aws.statement
  for_each = { for s in local.vpcs.statement.public_subnets : s.name => s }
  vpc_id = aws_vpc.statement.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  map_public_ip_on_launch = true
  tags = merge(local.common_tags, { Name = each.value.name })
}

resource "aws_subnet" "statement_private" {
  provider = aws.statement
  for_each = { for s in local.vpcs.statement.private_subnets : s.name => s }
  vpc_id = aws_vpc.statement.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  tags = merge(local.common_tags, { Name = each.value.name })
}

resource "aws_nat_gateway" "statement_nat" {
  provider = aws.statement
  allocation_id = aws_eip.statement_nat_eip.id
  subnet_id     = aws_subnet.statement_public[local.vpcs.statement.public_subnets[0].name].id
  tags = merge(local.common_tags, { Name = "${local.vpcs.statement.name}-nat" })
}

resource "aws_route_table" "statement_public_rt" {
  provider = aws.statement
  vpc_id = aws_vpc.statement.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.statement_igw.id
  }
  tags = merge(local.common_tags, { Name = "public-statement-rtb" })
}

resource "aws_route_table" "statement_private_rt" {
  provider = aws.statement
  vpc_id = aws_vpc.statement.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.statement_nat.id
  }
  tags = merge(local.common_tags, { Name = "private-statement-rtb" })
}

resource "aws_route_table_association" "statement_public_assoc" {
  provider = aws.statement
  for_each = aws_subnet.statement_public
  subnet_id = each.value.id
  route_table_id = aws_route_table.statement_public_rt.id
}

resource "aws_route_table_association" "statement_private_assoc" {
  provider = aws.statement
  for_each = aws_subnet.statement_private
  subnet_id = each.value.id
  route_table_id = aws_route_table.statement_private_rt.id
}
