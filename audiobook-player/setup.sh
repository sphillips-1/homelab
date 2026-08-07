#!/usr/bin/env bash
set -euo pipefail

APP_USER="audioplayer"
APP_GROUP="audioplayer"
APP_DIR="/opt/audiobook-player"
VENV_DIR="$APP_DIR/venv"
REPO_DIR="$PWD"
REQUIREMENTS_FILE="$REPO_DIR/requirements.txt"
SERVICE_DIR="$REPO_DIR/scripts"
PACKAGES=(git python3 python3-venv python3-pip ffmpeg bluez bluetooth curl jq)

info() { printf "[INFO] %s\n" "$1"; }
error() { printf "[ERROR] %s\n" "$1" >&2; exit 1; }

if [ "$EUID" -ne 0 ]; then
  error "setup.sh must be run as root or with sudo"
fi

info "Installing required Linux packages"
if command -v apt-get >/dev/null 2>&1; then
  apt-get update
  apt-get install -y "${PACKAGES[@]}"
else
  error "Unsupported package manager: only Debian/Ubuntu apt is supported"
fi

info "Creating application user and group"
if ! id -u "$APP_USER" >/dev/null 2>&1; then
  useradd --system --create-home --home-dir /home/$APP_USER --shell /usr/sbin/nologin "$APP_USER"
fi
if ! getent group "$APP_GROUP" >/dev/null 2>&1; then
  groupadd --system "$APP_GROUP"
fi
usermod -a -G bluetooth "$APP_USER" || true

info "Installing application to $APP_DIR"
mkdir -p "$APP_DIR"
rsync -a --exclude "venv" --exclude ".git" --exclude "__pycache__" "$REPO_DIR/" "$APP_DIR/"

info "Creating Python virtual environment"
python3 -m venv "$VENV_DIR"
"$VENV_DIR/bin/pip" install --upgrade pip
if [ -f "$REQUIREMENTS_FILE" ]; then
  "$VENV_DIR/bin/pip" install -r "$REQUIREMENTS_FILE"
fi

info "Configuring Bluetooth"
if systemctl is-enabled bluetooth >/dev/null 2>&1; then
  systemctl restart bluetooth
else
  systemctl enable bluetooth
  systemctl start bluetooth
fi

info "Installing systemd services"
bash "$SERVICE_DIR/install-services.sh"

info "Setting ownership"
chown -R "$APP_USER:$APP_GROUP" "$APP_DIR"
chown -R "$APP_USER:$APP_GROUP" "/var/log/audiobook-player" 2>/dev/null || true

info "Setup complete."
info "Enable services with:"
info "  systemctl enable audiobook-player"
info "  systemctl enable audiobook-api"
info "Start services with:"
info "  systemctl start audiobook-player"
info "  systemctl start audiobook-api"
