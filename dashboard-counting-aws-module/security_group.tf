module "dashboard_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = var.dashboard_sg_name
  description = var.dashboard_sg_description
  vpc_id      = module.dashboard_counting_app_vpc.vpc_id

  # Ingress rules (Port 22 and Port 9002 from anywhere)
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH access from anywhere"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 9002
      to_port     = 9002
      protocol    = "tcp"
      description = "Dashboard App Custom TCP"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  # Egress rule: Allows the instance to send traffic out to the internet
  egress_rules = ["all-all"]

  tags = var.tags
}

module "counting_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"

  name        = var.counting_sg_name
  description = var.counting_sg_description
  vpc_id      = module.dashboard_counting_app_vpc.vpc_id

  # Ingress rules (Port 22 and 9002, but restricted ONLY to Dashboard's traffic)
  computed_ingress_with_source_security_group_id = [
    {
      from_port                = 22
      to_port                  = 22
      protocol                 = "tcp"
      description              = "SSH access ONLY from Dashboard"
      source_security_group_id = module.dashboard_sg.security_group_id
    },
    {
      from_port                = 9003
      to_port                  = 9003
      protocol                 = "tcp"
      description              = "Counting App Custom TCP ONLY from Dashboard"
      source_security_group_id = module.dashboard_sg.security_group_id
    }
  ]
  # Required by the Terraform module when using computed source SGs
  number_of_computed_ingress_with_source_security_group_id = 2

  # Egress rule: Allows the instance to reach the NAT Gateway to download updates/packages
  egress_rules = ["all-all"]

  tags = var.tags
}
