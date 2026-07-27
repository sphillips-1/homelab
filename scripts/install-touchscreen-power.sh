#!/bin/bash

set -euo pipefail

SERVICE_NAME="touchscreen-power"
INSTALL_DIR="/opt/homelab/services/${SERVICE_NAME}"
VENV_DIR="/opt/homelab/venvs/${SERVICE_NAME}"

echo "Installing touchscreen power manager..."

sudo apt update

sudo apt install -y \
    python3 \
    python3-venv \
    python3-pip

sudo mkdir -p "$INSTALL_DIR"
sudo mkdir -p "$VENV_DIR"

sudo cp -r "services/${SERVICE_NAME}/"* "$INSTALL_DIR/"

sudo python3 -m venv "$VENV_DIR"

sudo "$VENV_DIR/bin/pip" install \
    --upgrade pip

sudo "$VENV_DIR/bin/pip" install \
    -r "$INSTALL_DIR/requirements.txt"

sudo cp \
    "services/${SERVICE_NAME}/${SERVICE_NAME}.service" \
    "/etc/systemd/system/${SERVICE_NAME}.service"

sudo systemctl daemon-reload

sudo systemctl enable "$SERVICE_NAME"

sudo systemctl restart "$SERVICE_NAME"

echo "Touchscreen power manager installed successfully"