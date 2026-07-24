#!/usr/bin/env bash

set -euo pipefail

echo "[INFO] Starting Docker installation"

if [[ $EUID -ne 0 ]]; then
    echo "[ERROR] Please run this script with sudo"
    exit 1
fi

echo "[INFO] Installing Docker prerequisites"

apt update

apt install -y \
    ca-certificates \
    curl \
    gnupg

echo "[INFO] Adding Docker GPG key"

install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/debian/gpg \
    -o /etc/apt/keyrings/docker.asc

chmod a+r /etc/apt/keyrings/docker.asc

echo "[INFO] Adding Docker repository"

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[INFO] Installing Docker"

apt update

apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

echo "[INFO] Enabling Docker service"

systemctl enable docker
systemctl start docker

echo "[INFO] Adding admin user to docker group"

usermod -aG docker admin

echo
echo "[INFO] Docker installation complete"
echo
docker --version
docker compose version

echo
echo "[WARN] Log out and back in for docker group changes to apply"