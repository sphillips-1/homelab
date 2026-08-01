# DECISIONS.md

# Architecture Decision Log

This document records significant architectural and design decisions for the homelab.

The purpose is to preserve the reasoning behind decisions so they do not need to be rediscovered months or years later.

Entries should be appended rather than modified. If a previous decision is superseded, create a new entry that references the old one.

---

## Status Definitions

- **Accepted** – Current approach
- **Superseded** – Replaced by a newer decision
- **Deprecated** – Still supported but should be phased out
- **Rejected** – Considered but intentionally not adopted

---

## Decision Template

### ADR-XXXX

**Date**

YYYY-MM-DD

**Status**

Accepted

**Decision**

A concise statement describing the decision.

**Context**

Why was this decision necessary?

**Alternatives Considered**

- Option A
- Option B
- Option C

**Consequences**

### Positive

- Benefit
- Benefit

### Negative

- Tradeoff
- Tradeoff

---

# Decision Log

---

## ADR-0001

**Date**

2026-07-25

**Status**

Accepted

**Decision**

Standardize on Docker Compose for self-hosted services.

**Context**

Docker Compose provides reproducible deployments, simple updates, and a consistent deployment model across Raspberry Pi systems.

**Alternatives Considered**

- Native systemd services
- Kubernetes (k3s)
- Podman

**Consequences**

### Positive

- Simple deployments
- Easy backups
- Portable configuration
- Widely supported

### Negative

- Adds Docker as a dependency
- Some services require custom networking

---

## ADR-0002

**Date**

2026-07-25

**Status**

Accepted

**Decision**

Use Tailscale for remote connectivity.

**Context**

Remote administration should not require opening ports on the home router.

**Alternatives Considered**

- Port forwarding
- WireGuard
- OpenVPN

**Consequences**

### Positive

- Secure remote access
- Minimal configuration
- No inbound firewall rules

### Negative

- Requires a third-party control plane
- Depends on Tailscale availability

---

## ADR-0003

**Date**

2026-07-26

**Status**

Accepted

**Decision**

Use Homepage as the primary dashboard.

**Context**

The dashboard must be lightweight, touch-friendly, reliable, and easily configurable on Raspberry Pi hardware.

**Alternatives Considered**

- Dashy
- Grafana
- Heimdall
- Custom React application

**Consequences**

### Positive

- Low resource usage
- Simple YAML configuration
- Fast startup
- Good touchscreen support

### Negative

- Less customizable than a custom application

---

## ADR-0004

**Date**

2026-07-27

**Status**

Accepted

**Decision**

Implement automatic touchscreen dimming through a custom systemd service as a required part of the dashboard hardware setup.

**Context**

The official Raspberry Pi touchscreen lacks built-in idle dimming appropriate for kiosk use, and the touchscreen configuration is required for the intended dashboard experience.

**Alternatives Considered**

- Screen blanking
- DPMS
- Chromium extensions
- Third-party kiosk software

**Consequences**

### Positive

- Full brightness control
- Low overhead
- Reliable operation
- Independent of browser

### Negative

- Custom code must be maintained

---

## ADR-0005

**Date**

2026-07-29

**Status**

Accepted

**Decision**

Treat the repository as the authoritative source for both software and physical infrastructure.

**Context**

A successful rebuild should require only the repository and replacement hardware, without relying on memory or previous conversations.

**Alternatives Considered**

- Software-only repository
- Separate documentation repository
- External wiki

**Consequences**

### Positive

- Single source of truth
- Simplified disaster recovery
- Easier onboarding
- AI assistants have complete project context

### Negative

- Documentation must be maintained alongside code

---

## Future Decision Candidates

The following topics should receive ADRs when finalized.

- GitHub Actions deployment
- Backup strategy
- Monitoring stack
- Alerting platform
- UPS hardware
- Storage architecture
- Reverse proxy selection
- Local DNS strategy
- Multi-node architecture
- Secrets management
- Update strategy
- Configuration management
- Hardware revisions
- Rack design revisions
- Power distribution architecture