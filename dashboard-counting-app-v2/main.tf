module "dashboard_vpc" {
  # variables cannot be changed, must same with variables defined in modules's variables
  source              = "terraform-aws-modules/vpc/aws"
  version             = "6.6.0"
  name                = var.dashboard_name
  cidr                = var.dashboard_cidr
  public_subnets      = var.public_subnets_for_dashboard
  azs                 = var.dashboard_azs
  private_subnets     = var.private_subnets_for_dashboard
  enable_nat_gateway  = var.enable_nat_gateway
  single_nat_gateway  = var.single_nat_gateway
  tags                = var.tags
  public_subnet_tags  = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags
}
