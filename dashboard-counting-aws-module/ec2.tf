module "counting_ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.0"

  name = var.counting_instance_name

  instance_type               = var.counting_instance_type
  ami                         = data.aws_ami.ubuntu.id
  key_name                    = module.key_pair.key_pair_name
  vpc_security_group_ids      = [module.counting_sg.security_group_id]
  subnet_id                   = module.dashboard_counting_app_vpc.private_subnets[0]
  associate_public_ip_address = false
  user_data_base64            = base64encode(file("${path.module}/${var.counting_user_data}"))
  user_data_replace_on_change = true
  create_security_group = false

  tags = var.tags
}

module "dashboard_ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.0"

  name = var.dashboard_instance_name

  instance_type               = var.dashboard_instance_type
  ami                         = data.aws_ami.ubuntu.id
  key_name                    = module.key_pair.key_pair_name
  vpc_security_group_ids      = [module.dashboard_sg.security_group_id]
  subnet_id                   = module.dashboard_counting_app_vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data_base64 = base64encode(templatefile("${path.module}/${var.dashboard_user_data}", {
    counting_private_ip = module.counting_ec2_instance.private_ip
  }))
  user_data_replace_on_change = true
  create_security_group = false

  tags = var.tags
}
