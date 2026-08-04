## Current Status

The touchscreen dashboard is now managed from the dedicated touchscreen area of the repository. Its deployment and setup are split from the main bootstrap flow so the kiosk experience can be maintained independently.

The dashboard currently provides:

- Homepage UI
- Touchscreen kiosk launcher
- Touchscreen power management
- Local service availability view

Relevant files:

- [touchscreen/compose/dashboard/compose.yml](../touchscreen/compose/dashboard/compose.yml)
- [touchscreen/setup-touchscreen.sh](../touchscreen/setup-touchscreen.sh)
- [touchscreen/services/touchscreen-power](../touchscreen/services/touchscreen-power)

Planned:

- Prometheus metrics
- Storage monitoring
- CPU temperature
- Docker health
- Tailscale status