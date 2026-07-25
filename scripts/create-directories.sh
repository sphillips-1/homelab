#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_ROOT/config/homelab.env"

echo "[INFO] Creating homelab directories"

sudo mkdir -p \
  "$HOMELAB_ROOT/audiobookshelf/config" \
  "$HOMELAB_ROOT/audiobookshelf/metadata"

echo "[INFO] Setting ownership"

sudo chown -R admin:admin "$HOMELAB_ROOT"

echo "[INFO] Directory creation complete"