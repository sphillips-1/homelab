#!/usr/bin/env bash

set -euo pipefail

RULE_FILE="/etc/udev/rules.d/99-disable-touchscreen.rules"

echo "[INFO] Disabling Raspberry Pi touchscreen input"

sudo tee "$RULE_FILE" > /dev/null <<'EOF'
SUBSYSTEM=="input", ENV{ID_INPUT_TOUCHSCREEN}=="1", ENV{ID_PATH}=="platform-fe205000.i2c", ENV{LIBINPUT_IGNORE_DEVICE}="1"
EOF

echo "[INFO] Reloading udev rules"

sudo udevadm control --reload-rules
sudo udevadm trigger

echo "[INFO] Touchscreen disable rule installed"
echo "[INFO] Restart the graphical session or reboot for it to take effect"