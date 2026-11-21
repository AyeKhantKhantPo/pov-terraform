#!/bin/bash
set -e

INSTANCE_NUM=${1:-1}

echo "--> [Account EC2] Setting up binary..."
# 1. Install
sudo mv /tmp/fake-service /usr/bin/fake-service
sudo chmod 755 /usr/bin/fake-service

echo "--> [Account EC2] Configuring Service..."
# 2. Configure Service
sudo tee /etc/systemd/system/account.service > /dev/null << EOF
[Unit]
Description=Account Service
After=network.target

[Service]
Environment="LISTEN_ADDR=0.0.0.0:80"
Environment="UPSTREAM_URIS=http://statement-service.retail-banking.ayekhant.click"
Environment="NAME=account-service"
Environment="MESSAGE=Account Service ${INSTANCE_NUM} | Singapore"
ExecStart=/usr/bin/fake-service
Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo "--> [Account EC2] Starting Service..."
# 3. Start
sudo systemctl daemon-reload
sudo systemctl enable --now account.service
sudo systemctl status account.service --no-pager