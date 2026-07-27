#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DASHBOARD_DIR="$PROJECT_ROOT/compose/dashboard"

echo "=========================================="
echo " Homelab Dashboard Installer"
echo "=========================================="
echo

###############################################################################
# Verify dashboard exists
###############################################################################

if [[ ! -d "$DASHBOARD_DIR" ]]; then
    echo "[ERROR] Dashboard directory not found:"
    echo "$DASHBOARD_DIR"
    exit 1
fi

###############################################################################
# Create required directories
###############################################################################

echo "[INFO] Creating dashboard directories"

mkdir -p "$DASHBOARD_DIR/homepage/config"
mkdir -p "$DASHBOARD_DIR/homepage/icons"
mkdir -p "$DASHBOARD_DIR/status-api/providers"

###############################################################################
# Migrate Homepage configuration
###############################################################################

if [[ -d "$DASHBOARD_DIR/config" ]]; then
    echo "[INFO] Migrating Homepage configuration"

    shopt -s nullglob
    for file in "$DASHBOARD_DIR/config"/*; do
        mv -n "$file" "$DASHBOARD_DIR/homepage/config/"
    done
    shopt -u nullglob

    rmdir "$DASHBOARD_DIR/config" 2>/dev/null || true
fi

###############################################################################
# Migrate collectors to providers
###############################################################################

if [[ -d "$DASHBOARD_DIR/status-api/collectors" ]]; then
    echo "[INFO] Migrating collectors to providers"

    shopt -s nullglob
    for file in "$DASHBOARD_DIR/status-api/collectors"/*; do
        mv -n "$file" "$DASHBOARD_DIR/status-api/providers/"
    done
    shopt -u nullglob

    rmdir "$DASHBOARD_DIR/status-api/collectors" 2>/dev/null || true
fi

###############################################################################
# Validate Homepage configuration
###############################################################################

echo "[INFO] Validating Homepage configuration"

HOMEPAGE_FILES=(
    "layout.yaml"
    "services.yaml"
    "settings.yaml"
    "widgets.yaml"
)

for file in "${HOMEPAGE_FILES[@]}"; do
    if [[ ! -f "$DASHBOARD_DIR/homepage/config/$file" ]]; then
        echo "[ERROR] Missing Homepage configuration:"
        echo "        $DASHBOARD_DIR/homepage/config/$file"
        exit 1
    fi
done

###############################################################################
# Validate Status API structure
###############################################################################

echo "[INFO] Validating Status API structure"

STATUS_FILES=(
    "Dockerfile"
    "app.py"
    "requirements.txt"
)

for file in "${STATUS_FILES[@]}"; do
    if [[ ! -f "$DASHBOARD_DIR/status-api/$file" ]]; then
        echo "[ERROR] Missing Status API file:"
        echo "        $DASHBOARD_DIR/status-api/$file"
        exit 1
    fi
done

PROVIDERS=(
    "__init__.py"
    "system.py"
    "cpu.py"
    "memory.py"
    "storage.py"
    "docker.py"
    "tailscale.py"
)

for provider in "${PROVIDERS[@]}"; do
    if [[ ! -f "$DASHBOARD_DIR/status-api/providers/$provider" ]]; then
        echo "[ERROR] Missing provider:"
        echo "        $DASHBOARD_DIR/status-api/providers/$provider"
        exit 1
    fi
done

###############################################################################
# Complete
###############################################################################

echo
echo "[INFO] Dashboard installation complete"
echo

tree "$DASHBOARD_DIR"