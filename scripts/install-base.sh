#!/usr/bin/env bash

set -euo pipefail

echo "[INFO] Starting base system setup"

if [[ $EUID -ne 0 ]]; then
    echo "[ERROR] Please run this script with sudo"
    exit 1
fi

echo "[INFO] Updating package lists"
apt update

echo "[INFO] Installing base packages"
apt install -y \
    git \
    curl \
    wget \
    vim \
    nano \
    htop \
    jq \
    unzip \
    ca-certificates \
    gnupg \
    lsb-release \
    smartmontools \
    tree

echo "[INFO] Setting timezone"
timedatectl set-timezone America/New_York

echo "[INFO] Creating homelab directories"

mkdir -p /opt/homelab

chown -R admin:admin /opt/homelab

echo "[INFO] Base setup complete"

echo
echo "Installed:"
echo "- Base packages"
echo "- Timezone configured"
echo "- /opt/homelab created"
