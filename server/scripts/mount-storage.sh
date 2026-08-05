#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

if [[ -f "$PROJECT_ROOT/shared/templates/homelab.env" ]]; then
    # shellcheck disable=SC1091
    source "$PROJECT_ROOT/shared/templates/homelab.env"
else
    echo "[ERROR] Shared environment template not found"
    exit 1
fi

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
echo "[INFO] Verifying audiobook directory structure"

if [[ ! -d "$AUDIOBOOK_MOUNT/Books" ]]; then
    echo "[ERROR] Audiobook storage mounted, but Books directory is missing"
    echo "[ERROR] Check the drive before starting services"
    exit 1
fi

echo "[INFO] Audiobook storage verified"
echo "[INFO] Storage setup completed"
