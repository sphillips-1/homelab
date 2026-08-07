#!/usr/bin/env bash
set -euo pipefail

SERVICE_NAME_PLAYER="audiobook-player"
SERVICE_NAME_API="audiobook-api"
SERVICE_DIR="/etc/systemd/system"
APP_DIR="/opt/audiobook-player"
VENV_DIR="$APP_DIR/venv"
USER="audioplayer"
GROUP="audioplayer"

info() { printf "[INFO] %s\n" "$1"; }
error() { printf "[ERROR] %s\n" "$1" >&2; exit 1; }

if [ "$EUID" -ne 0 ]; then
  error "install-services.sh must be run as root or with sudo"
fi

mkdir -p "$SERVICE_DIR"

cat > "$SERVICE_DIR/$SERVICE_NAME_PLAYER.service" <<EOF
[Unit]
Description=Audiobook player service
After=network.target bluetooth.service

[Service]
Type=simple
User=$USER
Group=$GROUP
WorkingDirectory=$APP_DIR
ExecStart=$VENV_DIR/bin/python3 $APP_DIR/player.py
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

cat > "$SERVICE_DIR/$SERVICE_NAME_API.service" <<EOF
[Unit]
Description=Audiobook API service
After=network.target

[Service]
Type=simple
User=$USER
Group=$GROUP
WorkingDirectory=$APP_DIR
ExecStart=$VENV_DIR/bin/python3 $APP_DIR/api.py
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable "$SERVICE_NAME_PLAYER" || true
systemctl enable "$SERVICE_NAME_API" || true
systemctl restart "$SERVICE_NAME_PLAYER" || true
systemctl restart "$SERVICE_NAME_API" || true

info "Services installed and enabled"
