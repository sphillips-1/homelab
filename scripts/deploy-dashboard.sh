#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_ROOT/config/homelab.env"

echo "[INFO] Deploying Homepage dashboard"

docker compose \
  -f "$PROJECT_ROOT/compose/dashboard/compose.yml" \
  up -d

echo "[INFO] Dashboard deployed"