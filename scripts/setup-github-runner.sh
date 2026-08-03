#!/usr/bin/env bash

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "[ERROR] Please run this script with sudo"
    exit 1
fi

RUNNER_DIR="/opt/actions-runner"
RUNNER_VERSION="${RUNNER_VERSION:-2.321.0}"
GITHUB_URL="${GITHUB_URL:-https://github.com}"
RUNNER_TOKEN="${RUNNER_TOKEN:-}"
RUNNER_NAME="${RUNNER_NAME:-$(hostname)}"
RUNNER_LABELS="${RUNNER_LABELS:-self-hosted,Linux,ARM64,homelab}"

if [[ -z "$RUNNER_TOKEN" ]]; then
    echo "[ERROR] RUNNER_TOKEN is required"
    echo "[INFO] Generate it from GitHub -> Settings -> Actions -> Runners -> New self-hosted runner"
    exit 1
fi

mkdir -p "$RUNNER_DIR"
cd "$RUNNER_DIR"

if [[ ! -f "$RUNNER_DIR/config.sh" ]]; then
    echo "[INFO] Downloading GitHub Actions runner"
    curl -o actions-runner.tar.gz -L "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz"
    tar xzf actions-runner.tar.gz
    rm -f actions-runner.tar.gz
fi

./config.sh --unattended \
    --url "$GITHUB_URL" \
    --token "$RUNNER_TOKEN" \
    --name "$RUNNER_NAME" \
    --labels "$RUNNER_LABELS" \
    --work _work

./run.sh
