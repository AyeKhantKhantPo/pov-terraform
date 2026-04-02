# Generates a key pair so you can SSH into dashboard-server
resource "tls_private_key" "dashboard_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "dashboard_key_pair" {
  key_name   = "dashboard-key-pair"
  public_key = tls_private_key.dashboard_key.public_key_openssh
}

resource "local_file" "dashboard_private_key" {
  content         = tls_private_key.dashboard_key.private_key_pem
  filename        = ".ssh/dashboard-key-pair.pem" # stored in .ssh/ folder
  file_permission = "0400"
}