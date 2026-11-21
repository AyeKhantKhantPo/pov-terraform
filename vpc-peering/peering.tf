resource "aws_vpc_peering_connection" "customer_to_account" {
  provider = aws.customer
  vpc_id = aws_vpc.customer.id
  peer_vpc_id = aws_vpc.account.id
  peer_region = "ap-southeast-5"
  auto_accept = false
  tags = merge(local.common_tags, { Name = "pcx-customer-to-account" })
}

resource "aws_vpc_peering_connection_accepter" "customer_to_account_accept" {
  provider = aws.account
  vpc_peering_connection_id = aws_vpc_peering_connection.customer_to_account.id
  auto_accept = true
  tags = merge(local.common_tags, { Name = "pcx-customer-to-account-accepter" })
}

resource "aws_vpc_peering_connection" "account_to_statement" {
  provider = aws.account
  vpc_id = aws_vpc.account.id
  peer_vpc_id = aws_vpc.statement.id
  peer_region = "ap-southeast-7"
  auto_accept = false
  tags = merge(local.common_tags, { Name = "pcx-account-to-statement" })
}

resource "aws_vpc_peering_connection_accepter" "account_to_statement_accept" {
  provider = aws.statement
  vpc_peering_connection_id = aws_vpc_peering_connection.account_to_statement.id
  auto_accept = true
  tags = merge(local.common_tags, { Name = "pcx-account-to-statement-accepter" })
}

/* Add a single route in public and private route tables for each VPC to point to the peer VPC via the peering connection. */

resource "aws_route" "customer_to_account_public_route" {
  provider = aws.customer
  route_table_id = aws_route_table.customer_public_rt.id
  destination_cidr_block = aws_vpc.account.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.customer_to_account.id
}

resource "aws_route" "customer_to_account_private_route" {
  provider = aws.customer
  route_table_id = aws_route_table.customer_private_rt.id
  destination_cidr_block = aws_vpc.account.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.customer_to_account.id
}

resource "aws_route" "account_from_customer_public_route" {
  provider = aws.account
  route_table_id = aws_route_table.account_public_rt.id
  destination_cidr_block = aws_vpc.customer.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.customer_to_account.id
}

resource "aws_route" "account_from_customer_private_route" {
  provider = aws.account
  route_table_id = aws_route_table.account_private_rt.id
  destination_cidr_block = aws_vpc.customer.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.customer_to_account.id
}

resource "aws_route" "account_to_statement_public_route" {
  provider = aws.account
  route_table_id = aws_route_table.account_public_rt.id
  destination_cidr_block = aws_vpc.statement.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.account_to_statement.id
}

resource "aws_route" "account_to_statement_private_route" {
  provider = aws.account
  route_table_id = aws_route_table.account_private_rt.id
  destination_cidr_block = aws_vpc.statement.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.account_to_statement.id
}

resource "aws_route" "statement_from_account_public_route" {
  provider = aws.statement
  route_table_id = aws_route_table.statement_public_rt.id
  destination_cidr_block = aws_vpc.account.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.account_to_statement.id
}

resource "aws_route" "statement_from_account_private_route" {
  provider = aws.statement
  route_table_id = aws_route_table.statement_private_rt.id
  destination_cidr_block = aws_vpc.account.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.account_to_statement.id
}
