# PROJECT.md

# Homelab Project Documentation

This document describes the physical and logical architecture of the homelab.

Unlike AGENTS.md, this file documents the system itself rather than contribution guidelines.

---

# Vision

Create an appliance-like Raspberry Pi homelab that is:

- reproducible
- reliable
- well documented
- attractive
- easy to repair
- easy to expand

---

# Current Architecture

## Primary Server

Hostname:

```
raspberrypi-03
```

Responsibilities

- Docker host
- Audiobookshelf
- Touchscreen dashboard
- Tailscale
- Future monitoring services

---

## Touchscreen Dashboard

Hardware

- Raspberry Pi 4
- Official Raspberry Pi Touch Display v1

The dashboard and its touchscreen-specific setup now live under the dedicated touchscreen directory. The deployment includes the Homepage UI, kiosk launcher configuration, and the touchscreen power manager.

Purpose

- Local status display
- Server monitoring
- Read-only kiosk interface

Deployment location

- [touchscreen/compose/dashboard/compose.yml](touchscreen/compose/dashboard/compose.yml)
- [touchscreen/setup-touchscreen.sh](touchscreen/setup-touchscreen.sh)

---

# Network

Current networking

- Tailscale
- Local LAN
- Docker networking

Future

- Local DNS
- Reverse proxy
- HTTPS
- Service discovery

---

# Services

| Service | Status | Notes |
|----------|--------|------|
| Homepage | ✅ | Running |
| Audiobookshelf | ✅ | Running |
| Docker | ✅ | Running |
| Tailscale | ✅ | Running |
| Monitoring | Planned | |
| Alerting | Planned | |
| Backups | Planned | |

---

# Hardware Inventory

See:

```
hardware/
```

Suggested files:

```
hardware/

    raspberrypi-03.md
    dashboard.md
    storage.md
    networking.md
    power.md
```

Each hardware document should contain:

- Purpose
- Model
- Hostname
- Operating system
- Storage
- Connected peripherals
- Power requirements
- Notes

---

# 3D Printed Components

See

```
stl/
```

Suggested layout

```
stl/

    lab-rax/
        frame.md
        shelves.md
        accessories.md
```

Each component should include:

- STL source
- Print settings
- Material
- Color
- Infill
- Supports
- Hardware required
- Assembly notes

---

# Bill of Materials

See

```
docs/bom.md
```

Suggested columns

| Item | Qty | Purpose | Vendor |
|------|----:|---------|--------|

Include major hardware, power components, storage devices, networking equipment, and printed hardware.

---

# Rack Layout

Document

- physical locations
- cable routing
- power routing
- airflow
- maintenance notes

Photos should be stored under

```
images/
```

---

# Storage

Document

- mounted drives
- filesystems
- backup locations
- capacity
- recovery procedures

---

# Deployment Workflow

Typical deployment process

1. Clone repository
2. Run bootstrap
3. Install Docker
4. Configure storage
5. Deploy services
6. Verify services
7. Enable monitoring

---

# Disaster Recovery

Every major component should eventually document:

- failure symptoms
- replacement procedure
- recovery procedure
- verification checklist

The objective is complete recovery from hardware failure using only this repository.

---

# Roadmap

## Infrastructure

- GitHub Actions deployment
- Automated updates
- Monitoring
- Alerting
- Backups

## Dashboard

- Better mobile layout
- Storage graphs
- Temperature monitoring
- Docker health
- Network health

## Hardware

- UPS
- Environmental sensors
- Rack lighting
- OLED status displays

## Platform

- Multi-node support
- Additional Raspberry Pis
- Automated provisioning
- Configuration management

---

# Guiding Philosophy

If replacing a Raspberry Pi, rebuilding the rack, or adding a new service requires searching old chats or relying on memory, the repository is missing documentation.

The repository should eventually become the single source of truth for the entire homelab.