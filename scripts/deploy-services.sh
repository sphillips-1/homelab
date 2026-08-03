#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -f "$PROJECT_ROOT/config/homelab.env" ]]; then
    # shellcheck disable=SC1091
    source "$PROJECT_ROOT/config/homelab.env"
fi

echo "[INFO] Verifying audiobook storage"

if [[ ! -d "$AUDIOBOOK_MOUNT/Books" ]]; then
    echo "[WARN] Audiobook storage is not mounted"
    echo "[WARN] Expected: $AUDIOBOOK_MOUNT/Books"
    echo "[WARN] Skipping audiobook deployment check"
else
    echo "[INFO] Audiobook storage available"
fi

echo "[INFO] Deploying compose stacks"

for compose_file in \
    "$PROJECT_ROOT/compose/audiobookshelf/compose.yml" \
    "$PROJECT_ROOT/compose/dashboard/compose.yml"; do
    if [[ -f "$compose_file" ]]; then
        echo "[INFO] Deploying $(basename "$(dirname "$compose_file")")"
        docker compose -f "$compose_file" up -d
    fi
done

echo "[INFO] Deployment complete"
