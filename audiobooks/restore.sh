#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage:"
    echo "restore-audiobookshelf.sh backup.tar.gz"
    exit 1
fi

ARCHIVE="$1"

TMP=$(mktemp -d)

tar -xzf "$ARCHIVE" -C "$TMP"

BACKUP=$(find "$TMP" -mindepth 1 -maxdepth 1 -type d | head -1)

if [ -n "$(docker ps -q --filter 'name=audiobookshelf')" ]; then
    docker stop audiobookshelf
fi

mkdir -p /opt/homelab/audiobookshelf/config
mkdir -p /opt/homelab/audiobookshelf/metadata

echo "[INFO] Restoring config and metadata"

rsync -a --delete \
    "$BACKUP/config/" \
    /opt/homelab/audiobookshelf/config/

rsync -a --delete \
    "$BACKUP/metadata/" \
    /opt/homelab/audiobookshelf/metadata/

docker start audiobookshelf

rm -rf "$TMP"

echo "Restore complete."
