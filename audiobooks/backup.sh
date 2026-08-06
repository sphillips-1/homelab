#!/usr/bin/env bash
set -euo pipefail

BACKUP_ROOT="/mnt/audiobooks/backups"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

BACKUP_DIR="${BACKUP_ROOT}/audiobookshelf-${TIMESTAMP}"

echo "Creating backup..."

mkdir -p "$BACKUP_DIR"

if [ -n "$(docker ps -q --filter 'name=audiobookshelf')" ]; then
    docker stop audiobookshelf
fi

mkdir -p /opt/homelab/audiobookshelf/config
mkdir -p /opt/homelab/audiobookshelf/metadata

rsync -a \
    /opt/homelab/audiobookshelf/config/ \
    "$BACKUP_DIR/config/"

rsync -a \
    /opt/homelab/audiobookshelf/metadata/ \
    "$BACKUP_DIR/metadata/"

docker start audiobookshelf

cat > "$BACKUP_DIR/manifest.txt" <<EOF
Backup Time: $(date)
Hostname: $(hostname)
ABS Config: /opt/homelab/audiobookshelf/config
ABS Metadata: /opt/homelab/audiobookshelf/metadata
EOF

tar -czf "${BACKUP_DIR}.tar.gz" \
    -C "$BACKUP_ROOT" \
    "audiobookshelf-${TIMESTAMP}"

rm -rf "$BACKUP_DIR"

echo
echo "Backup created:"
echo "${BACKUP_DIR}.tar.gz"
