resource "aws_route53_record" "customer_record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "customer-profile.retail-banking.ayekhant.click"
  type    = "A"
    alias {
      name = aws_lb.customer_lb.dns_name
      zone_id = aws_lb.customer_lb.zone_id
      evaluate_target_health = true
    }
}

resource "aws_route53_record" "account_record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "account.retail-banking.ayekhant.click"
  type    = "A"
    alias {
      name = aws_lb.account_lb.dns_name
      zone_id = aws_lb.account_lb.zone_id
      evaluate_target_health = true
    }
}

resource "aws_route53_record" "account_service_record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "account-service.retail-banking.ayekhant.click"
  type    = "A"
  alias {
    name = aws_lb.account_lb.dns_name
    zone_id = aws_lb.account_lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "statement_record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "statement.retail-banking.ayekhant.click"
  type    = "A"
    alias {
      name = aws_lb.statement_lb.dns_name
      zone_id = aws_lb.statement_lb.zone_id
      evaluate_target_health = true
    }
}

resource "aws_route53_record" "statement_service_record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "statement-service.retail-banking.ayekhant.click"
  type    = "A"
  alias {
    name = aws_lb.statement_lb.dns_name
    zone_id = aws_lb.statement_lb.zone_id
    evaluate_target_health = true
  }
}

/* Private hosted zone for intra-VPC service discovery over peering */
resource "aws_route53_zone" "private_retail" {
  name = "retail-banking.ayekhant.click"
  vpc {
    vpc_id = aws_vpc.customer.id
    vpc_region = "ap-southeast-1"
  }
  comment = "Private zone for retail-banking service discovery"
}

resource "aws_route53_zone_association" "private_retail_account" {
  zone_id = aws_route53_zone.private_retail.zone_id
  vpc_id  = aws_vpc.account.id
  vpc_region = "ap-southeast-5"
}

resource "aws_route53_zone_association" "private_retail_statement" {
  zone_id = aws_route53_zone.private_retail.zone_id
  vpc_id  = aws_vpc.statement.id
  vpc_region = "ap-southeast-7"
}

resource "aws_route53_record" "account_service_private" {
  zone_id = aws_route53_zone.private_retail.zone_id
  name    = "account-service.retail-banking.ayekhant.click"
  type    = "A"
  alias {
    name = aws_lb.account_lb.dns_name
    zone_id = aws_lb.account_lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "statement_service_private" {
  zone_id = aws_route53_zone.private_retail.zone_id
  name    = "statement-service.retail-banking.ayekhant.click"
  type    = "A"
  alias {
    name = aws_lb.statement_lb.dns_name
    zone_id = aws_lb.statement_lb.zone_id
    evaluate_target_health = true
  }
}
