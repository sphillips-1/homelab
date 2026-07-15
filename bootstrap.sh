#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo "$SCRIPT_DIR/scripts/install-base.sh"
sudo "$SCRIPT_DIR/scripts/install-docker.sh"
sudo "$SCRIPT_DIR/scripts/install-tailscale.sh"
sudo "$SCRIPT_DIR/scripts/mount-storage.sh"
sudo "$SCRIPT_DIR/scripts/create-directories.sh"
sudo "$SCRIPT_DIR/scripts/deploy-services.sh"

echo
echo "Homelab bootstrap complete!"