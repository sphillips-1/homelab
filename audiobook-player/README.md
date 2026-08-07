# Portable Audiobook Player

Battery-powered audiobook player on Raspberry Pi Zero 2 W with ESP32 touchscreen and Bluetooth audio.

## Requirements

* Raspberry Pi OS Lite 64-bit (Bookworm recommended)
* SSH enabled and headless operation
* Network access from your laptop or workstation

## Quick setup

1. SSH into the Pi:

```bash
ssh pi@raspberrypi.local
```

2. Configure Git and clone the repo:

```bash
curl -fsSL https://raw.githubusercontent.com/sphillips-1/homelab/main/audiobook-player/bootstrap-git.sh | bash

```

3. Install the device software:

```bash
cd ~/audiobook-player/audiobook-player
chmod +x setup.sh
sudo ./setup.sh
```

## Services

Install and enable the runtime services:

```bash
sudo ./scripts/install-services.sh
```

Check status:

```bash
systemctl status audiobook-player
systemctl status audiobook-api
```

## Deployment

Update the Pi and redeploy:

```bash
git pull
sudo ./setup.sh
sudo systemctl restart audiobook-player
sudo systemctl restart audiobook-api
```

## Verification

Run the verification script:

```bash
./scripts/verify.sh
```

## Notes

* Application location: `/opt/audiobook-player`
* Virtual environment: `/opt/audiobook-player/venv`
* `setup.sh` installs OS packages, Python dependencies, Bluetooth configuration, and services
* `install-services.sh` writes systemd units and enables the services

## ESP32 firmware

Install PlatformIO on your development machine and build/upload from `firmware/esp32`:

```bash
pip install platformio
cd firmware/esp32
pio run
pio run --target upload
```

## Future features

* Audiobookshelf playback sync
* Offline downloads
* Sleep timer
* Battery reporting
* ESP32 OTA updates
