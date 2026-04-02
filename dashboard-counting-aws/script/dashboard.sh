#!/bin/bash
set -e

COUNTING_IP="${counting_private_ip}"

# ── Install required tools ────────────────────────────────────────
apt-get update -y
apt-get install -y unzip

# ── Step 1: Save private key ──────────────────────────────────────
mkdir -p /home/ubuntu/.ssh
cat > /home/ubuntu/.ssh/dashboard-keypair.pem << 'KEY'
${private_key_pem}
KEY
chmod 400 /home/ubuntu/.ssh/dashboard-keypair.pem
chown ubuntu:ubuntu /home/ubuntu/.ssh/dashboard-keypair.pem

# ── Step 2: Download both binaries ───────────────────────────────
cd /home/ubuntu

curl -L -O https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/dashboard-service_linux_amd64.zip
unzip dashboard-service_linux_amd64.zip

curl -L -O https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/counting-service_linux_amd64.zip
unzip counting-service_linux_amd64.zip

# ── Step 3: Write counting.sh to disk ────────────────────────────
cat > /home/ubuntu/counting.sh << 'COUNTING'
#!/bin/bash
set -e

mv /home/ubuntu/counting-service_linux_amd64 /usr/bin/counting-service
chmod 755 /usr/bin/counting-service
chown ubuntu:ubuntu /usr/bin/counting-service

cat > /usr/lib/systemd/system/counting-api.service << 'SVC'
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
SVC

systemctl daemon-reload
systemctl enable counting-api.service
systemctl start counting-api.service
COUNTING
chmod +x /home/ubuntu/counting.sh

# ── Step 4: Copy counting binary + script to counting-server ─────
scp -i /home/ubuntu/.ssh/dashboard-keypair.pem \
    -o StrictHostKeyChecking=no \
    /home/ubuntu/counting-service_linux_amd64 \
    ubuntu@$COUNTING_IP:~

scp -i /home/ubuntu/.ssh/dashboard-keypair.pem \
    -o StrictHostKeyChecking=no \
    /home/ubuntu/counting.sh \
    ubuntu@$COUNTING_IP:~

# ── Step 5: Run counting setup remotely ──────────────────────────
ssh -i /home/ubuntu/.ssh/dashboard-keypair.pem \
    -o StrictHostKeyChecking=no \
    ubuntu@$COUNTING_IP \
    "sudo bash /home/ubuntu/counting.sh"

# ── Step 6: Install dashboard binary ─────────────────────────────
mv /home/ubuntu/dashboard-service_linux_amd64 /usr/bin/dashboard-service
chmod 755 /usr/bin/dashboard-service
chown ubuntu:ubuntu /usr/bin/dashboard-service

# ── Step 7: Create dashboard systemd service ─────────────────────
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

# ── Step 8: Enable and start dashboard service ───────────────────
systemctl daemon-reload
systemctl enable dashboard-api.service
systemctl start dashboard-api.service
