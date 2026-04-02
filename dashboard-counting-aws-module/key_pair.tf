module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "2.1.1"

  key_name           = var.key_name
  create_private_key = true
}

# This resource saves the private key to a file on local machine
resource "local_file" "private_key" {
  content         = module.key_pair.private_key_pem
  filename        = "${path.module}/.ssh/${var.key_name}.pem"
  file_permission = "0400" # Sets correct permissions for SSH
}
