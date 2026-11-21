#!/bin/bash
set -e

ACCOUNT_PRIVATE_IP="10.1.29.149"   # <-- update this

# 1. Install
curl -L https://github.com/nicholasjackson/fake-service/releases/download/v0.26.2/fake_service_linux_amd64.zip -o /tmp/service.zip
sudo apt install unzip -y && sudo unzip /tmp/service.zip -d /tmp/
sudo mv /tmp/fake-service /usr/bin/fake-service
sudo chmod 755 /usr/bin/fake-service

# 2. Configure Service (Points to Account)
sudo tee /etc/systemd/system/customer.service > /dev/null << EOF
[Unit]
Description=Customer Profile Service
After=network.target

[Service]
Environment="LISTEN_ADDR=0.0.0.0:80"
Environment="UPSTREAM_URIS=http://account-service.retail-banking.ayekhant.click"
Environment="NAME=customer-profile-service"
Environment="MESSAGE=HelloCloud | Retail Banking | Customer Profile Service {pass number from script arguments} | Singapore"
ExecStart=/usr/bin/fake-service
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# 3. Start
sudo systemctl daemon-reload
sudo systemctl enable --now customer.service
sudo systemctl status customer.service