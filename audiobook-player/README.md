# Portable Audiobook Player

Battery-powered audiobook player built with:

* Raspberry Pi Zero 2 W
* Geekworm X306 UPS
* LiPo battery
* ESP32-2432S028R touchscreen
* Bluetooth audio

The Raspberry Pi provides the application runtime.
The ESP32 provides the touchscreen interface.

---

# Device Architecture

```
+-----------------------------+
| ESP32-2432S028R             |
|                             |
| LVGL Touch Interface        |
| Playback Controls           |
| Cover Display               |
+-------------+---------------+
              |
              | WiFi API
              |
+-------------v---------------+
| Raspberry Pi Zero 2 W       |
|                             |
| Python Application          |
| Audio Playback              |
| Audiobookshelf Sync         |
| Bluetooth                   |
+-------------+---------------+
              |
+-------------v---------------+
| Geekworm X306 UPS           |
| Battery Management          |
+-----------------------------+
```

---

# Operating System

## Raspberry Pi

Required:

**Raspberry Pi OS Lite 64-bit**

Recommended:

* Debian Bookworm
* SSH enabled
* No desktop environment

The device runs headless.

---

# Initial Device Setup

Flash Raspberry Pi OS using Raspberry Pi Imager.

Enable:

* SSH
* WiFi
* Username/password

Boot the Pi and connect:

```bash
ssh pi@raspberrypi.local
```

---

# Step 1 - Configure Git Access

The first script configures Git and SSH.

Run:

```bash
curl -fsSL https://raw.githubusercontent.com/sphillips-1/homelab/main/audiobook-player/bootstrap-git.sh | bash
```

This script:

* Installs Git
* Creates SSH keys
* Configures GitHub SSH access
* Clones this repository

After completion:

```bash
cd ~/audiobook-player
```

---

# Step 2 - Install Device Software

Run from the repository:

```bash
./setup.sh
```

The setup script installs:

* Required Linux packages
* Python environment
* Application dependencies
* Bluetooth configuration
* System services
* Permissions
* Device configuration

---

# Software Requirements

Installed automatically:

## Linux Packages

* git
* python3
* python3-venv
* python3-pip
* python3-bluez
* ffmpeg
* bluez
* bluetooth
* curl
* jq

## Python

Virtual environment:

```
/opt/audiobook-player/venv
```

Dependencies:

```
requirements.txt
```

---

# Application Installation

The application is installed:

```
/opt/audiobook-player
```

Ownership:

```
audioplayer:audioplayer
```

---

# Services

Systemd services:

```
audiobook-player.service
audiobook-api.service
```

Install:

```bash
./scripts/install-services.sh
```

Enable:

```bash
sudo systemctl enable audiobook-player
sudo systemctl enable audiobook-api
```

Start:

```bash
sudo systemctl start audiobook-player
sudo systemctl start audiobook-api
```

Status:

```bash
systemctl status audiobook-player
```

---

# ESP32 Development

The ESP32 touchscreen firmware uses:

* PlatformIO
* LVGL
* Arduino framework

Development machine requirements:

* VS Code
* PlatformIO extension

Install:

```bash
pip install platformio
```

Build:

```bash
cd firmware/esp32

pio run
```

Upload:

```bash
pio run --target upload
```

---

# Deployment Workflow

## Update Raspberry Pi

SSH:

```bash
ssh pi@raspberrypi.local
```

Pull changes:

```bash
cd ~/audiobook-player

git pull
```

Deploy:

```bash
./setup.sh
```

Restart:

```bash
sudo systemctl restart audiobook-player
sudo systemctl restart audiobook-api
```

---

# Development Workflow

Make changes locally:

```bash
git checkout -b feature/new-ui
```

Commit:

```bash
git add .
git commit -m "Add touchscreen playback controls"
```

Push:

```bash
git push
```

Deploy:

```bash
git pull
./setup.sh
```

---

# Verification

Run:

```bash
./scripts/verify.sh
```

Checks:

* OS version
* Python environment
* Services running
* Bluetooth available
* Storage available
* Network connectivity

---

# Future Features

* Audiobookshelf playback sync
* Offline downloads
* Sleep timer
* Physical buttons
* Battery percentage reporting
* ESP32 OTA updates
* 3D printed enclosure
* Charging indicator
* Resume playback across devices
