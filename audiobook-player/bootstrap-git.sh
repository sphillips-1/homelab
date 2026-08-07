#!/usr/bin/env bash
set -euo pipefail

REPO_URL="git@github.com:sphillips-1/homelab.git"
TARGET_DIR="$HOME/audiobook-player"
SSH_DIR="$HOME/.ssh"
KEY_FILE="$SSH_DIR/id_rsa_audiobook_player"
CONFIG_FILE="$SSH_DIR/config"

info() { printf "[INFO] %s\n" "$1"; }
error() { printf "[ERROR] %s\n" "$1" >&2; exit 1; }

if [ -d "$TARGET_DIR" ]; then
  info "Target directory already exists: $TARGET_DIR"
  exit 0
fi

info "Installing git, curl, and jq"
if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y git curl jq
else
  error "Unsupported package manager: only Debian/Ubuntu apt is supported"
fi

info "Creating SSH key for audiobook-player"
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"
if [ ! -f "$KEY_FILE" ]; then
  ssh-keygen -t ed25519 -f "$KEY_FILE" -N "" -C "audiobook-player@$(hostname)"
fi

info "Configuring SSH"
if ! grep -q "Host github.com" "$CONFIG_FILE" 2>/dev/null; then
  cat >> "$CONFIG_FILE" <<EOF
Host github.com
  HostName github.com
  User git
  IdentityFile $KEY_FILE
  IdentitiesOnly yes
EOF
  chmod 600 "$CONFIG_FILE"
fi

info "Your public key is:"
cat "$KEY_FILE.pub"

echo
info "Add the above public key to GitHub as a deploy key or SSH key before continuing."

echo "When ready, clone the repository with:"
echo "  git clone $REPO_URL $TARGET_DIR"
