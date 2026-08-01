#!/usr/bin/env bash

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "[ERROR] Please run this script with sudo"
    exit 1
fi

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVICE_NAME="touchscreen-power"
INSTALL_DIR="/opt/homelab/services/${SERVICE_NAME}"
VENV_DIR="/opt/homelab/venvs/${SERVICE_NAME}"
SOURCE_DIR="$PROJECT_ROOT/services/${SERVICE_NAME}"
RULE_FILE="/etc/udev/rules.d/99-disable-touchscreen.rules"
LABWC_AUTOSTART="/etc/xdg/labwc/autostart"
BACKUP_FILE="${LABWC_AUTOSTART}.backup"

echo "[INFO] Setting up touchscreen configuration"

echo "[INFO] Installing touchscreen dependencies"
apt update
apt install -y \
    python3 \
    python3-venv \
    python3-pip \
    curl

if ! command -v chromium >/dev/null 2>&1; then
    echo "[INFO] Installing Chromium"
    apt install -y chromium
fi

echo "[INFO] Installing touchscreen power manager"
sudo mkdir -p "$INSTALL_DIR" "$VENV_DIR"
cp -r "$SOURCE_DIR/"* "$INSTALL_DIR/"
python3 -m venv "$VENV_DIR"
"$VENV_DIR/bin/pip" install --upgrade pip
"$VENV_DIR/bin/pip" install -r "$INSTALL_DIR/requirements.txt"
cp "$SOURCE_DIR/${SERVICE_NAME}.service" "/etc/systemd/system/${SERVICE_NAME}.service"
systemctl daemon-reload
systemctl enable "$SERVICE_NAME"
systemctl restart "$SERVICE_NAME"

echo "[INFO] Disabling touchscreen input"
tee "$RULE_FILE" > /dev/null <<'EOF'
SUBSYSTEM=="input", ENV{ID_INPUT_TOUCHSCREEN}=="1", ENV{ID_PATH}=="platform-fe205000.i2c", ENV{LIBINPUT_IGNORE_DEVICE}="1"
EOF
udevadm control --reload-rules
udevadm trigger

echo "[INFO] Configuring kiosk launcher"
if [[ -f "$LABWC_AUTOSTART" ]]; then
    if [[ ! -f "$BACKUP_FILE" ]]; then
        cp "$LABWC_AUTOSTART" "$BACKUP_FILE"
    fi

    sed -i '/# BEGIN HOMELAB DASHBOARD/,/# END HOMELAB DASHBOARD/d' "$LABWC_AUTOSTART"

    tee -a "$LABWC_AUTOSTART" > /dev/null <<'AUTOSTART'

# BEGIN HOMELAB DASHBOARD
(
    until curl -fs http://localhost:3000 >/dev/null; do
        sleep 5
    done

    chromium \
        --ozone-platform=wayland \
        --kiosk \
        --noerrdialogs \
        --disable-infobars \
        --disable-session-crashed-bubble \
        --password-store=basic \
        http://localhost:3000
) &
# END HOMELAB DASHBOARD

AUTOSTART
else
    echo "[WARN] labwc autostart file not found at $LABWC_AUTOSTART; skipping kiosk launcher"
fi

echo "[INFO] Touchscreen setup complete"
echo "[INFO] Reboot to apply the kiosk and touchscreen changes"
