#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$PROJECT_ROOT/config/homelab.env"

DASHBOARD_URL="${DASHBOARD_URL:-http://localhost:3000}"

LABWC_AUTOSTART="/etc/xdg/labwc/autostart"
BACKUP_FILE="${LABWC_AUTOSTART}.backup"

echo "[INFO] Installing dashboard kiosk"

if ! command -v chromium >/dev/null 2>&1; then
    echo "[INFO] Installing Chromium"
    sudo apt update
    sudo apt install -y chromium
fi

if ! command -v curl >/dev/null 2>&1; then
    echo "[INFO] Installing curl"
    sudo apt update
    sudo apt install -y curl
fi

echo "[INFO] Backing up labwc autostart"

if [[ ! -f "$BACKUP_FILE" ]]; then
    sudo cp "$LABWC_AUTOSTART" "$BACKUP_FILE"
fi


echo "[INFO] Removing existing dashboard kiosk block"

sudo sed -i \
    '/# BEGIN HOMELAB DASHBOARD/,/# END HOMELAB DASHBOARD/d' \
    "$LABWC_AUTOSTART"


echo "[INFO] Adding dashboard kiosk launcher"

sudo tee -a "$LABWC_AUTOSTART" >/dev/null <<'AUTOSTART'

# BEGIN HOMELAB DASHBOARD
(
    until curl -fs http://localhost:3000 >/dev/null; do
        sleep 5
    done

    chromium \
        --kiosk \
        --noerrdialogs \
        --disable-infobars \
        --disable-session-crashed-bubble \
        --password-store=basic \
        http://localhost:3000
) &
# END HOMELAB DASHBOARD

AUTOSTART


echo "[INFO] Dashboard kiosk installed"
echo "[INFO] Reboot to test"