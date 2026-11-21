#!/bin/bash
set -e

# --- CONFIGURATION ---
# Update these IPs to match your private EC2 instances
CUSTOMER_IP="10.1.x.x"
ACCOUNT_IP="10.1.x.y"
STATEMENT_IP="10.1.x.z"

SSH_USER="ubuntu" # Change to 'ec2-user' if using Amazon Linux
SSH_KEY="/home/ubuntu/your-key.pem" # Path to your private key on the bastion

echo "==> [Bastion] Updating and installing unzip..."
sudo apt-get update -y
sudo apt-get install unzip -y

echo "==> [Bastion] Downloading fake-service..."
curl -L https://github.com/nicholasjackson/fake-service/releases/download/v0.26.2/fake_service_linux_amd64.zip -o /tmp/service.zip

echo "==> [Bastion] Extracting fake-service..."
unzip -o /tmp/service.zip -d /tmp/

# Helper function to deploy and execute scripts remotely
deploy_to_node() {
    local NODE_IP=$1
    local SCRIPT_NAME=$2
    local INSTANCE_NUM=$3

    echo "---------------------------------------------------"
    echo "==> Deploying to $NODE_IP ($SCRIPT_NAME)..."
    
    # 1. Copy the unzipped binary to the private instance
    scp -i "$SSH_KEY" -o StrictHostKeyChecking=no /tmp/fake-service "$SSH_USER@$NODE_IP:/tmp/fake-service"
    
    # 2. Copy the setup script to the private instance
    scp -i "$SSH_KEY" -o StrictHostKeyChecking=no "$SCRIPT_NAME" "$SSH_USER@$NODE_IP:/tmp/$SCRIPT_NAME"
    
    # 3. Execute the setup script with the instance number argument
    ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no "$SSH_USER@$NODE_IP" "bash /tmp/$SCRIPT_NAME $INSTANCE_NUM"
    
    echo "==> Finished deploying to $NODE_IP"
}

# Deploy to Customer EC2 (Passing '1' as instance number)
deploy_to_node "$CUSTOMER_IP" "setup_customer.sh" "1"

# Deploy to Account EC2 (Passing '1' as instance number)
deploy_to_node "$ACCOUNT_IP" "setup_account.sh" "1"

# Deploy to Statement EC2 (Passing '1' as instance number)
deploy_to_node "$STATEMENT_IP" "setup_statement.sh" "1"

echo "==================================================="
echo "All deployments successfully completed from Bastion!"