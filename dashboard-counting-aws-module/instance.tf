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

  # Must wait for counting-server to exist first
  # so its private IP is available for SCP and SSH commands
  depends_on = [aws_instance.counting_server]

  user_data = <<-EOF
    #!/bin/bash
    set -e

    # ── Install required tools first ─────────────────────────────
    apt-get update -y
    apt-get install -y unzip

    # ── Step 1: Save private key on this server ──────────────────
    mkdir -p /home/ubuntu/.ssh
    cat <<'KEY' > /home/ubuntu/.ssh/dashboard-key-pair.pem
    ${tls_private_key.dashboard_key.private_key_pem}
    KEY
    chmod 400 /home/ubuntu/.ssh/dashboard-key-pair.pem
    chown ubuntu:ubuntu /home/ubuntu/.ssh/dashboard-key-pair.pem

    # ── Step 2: Download both binaries ───────────────────────────
    cd /home/ubuntu

    curl -L -O https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/dashboard-service_linux_amd64.zip
    unzip dashboard-service_linux_amd64.zip

    curl -L -O https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/counting-service_linux_amd64.zip
    unzip counting-service_linux_amd64.zip

    # ── Step 3: Copy counting binary to counting-server ──────────
    scp -i /home/ubuntu/.ssh/dashboard-key-pair.pem \
        -o StrictHostKeyChecking=no \
        /home/ubuntu/counting-service_linux_amd64 \
        ubuntu@${aws_instance.counting_server.private_ip}:~

    # ── Step 4: Start counting service on counting-server ────────
    ssh -i /home/ubuntu/.ssh/dashboard-key-pair.pem \
        -o StrictHostKeyChecking=no \
        ubuntu@${aws_instance.counting_server.private_ip} \
        "nohup env PORT=9003 ./counting-service_linux_amd64 > /tmp/counting.log 2>&1 &"

    # ── Step 5: Start dashboard service on this server ───────────
    nohup env PORT=9002 \
        COUNTING_SERVICE_URL=http://${aws_instance.counting_server.private_ip}:9003 \
        ./dashboard-service_linux_amd64 > /tmp/dashboard.log 2>&1 &
  EOF

  tags = {
    Name = "dashboard-server"
  }
}