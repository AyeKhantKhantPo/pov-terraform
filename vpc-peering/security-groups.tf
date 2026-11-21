resource "aws_security_group" "bastion_sg" {
  provider = aws.customer
  name   = "bastion-host-sg"
  vpc_id = aws_vpc.customer.id
  description = "Allow SSH from my IP"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_public_ip]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, { Name = "bastion-host-sg" })
}

resource "aws_security_group" "customer_lb_sg" {
  provider = aws.customer
  name = "customer-lb-sg"
  vpc_id = aws_vpc.customer.id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, { Name = "customer-lb-sg" })
}

resource "aws_security_group" "customer_sg" {
  provider = aws.customer
  name = "customer-sg"
  vpc_id = aws_vpc.customer.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.customer_lb_sg.id]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, { Name = "customer-sg" })
}

resource "aws_security_group" "account_lb_sg" {
  provider = aws.account
  name = "account-lb-sg"
  vpc_id = aws_vpc.account.id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, { Name = "account-lb-sg" })
}

resource "aws_security_group" "account_sg" {
  provider = aws.account
  name = "account-sg"
  vpc_id = aws_vpc.account.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [aws_vpc.customer.cidr_block]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.account_lb_sg.id]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, { Name = "account-sg" })
}

resource "aws_security_group" "statement_lb_sg" {
  provider = aws.statement
  name = "statement-lb-sg"
  vpc_id = aws_vpc.statement.id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, { Name = "statement-lb-sg" })
}

resource "aws_security_group" "statement_sg" {
  provider = aws.statement
  name = "statement-sg"
  vpc_id = aws_vpc.statement.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [aws_vpc.account.cidr_block]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.statement_lb_sg.id]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.common_tags, { Name = "statement-sg" })
}
