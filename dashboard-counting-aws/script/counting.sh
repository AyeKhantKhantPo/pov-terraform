#!/bin/bash
set -e

# ── Move binary to /usr/bin ───────────────────────────────────────
# Binary is already unzipped and SCP'd by dashboard-server
mv /home/ubuntu/counting-service_linux_amd64 /usr/bin/counting-service
chmod 755 /usr/bin/counting-service
chown ubuntu:ubuntu /usr/bin/counting-service

# ── Create systemd service file ───────────────────────────────────
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

# ── Enable and start service ──────────────────────────────────────
systemctl daemon-reload
systemctl enable counting-api.service
systemctl start counting-api.service