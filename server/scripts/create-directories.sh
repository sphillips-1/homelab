#!/usr/bin/env bash

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "[ERROR] Please run this script with sudo"
    exit 1
fi

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

if [[ -f "$PROJECT_ROOT/shared/templates/homelab.env" ]]; then
    # shellcheck disable=SC1091
    source "$PROJECT_ROOT/shared/templates/homelab.env"
else
    echo "[ERROR] Shared environment template not found"
    exit 1
fi

echo "[INFO] Creating homelab directories"

mkdir -p \
  "$HOMELAB_ROOT/audiobookshelf/config" \
  "$HOMELAB_ROOT/audiobookshelf/metadata"

echo "[INFO] Setting ownership"

if id admin >/dev/null 2>&1; then
    chown -R admin:admin "$HOMELAB_ROOT"
else
    echo "[WARN] User 'admin' was not found; skipping ownership change"
fi

echo "[INFO] Directory creation complete"