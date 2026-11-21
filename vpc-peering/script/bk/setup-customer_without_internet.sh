#!/bin/bash
set -e

# Accept instance number from argument, default to 1 if missing
INSTANCE_NUM=${1:-1}

echo "--> [Customer EC2] Setting up binary..."
# 1. Install (Binary is already pushed to /tmp/ by Bastion)
sudo mv /tmp/fake-service /usr/bin/fake-service
sudo chmod 755 /usr/bin/fake-service

echo "--> [Customer EC2] Configuring Service..."
# 2. Configure Service
sudo tee /etc/systemd/system/customer.service > /dev/null << EOF
[Unit]
Description=Customer Profile Service
After=network.target

[Service]
Environment="LISTEN_ADDR=0.0.0.0:80"
Environment="UPSTREAM_URIS=http://account-service.retail-banking.ayekhant.click"
Environment="NAME=customer-profile-service"
Environment="MESSAGE=HelloCloud | Retail Banking | Customer Profile Service ${INSTANCE_NUM} | Singapore"
ExecStart=/usr/bin/fake-service
Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo "--> [Customer EC2] Starting Service..."
# 3. Start
sudo systemctl daemon-reload
sudo systemctl enable --now customer.service
sudo systemctl status customer.service --no-pager