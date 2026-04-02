module "dashboard_counting_app_vpc" {
  # variables cannot be changed, must same with variables defined in modules's variables
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  name = var.vpc_name
  cidr = var.cidr
  azs  = var.azs

  public_subnets  = var.public_subnets_for_dashboard
  private_subnets = var.private_subnets_for_counting

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  tags                = var.tags
  public_subnet_tags  = var.public_subnet_tags_for_dashboard
  private_subnet_tags = var.private_subnet_tags_for_counting
}
