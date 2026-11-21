#!/bin/bash
set -e

# 1. Install
curl -L https://github.com/nicholasjackson/fake-service/releases/download/v0.26.2/fake_service_linux_amd64.zip -o /tmp/service.zip
sudo apt install unzip -y && sudo unzip /tmp/service.zip -d /tmp/
sudo mv /tmp/fake-service /usr/bin/fake-service
sudo chmod 755 /usr/bin/fake-service

# 2. Configure Service
sudo tee /etc/systemd/system/statement.service > /dev/null << EOF
[Unit]
Description=Statement Service
After=network.target

[Service]
Environment="LISTEN_ADDR=0.0.0.0:80"
Environment="NAME=statement-service"
Environment="MESSAGE=Statement Service {pass number from script arguments} | Malaysia"
ExecStart=/usr/bin/fake-service
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# 3. Start
sudo systemctl daemon-reload
sudo systemctl enable --now statement.service
sudo systemctl status statement.service
