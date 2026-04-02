# -------------------------------------------------------
# EC2: counting-server
# Private subnet — no internet access
# Binary will be sent from dashboard-server via SCP
# -------------------------------------------------------
resource "aws_instance" "counting_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.counting_instance_type
  subnet_id                   = aws_subnet.counting_private_subnet.id
  key_name                    = aws_key_pair.dashboard_key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.counting_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "counting-server"
  }
}

# -------------------------------------------------------
# EC2: dashboard-server
# Public subnet — has internet access
# Handles ALL downloads and sets up counting-server remotely
# -------------------------------------------------------
resource "aws_instance" "dashboard_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.dashboard_instance_type
  subnet_id                   = aws_subnet.dashboard_public_subnet.id
  key_name                    = aws_key_pair.dashboard_key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.dashboard_sg.id]
  associate_public_ip_address = true

  depends_on = [aws_instance.counting_server]

  user_data = templatefile("${path.module}/script/dashboard.sh", {
    counting_private_ip = aws_instance.counting_server.private_ip
    private_key_pem     = tls_private_key.dashboard_key.private_key_pem
  })

  tags = {
    Name = "dashboard-server"
  }
}