#!/usr/bin/env bash

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "[ERROR] Please run this script with sudo"
    exit 1
fi

SERVICE_NAME="touchscreen-power"
INSTALL_DIR="/opt/homelab/touchscreen/services/${SERVICE_NAME}"
VENV_DIR="/opt/homelab/venvs/${SERVICE_NAME}"
SERVICE_UNIT="/etc/systemd/system/${SERVICE_NAME}.service"
RULE_FILE="/etc/udev/rules.d/99-disable-touchscreen.rules"
LABWC_AUTOSTART="/etc/xdg/labwc/autostart"
BACKUP_FILE="${LABWC_AUTOSTART}.backup"

echo "[INFO] Removing touchscreen configuration"

if command -v systemctl >/dev/null 2>&1; then
    if systemctl list-unit-files "${SERVICE_NAME}.service" >/dev/null 2>&1; then
        echo "[INFO] Disabling and stopping ${SERVICE_NAME}"
        systemctl disable "${SERVICE_NAME}" >/dev/null 2>&1 || true
        systemctl stop "${SERVICE_NAME}" >/dev/null 2>&1 || true
    fi
fi

if [[ -f "$SERVICE_UNIT" ]]; then
    echo "[INFO] Removing systemd service"
    rm -f "$SERVICE_UNIT"
fi

if [[ -d "$INSTALL_DIR" ]]; then
    echo "[INFO] Removing installed service files"
    rm -rf "$INSTALL_DIR"
fi

if [[ -d "$VENV_DIR" ]]; then
    echo "[INFO] Removing virtual environment"
    rm -rf "$VENV_DIR"
fi

if [[ -f "$RULE_FILE" ]]; then
    echo "[INFO] Removing udev touchscreen rule"
    rm -f "$RULE_FILE"
fi

if [[ -f "$LABWC_AUTOSTART" ]]; then
    echo "[INFO] Removing kiosk launcher block from labwc autostart"
    sed -i '/# BEGIN HOMELAB DASHBOARD/,/# END HOMELAB DASHBOARD/d' "$LABWC_AUTOSTART"
fi

if [[ -f "$BACKUP_FILE" ]]; then
    echo "[INFO] Restoring backup of labwc autostart"
    cp "$BACKUP_FILE" "$LABWC_AUTOSTART"
    rm -f "$BACKUP_FILE"
fi

if command -v udevadm >/dev/null 2>&1; then
    echo "[INFO] Reloading udev rules"
    udevadm control --reload-rules >/dev/null 2>&1 || true
    udevadm trigger >/dev/null 2>&1 || true
fi

if command -v systemctl >/dev/null 2>&1; then
    echo "[INFO] Reloading systemd"
    systemctl daemon-reload >/dev/null 2>&1 || true
fi

echo "[INFO] Touchscreen cleanup complete"
echo "[INFO] Reboot to fully apply the changes"
