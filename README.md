# Homelab Repository

This repository is now focused on the server role for the Raspberry Pi homelab.

## Repository layout

```text
server/
shared/
docs/
```

## Server role

Host: raspberrypi-03

Responsibilities:
- Docker Engine
- Audiobookshelf
- Storage mounting
- Tailscale
- SSH and Git

Bootstrap:
- server/bootstrap.sh

## Shared assets

Reusable content lives under shared/:
- shared/scripts for common install helpers
- shared/templates for environment and host templates
- shared/docker for shared Docker conventions
- shared/systemd for systemd unit templates

## Deployment workflow

1. Clone the repository
2. Copy shared/templates/homelab.env to the target environment as needed
3. Run server/bootstrap.sh on the server host
4. Verify the deployed services
5. Update the server compose or service files as needed

## Documentation

- docs/networking.md for networking details
- docs/storage.md for storage mount guidance
- docs/recovery.md for recovery steps
- docs/github-runner.md for self-hosted runner setup

---

# Guiding Philosophy

If replacing a Raspberry Pi, rebuilding the rack, or adding a new service requires searching old chats or relying on memory, the repository is missing documentation.

The repository should eventually become the single source of truth for the entire homelab.