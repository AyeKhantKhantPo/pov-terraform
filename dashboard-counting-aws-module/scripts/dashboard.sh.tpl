#!/bin/bash
set -e

# Terraform will replace this variable automatically
COUNTING_IP="${counting_private_ip}"

# 1. Update and install unzip
apt-get update -y
apt-get install -y unzip

# 2. Download only the dashboard binary
cd /home/ubuntu
curl -L -O https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/dashboard-service_linux_amd64.zip
unzip dashboard-service_linux_amd64.zip

# 3. Install dashboard binary
mv /home/ubuntu/dashboard-service_linux_amd64 /usr/bin/dashboard-service
chmod 755 /usr/bin/dashboard-service
chown ubuntu:ubuntu /usr/bin/dashboard-service

# 4. Create dashboard systemd service (Points to Counting IP on Port 9003)
cat > /usr/lib/systemd/system/dashboard-api.service << EOF
[Unit]
Description=Dashboard API Service
After=syslog.target network.target

[Service]
Environment=PORT=9002
Environment=COUNTING_SERVICE_URL=http://$COUNTING_IP:9003
ExecStart=/usr/bin/dashboard-service
User=ubuntu
Group=ubuntu
ExecStop=/bin/sleep 5
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# 5. Enable and start dashboard service
systemctl daemon-reload
systemctl enable dashboard-api.service
systemctl start dashboard-api.service
