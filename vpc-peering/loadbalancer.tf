resource "aws_lb" "customer_lb" {
  provider = aws.customer
  name               = "customer-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.customer_lb_sg.id]
  subnets            = [for s in aws_subnet.customer_public : s.id]
  tags = merge(local.common_tags, { Name = "customer-lb" })
}

resource "aws_lb_target_group" "customer_tg" {
  provider = aws.customer
  name     = "customer-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.customer.id
  health_check {
    path = "/health"
    port = "80"
  }
  tags = merge(local.common_tags, { Name = "customer-tg" })
}

resource "aws_lb_listener" "customer_listener" {
  provider = aws.customer
  load_balancer_arn = aws_lb.customer_lb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.customer_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "customer_a" {
  provider = aws.customer
  for_each = {
    a = aws_instance.customer_service_a.id
    b = aws_instance.customer_service_b.id
  }
  target_group_arn = aws_lb_target_group.customer_tg.arn
  target_id        = each.value
  port             = 80
}

resource "aws_lb" "account_lb" {
  provider = aws.account
  name               = "account-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.account_lb_sg.id]
  subnets            = [for s in aws_subnet.account_public : s.id]
  tags = merge(local.common_tags, { Name = "account-lb" })
}

resource "aws_lb_target_group" "account_tg" {
  provider = aws.account
  name     = "account-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.account.id
  health_check {
    path = "/health"
    port = "80"
  }
  tags = merge(local.common_tags, { Name = "account-tg" })
}

resource "aws_lb_listener" "account_listener" {
  provider = aws.account
  load_balancer_arn = aws_lb.account_lb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.account_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "account_a" {
  provider = aws.account
  for_each = {
    a = aws_instance.account_service_a.id
    b = aws_instance.account_service_b.id
  }
  target_group_arn = aws_lb_target_group.account_tg.arn
  target_id        = each.value
  port             = 80
}

resource "aws_lb" "statement_lb" {
  provider = aws.statement
  name               = "statement-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.statement_lb_sg.id]
  subnets            = [for s in aws_subnet.statement_public : s.id]
  tags = merge(local.common_tags, { Name = "statement-lb" })
}

resource "aws_lb_target_group" "statement_tg" {
  provider = aws.statement
  name     = "statement-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.statement.id
  health_check {
    path = "/health"
    port = "80"
  }
  tags = merge(local.common_tags, { Name = "statement-tg" })
}

resource "aws_lb_listener" "statement_listener" {
  provider = aws.statement
  load_balancer_arn = aws_lb.statement_lb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.statement_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "statement_a" {
  provider = aws.statement
  for_each = {
    a = aws_instance.statement_service_a.id
    b = aws_instance.statement_service_b.id
  }
  target_group_arn = aws_lb_target_group.statement_tg.arn
  target_id        = each.value
  port             = 80
}
