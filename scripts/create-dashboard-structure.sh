#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

DASHBOARD_DIR="$PROJECT_ROOT/compose/dashboard"

echo "[INFO] Creating dashboard structure"

mkdir -p "$DASHBOARD_DIR/homepage/config"
mkdir -p "$DASHBOARD_DIR/homepage/icons"

mkdir -p "$DASHBOARD_DIR/status-api/collectors"

echo "[INFO] Checking existing dashboard config"

# Move existing Homepage config if it exists at the old location
if [[ -d "$DASHBOARD_DIR/config" && ! -d "$DASHBOARD_DIR/homepage/config" ]]; then
    echo "[INFO] Moving existing Homepage config"
    mv "$DASHBOARD_DIR/config" "$DASHBOARD_DIR/homepage/config"
fi

echo "[INFO] Creating status API placeholder files"

touch "$DASHBOARD_DIR/status-api/app.py"
touch "$DASHBOARD_DIR/status-api/requirements.txt"
touch "$DASHBOARD_DIR/status-api/Dockerfile"

echo "[INFO] Creating collector placeholders"

for collector in \
    cpu.py \
    memory.py \
    storage.py \
    docker.py \
    tailscale.py \
    uptime.py
do
    touch "$DASHBOARD_DIR/status-api/collectors/$collector"
done

echo "[INFO] Dashboard structure created"

tree "$DASHBOARD_DIR"