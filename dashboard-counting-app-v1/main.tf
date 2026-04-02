module "dashboard_vpc" {
  source         = "terraform-aws-modules/vpc/aws"
  version        = "6.6.0"
  name           = var.dashboard_name
  cidr           = var.dashboard_cidr
  public_subnets = var.public_subnets_dashboard
  azs            = var.dashboard_azs
}

module "counting-vpc" {
  source         = "terraform-aws-modules/vpc/aws"
  version        = "6.6.0"
  name           = var.counting_name
  cidr           = var.counting_cidr
  public_subnets = var.public_subnets_counting
  azs            = var.counting_azs
}

