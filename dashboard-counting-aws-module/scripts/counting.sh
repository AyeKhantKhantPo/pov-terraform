#!/bin/bash
set -e

# 1. Update and install unzip
apt-get update -y
apt-get install -y unzip

# 2. Download and unzip counting binary
cd /home/ubuntu
curl -L -O https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/counting-service_linux_amd64.zip
unzip counting-service_linux_amd64.zip

# 3. Move binary to /usr/bin
mv /home/ubuntu/counting-service_linux_amd64 /usr/bin/counting-service
chmod 755 /usr/bin/counting-service
chown ubuntu:ubuntu /usr/bin/counting-service

# 4. Create systemd service file (Runs on Port 9003)
cat > /usr/lib/systemd/system/counting-api.service << 'EOF'
[Unit]
Description=Counting API Service
After=syslog.target network.target

[Service]
Environment=PORT=9003
ExecStart=/usr/bin/counting-service
User=ubuntu
Group=ubuntu
ExecStop=/bin/sleep 5
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# 5. Enable and start service
systemctl daemon-reload
systemctl enable counting-api.service
systemctl start counting-api.service