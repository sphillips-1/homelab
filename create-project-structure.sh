#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(pwd)"

echo "Creating Homelab project structure in:"
echo "  $PROJECT_ROOT"
echo

mkdir -p \
    compose/audiobookshelf \
    compose/nginx-proxy-manager \
    compose/watchtower \
    compose/portainer \
    scripts \
    config/nginx \
    config/tailscale \
    docs \
    backups

touch \
    README.md \
    bootstrap.sh \
    .env.example \
    backups/.gitkeep \
    docs/recovery.md \
    docs/networking.md \
    docs/storage.md \
    scripts/install-base.sh \
    scripts/install-docker.sh \
    scripts/install-tailscale.sh \
    scripts/mount-storage.sh \
    scripts/deploy-services.sh \
    scripts/verify.sh

chmod +x \
    bootstrap.sh \
    scripts/*.sh

cat > .gitignore <<'EOF'
.env
*.log

backups/*
!backups/.gitkeep
EOF

echo
echo "Project structure created successfully."