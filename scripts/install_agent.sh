#!/bin/bash
set -e

# This script installs the AWS CodeDeploy Agent on Ubuntu 22.04.
# It is idempotent and detects the AWS region automatically using IMDSv2.

echo "Starting AWS CodeDeploy Agent installation..."

# 1. Update and install dependencies
echo "Installing dependencies (Ruby, wget)..."
sudo apt-get update -y
sudo apt-get install -y ruby-full wget

# 2. Automatically detect the AWS region using IMDSv2
echo "Detecting AWS region..."
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
REGION=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/region)

if [ -z "$REGION" ]; then
    echo "Error: Could not determine AWS region. Defaulting to us-east-1 (or check IAM/Metadata access)."
    REGION="us-east-1"
fi

echo "Detected region: $REGION"

# 3. Download and run the official installer
INSTALLER_URL="https://aws-codedeploy-${REGION}.s3.${REGION}.amazonaws.com/latest/install"

echo "Downloading installer from $INSTALLER_URL..."
cd /tmp
wget -q $INSTALLER_URL -O install_agent
chmod +x ./install_agent

# 4. Run installer (the 'auto' flag handles idempotency and updates)
sudo ./install_agent auto

# 5. Ensure service starts and verify status
sudo systemctl enable codedeploy-agent
sudo systemctl start codedeploy-agent

echo "Installation complete. Verifying status:"
sudo systemctl status codedeploy-agent --no-pager