#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "[INFO] Verifying homelab setup"

echo "[INFO] Docker:"
docker --version

echo "[INFO] Compose:"
docker compose version

echo "[INFO] Repository:"
echo "$PROJECT_ROOT"

echo "[INFO] Verification complete"