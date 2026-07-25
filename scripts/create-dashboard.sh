#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

DASHBOARD_DIR="$PROJECT_ROOT/compose/dashboard"
CONFIG_DIR="$DASHBOARD_DIR/config"

echo "[INFO] Creating dashboard directories"

mkdir -p "$CONFIG_DIR"

echo "[INFO] Creating Homepage compose file"

cat > "$DASHBOARD_DIR/compose.yml" <<'EOF'
services:
  homepage:
    image: ghcr.io/gethomepage/homepage:latest
    container_name: homepage
    ports:
      - "3000:3000"
    volumes:
      - ./config:/app/config
      - /var/run/docker.sock:/var/run/docker.sock:ro
    environment:
      HOMEPAGE_ALLOWED_HOSTS: "*"
    restart: unless-stopped
EOF


echo "[INFO] Creating Homepage settings"

cat > "$CONFIG_DIR/settings.yaml" <<'EOF'
title: Homelab Dashboard

theme: dark

color: slate

headerStyle: clean

hideVersion: true
EOF


echo "[INFO] Creating Homepage services"

cat > "$CONFIG_DIR/services.yaml" <<'EOF'
- Server:
    - raspberrypi-03:
        description: Main homelab server

- Services:
    - Audiobookshelf:
        href: http://raspberrypi-03:13378

    - Grafana:
        href: http://raspberrypi-03:3000

    - Prometheus:
        href: http://raspberrypi-03:9090
EOF


echo "[INFO] Creating Homepage widgets"

cat > "$CONFIG_DIR/widgets.yaml" <<'EOF'
- resources:
    cpu: true
    memory: true
    uptime: true
EOF


echo "[INFO] Dashboard structure created"