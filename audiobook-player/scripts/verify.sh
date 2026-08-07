#!/usr/bin/env bash
set -euo pipefail

info() { printf "[INFO] %s\n" "$1"; }
warn() { printf "[WARN] %s\n" "$1"; }
error() { printf "[ERROR] %s\n" "$1" >&2; exit 1; }

info "Verifying audiobook-player installation"

if [ -f /etc/os-release ]; then
  . /etc/os-release
  info "OS: $NAME $VERSION"
else
  warn "Unable to detect OS"
fi

if command -v python3 >/dev/null 2>&1; then
  PYTHON_VERSION=$(python3 --version 2>&1)
  info "Python: $PYTHON_VERSION"
else
  error "python3 not installed"
fi

if [ -d /opt/audiobook-player/venv ]; then
  info "Virtualenv: present"
else
  error "Virtualenv missing at /opt/audiobook-player/venv"
fi

for svc in audiobook-player audiobook-api bluetooth; do
  if systemctl is-active "$svc" >/dev/null 2>&1; then
    info "Service $svc: active"
  else
    warn "Service $svc is not active"
  fi
done

if command -v bluetoothctl >/dev/null 2>&1; then
  info "Bluetoothctl installed"
else
  warn "bluetoothctl not installed"
fi

if mount | grep -q '/opt/audiobook-player'; then
  info "Storage: /opt/audiobook-player available"
else
  info "Storage: /opt/audiobook-player should exist and be writable"
fi

if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
  info "Network: connectivity OK"
else
  warn "Network connectivity failed"
fi

info "Verification complete"
