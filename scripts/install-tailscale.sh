#!/usr/bin/env bash

set -euo pipefail

echo "[INFO] Starting Tailscale installation"

if [[ $EUID -ne 0 ]]; then
    echo "[ERROR] Please run this script with sudo"
    exit 1
fi

echo "[INFO] Installing Tailscale"

curl -fsSL https://tailscale.com/install.sh | sh

echo "[INFO] Enabling Tailscale service"

systemctl enable tailscaled
systemctl start tailscaled

echo
echo "[INFO] Tailscale installed"
echo
echo "Run the following command to authenticate:"
echo
echo "    sudo tailscale up"