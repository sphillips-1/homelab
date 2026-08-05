#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if [[ $EUID -eq 0 ]]; then
    SUDO=""
elif command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
else
    echo "[ERROR] This script must be run as root or with sudo available"
    exit 1
fi

for script in \
    "$ROOT_DIR/shared/scripts/install-base.sh" \
    "$ROOT_DIR/shared/scripts/install-docker.sh" \
    "$ROOT_DIR/shared/scripts/install-tailscale.sh" \
    "$SCRIPT_DIR/scripts/mount-storage.sh" \
    "$SCRIPT_DIR/scripts/create-directories.sh"; do
    echo "[INFO] Running $(basename "$script")"
    $SUDO bash "$script"
done

for compose_file in \
    "$SCRIPT_DIR/audiobookshelf/audiobookshelf/compose.yml"; do
    if [[ -f "$compose_file" ]]; then
        echo "[INFO] Deploying $(basename "$(dirname "$compose_file")")"
        $SUDO docker compose -f "$compose_file" up -d
    fi
done

echo
echo "Server role bootstrap complete!"
