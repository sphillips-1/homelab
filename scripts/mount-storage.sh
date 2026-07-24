#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

source "$PROJECT_ROOT/config/homelab.env"

echo "[INFO] Mounting audiobook storage"

if [[ $EUID -ne 0 ]]; then
    echo "[ERROR] Please run with sudo"
    exit 1
fi

echo "[INFO] Installing exFAT support"

apt update
apt install -y exfatprogs

mkdir -p "$AUDIOBOOK_MOUNT"

if ! grep -q "$AUDIOBOOK_UUID" /etc/fstab; then
    echo "[INFO] Adding fstab entry"

    echo "UUID=$AUDIOBOOK_UUID $AUDIOBOOK_MOUNT exfat defaults,nofail,uid=1000,gid=1000,umask=002 0 0" \
        >> /etc/fstab
else
    echo "[INFO] UUID already exists in fstab"
fi

mount -a

echo
echo "[INFO] Mounted filesystems"

df -h | grep "$AUDIOBOOK_MOUNT"

echo
echo "[INFO] Storage setup complete"