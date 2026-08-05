#!/usr/bin/env bash

set -euo pipefail

if [[ $EUID -eq 0 ]]; then
    SUDO=""
elif command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
else
    echo "[ERROR] This script must be run as root or with sudo available"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if [[ -f "$ROOT_DIR/shared/templates/homelab.env" ]]; then
    # shellcheck disable=SC1091
    source "$ROOT_DIR/shared/templates/homelab.env"
else
    echo "[ERROR] Shared environment template not found"
    exit 1
fi

echo "[INFO] Installing test dependencies"
$SUDO apt update
$SUDO apt install -y rsync

echo "[INFO] Installing Docker"
$SUDO bash "$ROOT_DIR/shared/scripts/install-docker.sh"

echo "[INFO] Mounting audiobook storage"
$SUDO bash "$SCRIPT_DIR/scripts/mount-storage.sh"

echo "[INFO] Creating audiobook directories"
$SUDO bash "$SCRIPT_DIR/scripts/create-directories.sh"

echo "[INFO] Deploying Audiobookshelf stack"
COMPOSE_FILE="$SCRIPT_DIR/audiobookshelf/audiobookshelf/compose.yml"
if [[ -f "$COMPOSE_FILE" ]]; then
    $SUDO docker compose -f "$COMPOSE_FILE" up -d
else
    echo "[ERROR] Compose file not found: $COMPOSE_FILE"
    exit 1
fi

echo
echo "Test bootstrap complete. You can now verify backup and restore with backup.sh and restore.sh."
