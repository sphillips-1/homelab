#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "[INFO] Deploying Audiobookshelf"

docker compose \
  -f "$PROJECT_ROOT/compose/audiobookshelf/compose.yml" \
  up -d