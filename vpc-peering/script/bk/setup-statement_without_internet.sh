#!/bin/bash
set -e

INSTANCE_NUM=${1:-1}

echo "--> [Statement EC2] Setting up binary..."
# 1. Install
sudo mv /tmp/fake-service /usr/bin/fake-service
sudo chmod 755 /usr/bin/fake-service

echo "--> [Statement EC2] Configuring Service..."
# 2. Configure Service
sudo tee /etc/systemd/system/statement.service > /dev/null << EOF
[Unit]
Description=Statement Service
After=network.target

[Service]
Environment="LISTEN_ADDR=0.0.0.0:80"
Environment="NAME=statement-service"
Environment="MESSAGE=Statement Service ${INSTANCE_NUM} | Malaysia"
ExecStart=/usr/bin/fake-service
Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo "--> [Statement EC2] Starting Service..."
# 3. Start
sudo systemctl daemon-reload
sudo systemctl enable --now statement.service
sudo systemctl status statement.service --no-pager