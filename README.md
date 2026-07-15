# Homelab Infrastructure

Infrastructure-as-code repository for my self-hosted services.

## Goals

- Repeatable Raspberry Pi rebuilds
- Docker-based services
- Documented configuration
- Easy disaster recovery

## Hosts

| Host | Purpose |
|---|---|
| raspberrypi-01 | Primary services |
| raspberrypi-02 | Monitoring |

## Services

- Audiobookshelf
- Nginx Proxy Manager
- Tailscale
- Monitoring stack

## Recovery

A fresh Raspberry Pi OS installation should be recoverable by running:

```bash
./bootstrap.sh