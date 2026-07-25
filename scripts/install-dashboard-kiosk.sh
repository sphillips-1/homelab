#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

DASHBOARD_URL="${DASHBOARD_URL:-http://localhost:3000}"

LABWC_AUTOSTART="/etc/xdg/labwc/autostart"

echo "[INFO] Installing dashboard kiosk configuration"

if ! command -v chromium >/dev/null 2>&1; then
    echo "[INFO] Installing Chromium"
    sudo apt update
    sudo apt install -y chromium
fi

echo "[INFO] Backing up labwc autostart"

sudo cp "$LABWC_AUTOSTART" "${LABWC_AUTOSTART}.backup"


echo "[INFO] Adding dashboard launcher"

sudo tee -a "$LABWC_AUTOSTART" >/dev/null <<EOF

# Homelab Dashboard kiosk
(
    until curl -fs "$DASHBOARD_URL" >/dev/null; do
        sleep 5
    done

    chromium \
        --kiosk \
        --noerrdialogs \
        --disable-infobars \
        --disable-session-crashed-bubble \
        "$DASHBOARD_URL"
) &
EOF


echo "[INFO] Dashboard kiosk installed"
echo "[INFO] Reboot to test"