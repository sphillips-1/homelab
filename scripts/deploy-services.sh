#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_ROOT/config/homelab.env"

echo "[INFO] Verifying audiobook storage"

if [[ ! -d "$AUDIOBOOK_MOUNT/Books" ]]; then
    echo "[ERROR] Audiobook storage is not mounted"
    echo "[ERROR] Expected: $AUDIOBOOK_MOUNT/Books"
    exit 1
fi

echo "[INFO] Deploying Audiobookshelf"

docker compose \
  -f "$PROJECT_ROOT/compose/audiobookshelf/compose.yml" \
  up -d
