#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ $EUID -eq 0 ]]; then
    SUDO=""
elif command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
else
    echo "[ERROR] This script must be run as root or with sudo available"
    exit 1
fi

for script in \
    "$SCRIPT_DIR/scripts/install-base.sh" \
    "$SCRIPT_DIR/scripts/install-docker.sh" \
    "$SCRIPT_DIR/scripts/install-tailscale.sh" \
    "$SCRIPT_DIR/scripts/mount-storage.sh" \
    "$SCRIPT_DIR/scripts/create-directories.sh" \
    "$SCRIPT_DIR/scripts/deploy-services.sh" \
    "$SCRIPT_DIR/scripts/setup-touchscreen.sh"; do
    echo "[INFO] Running $(basename "$script")"
    $SUDO bash "$script"
done

echo
echo "Homelab bootstrap complete!"