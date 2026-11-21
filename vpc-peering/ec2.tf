resource "aws_instance" "bastion" {
  provider = aws.customer
  ami = data.aws_ami.ubuntu_customer.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.customer_public[local.vpcs.customer.public_subnets[0].name].id
  key_name = aws_key_pair.customer.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  tags = merge(local.common_tags, { Name = "bastion-host" })
}

resource "aws_instance" "customer_service_a" {
  provider = aws.customer
  ami = data.aws_ami.ubuntu_customer.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.customer_private[local.vpcs.customer.private_subnets[0].name].id
  key_name = aws_key_pair.customer.key_name
  vpc_security_group_ids = [aws_security_group.customer_sg.id]
  user_data = file("script/setup-customer.sh")
  tags = merge(local.common_tags, { Name = "customer-profile-service1" })
}

resource "aws_instance" "customer_service_b" {
  provider = aws.customer
  ami = data.aws_ami.ubuntu_customer.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.customer_private[local.vpcs.customer.private_subnets[1].name].id
  key_name = aws_key_pair.customer.key_name
  vpc_security_group_ids = [aws_security_group.customer_sg.id]
  user_data = file("script/setup-customer.sh")
  tags = merge(local.common_tags, { Name = "customer-profile-service2" })
}

resource "aws_instance" "account_service_a" {
  provider = aws.account
  ami = data.aws_ami.ubuntu_account.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.account_private[local.vpcs.account.private_subnets[0].name].id
  key_name = aws_key_pair.account.key_name
  vpc_security_group_ids = [aws_security_group.account_sg.id]
  user_data = file("script/setup-account.sh")
  tags = merge(local.common_tags, { Name = "account-service1" })
}

resource "aws_instance" "account_service_b" {
  provider = aws.account
  ami = data.aws_ami.ubuntu_account.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.account_private[local.vpcs.account.private_subnets[1].name].id
  key_name = aws_key_pair.account.key_name
  vpc_security_group_ids = [aws_security_group.account_sg.id]
  user_data = file("script/setup-account.sh")
  tags = merge(local.common_tags, { Name = "account-service2" })
}

resource "aws_instance" "statement_service_a" {
  provider = aws.statement
  ami = data.aws_ami.ubuntu_statement.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.statement_private[local.vpcs.statement.private_subnets[0].name].id
  key_name = aws_key_pair.statement.key_name
  vpc_security_group_ids = [aws_security_group.statement_sg.id]
  user_data = file("script/setup-statement.sh")
  tags = merge(local.common_tags, { Name = "statement-service1" })
}

resource "aws_instance" "statement_service_b" {
  provider = aws.statement
  ami = data.aws_ami.ubuntu_statement.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.statement_private[local.vpcs.statement.private_subnets[1].name].id
  key_name = aws_key_pair.statement.key_name
  vpc_security_group_ids = [aws_security_group.statement_sg.id]
  user_data = file("script/setup-statement.sh")
  tags = merge(local.common_tags, { Name = "statement-service2" })
}
