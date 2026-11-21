resource "tls_private_key" "customer_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "account_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "statement_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "customer_private_key" {
  content  = tls_private_key.customer_key.private_key_pem
  filename = "${path.module}/${var.key_output_dir}/customer-key.pem"
  file_permission = "0600"
}

resource "local_file" "account_private_key" {
  content  = tls_private_key.account_key.private_key_pem
  filename = "${path.module}/${var.key_output_dir}/account-key.pem"
  file_permission = "0600"
}

resource "local_file" "statement_private_key" {
  content  = tls_private_key.statement_key.private_key_pem
  filename = "${path.module}/${var.key_output_dir}/statement-key.pem"
  file_permission = "0600"
}

resource "aws_key_pair" "customer" {
  provider = aws.customer
  key_name   = "customer-keypair"
  public_key = tls_private_key.customer_key.public_key_openssh
  tags = merge(local.common_tags, { Name = "customer-keypair" })
}

resource "aws_key_pair" "account" {
  provider = aws.account
  key_name   = "account-keypair"
  public_key = tls_private_key.account_key.public_key_openssh
  tags = merge(local.common_tags, { Name = "account-keypair" })
}

resource "aws_key_pair" "statement" {
  provider = aws.statement
  key_name   = "statement-keypair"
  public_key = tls_private_key.statement_key.public_key_openssh
  tags = merge(local.common_tags, { Name = "statement-keypair" })
}
