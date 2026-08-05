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

docker stop audiobookshelf

mkdir -p /opt/homelab/audiobookshelf/config

rsync -a --delete \
    "$BACKUP/config/" \
    /opt/homelab/audiobookshelf/config/

docker start audiobookshelf

rm -rf "$TMP"

echo "Restore complete."