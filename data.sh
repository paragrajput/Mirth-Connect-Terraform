#!/bin/bash

MIRTH_URL="https://s3.amazonaws.com/downloads.mirthcorp.com/connect/4.5.0.b3012/mirthconnect-4.5.0.b3012-unix.tar.gz"

# Installation directory (modify as desired)
MIRTH_INSTALL_DIR="/opt/mirthconnect"

sudo mkdir -p "$MIRTH_INSTALL_DIR"

# Check for dependencies (adjust for your distribution)
if [ -f /etc/os-release ]; then  # For systems using /etc/os-release
  ID=$(grep -oP '^ID=.*' /etc/os-release | cut -d= -f2)
  if [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt-get install -y curl wget libunwind8 libicu60 libgpm-dev
    sudo apt install openjdk-17-jre-headless -y
  elif [[ "$ID" == "centos" || "$ID" == "redhat" || "$ID" == "fedora" || "$ID" == "rhel" ]]; then
    sudo yum install -y curl wget libunwind libicu gpm

  fi
else  # Handle other distributions (add checks as needed)
  echo "Warning: Distribution detection failed. You might need to install dependencies manually."
fi

# Download Mirth installer
sudo wget -O mirthconnect.tar.gz "$MIRTH_URL"

# Install Mirth
sudo tar -xvf mirthconnect.tar.gz -C "$MIRTH_INSTALL_DIR"

# Start Mirth Service
cd "$MIRTH_INSTALL_DIR"/Mirth\ Connect/
sudo mkdir appdata
./mcservice start
