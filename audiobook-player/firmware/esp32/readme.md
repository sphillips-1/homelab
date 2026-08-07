# ESP32 Touchscreen Controller

Firmware for the ESP32-2432S028R touchscreen controller used by the Portable Audiobook Player project.

The ESP32 acts as the user interface device. It does **not** store or play audiobook files.

The Raspberry Pi Zero 2 W is responsible for:

* Audiobook management
* Audiobookshelf synchronization
* Audio playback
* Bluetooth audio
* Storage management
* Playback state

The ESP32 provides:

* Touchscreen interface
* Playback controls
* Current book display
* Cover art
* Battery status
* Device status

---

# Architecture

```
+------------------------------+
| ESP32-2432S028R              |
|                              |
| 2.8" TFT Touchscreen         |
| LVGL User Interface          |
| Touch Input                  |
| WiFi Client                  |
+--------------+---------------+
               |
               |
               | HTTP REST API
               | WebSocket (future)
               |
+--------------v---------------+
| Raspberry Pi Zero 2 W        |
|                              |
| Audiobook Service            |
| Playback Engine              |
| Audiobookshelf Integration   |
| Bluetooth Audio              |
+------------------------------+
```

---

# Hardware

## ESP32 Board

Supported:

**ESP32-2432S028R**

Features:

* ESP32-WROOM module
* 2.8" 240x320 TFT display
* Touchscreen
* WiFi
* Bluetooth
* MicroSD slot

Typical components:

* Display controller: ILI9341
* Touch controller: XPT2046

---

# Design Decisions

## Audio Playback

Audio playback is handled by the Raspberry Pi.

The ESP32 does not:

* Decode MP3 files
* Store audiobook files
* Connect directly to Bluetooth headphones

Reasons:

* Better audio support on Linux
* Easier Audiobookshelf integration
* Lower ESP32 memory usage
* Better battery efficiency

---

## Storage

Audiobook storage remains on the Raspberry Pi.

Future options:

* Local Pi storage
* USB storage
* Offline audiobook cache

The ESP32 storage is limited to:

* Firmware
* UI assets
* Cached images
* Configuration

---

# Development Environment

## Required Software

Install:

* Visual Studio Code
* PlatformIO extension

Recommended extensions:

* PlatformIO IDE
* C/C++
* GitLens

---

# PlatformIO

The project uses PlatformIO for:

* Building firmware
* Managing dependencies
* Flashing firmware
* Serial debugging

---

# Project Structure

```
firmware/esp32/

├── platformio.ini
│
├── src/
│   └── main.cpp
│
├── include/
│
├── lib/
│
├── data/
│   ├── icons/
│   ├── fonts/
│   └── images/
│
└── README.md
```

---

# PlatformIO Configuration

Example:

`platformio.ini`

```ini
[env:esp32-2432s028r]

platform = espressif32

board = esp32dev

framework = arduino

monitor_speed = 115200

lib_deps =
    lvgl/lvgl
    bodmer/TFT_eSPI
```

---

# Current Firmware Status

A working PlatformIO scaffold is now in place for the ESP32 controller.

Implemented:

* PlatformIO project structure under this folder
* Wi-Fi configuration template in include/wifi_config.h
* Basic firmware that connects to Wi-Fi and polls the Raspberry Pi API
* Serial status logging for playback state and battery data

Configuration:

1. Edit include/wifi_config.h and set your Wi-Fi SSID/password plus the Raspberry Pi host.
2. Ensure your Raspberry Pi exposes the expected /api/status endpoint.
3. Build and upload with PlatformIO.

---

# Build Firmware

From the ESP32 firmware directory:

```bash
cd firmware/esp32
```

Build:

```bash
py -m platformio run
```

This will:

* Download required toolchains
* Install libraries
* Compile firmware
* Validate configuration

---

# Upload Firmware

Connect the ESP32 by USB.

Find the device:

```bash
pio device list
```

Example:

```
COM5
USB Serial Device
```

Upload:

```bash
pio run --target upload
```

---

# Serial Debugging

Open serial monitor:

```bash
py -m platformio device monitor -b 115200
```

---

# User Interface Framework

The UI uses:

## LVGL

LVGL provides:

* Touchscreen widgets
* Buttons
* Progress bars
* Lists
* Animations
* Themes

Planned screens:

---

## Now Playing

Displays:

* Book cover
* Title
* Author
* Chapter
* Playback position
* Remaining time

Controls:

* Play/pause
* Skip forward
* Skip backward
* Volume

---

## Library

Displays:

* Audiobookshelf library
* Download status
* Recently played books

---

## Device Status

Displays:

* WiFi connection
* Raspberry Pi connection
* Battery level
* Firmware version

---

# Raspberry Pi API Communication

The ESP32 communicates with the Pi using WiFi.

Example:

```
ESP32
 |
 |
HTTP
 |
 |
Pi Zero 2 W API
```

---

# Planned API

## Get Player Status

```
GET /api/status
```

Response:

```json
{
    "book": "Example Book",
    "chapter": 4,
    "position": 1520,
    "duration": 3600,
    "playing": true,
    "battery": 82
}
```

---

## Playback Control

Play:

```
POST /api/play
```

Pause:

```
POST /api/pause
```

Next:

```
POST /api/next
```

Previous:

```
POST /api/previous
```

---

# Future Features

## OTA Updates

Allow firmware updates over WiFi.

Benefits:

* No USB connection required
* Easier deployments
* Remote updates

---

## Power Optimization

Planned:

* Screen timeout
* Deep sleep
* Touch wake
* Battery monitoring

---

## Additional Hardware

Possible additions:

* Physical buttons
* Rotary encoder
* Speaker
* Status LED
* Charging indicator

---

# Development Workflow

## Create feature branch

```bash
git checkout -b feature/touchscreen-ui
```

---

## Build

```bash
py -m platformio run
```

---

## Test

Upload:

```bash
py -m platformio run --target upload
```

Monitor:

```bash
py -m platformio device monitor -b 115200
```

---

## Commit

```bash
git add .

git commit -m "Add touchscreen playback controls"

git push
```

---

# Definition of Done

A firmware feature is complete when:

* [ ] Code builds successfully
* [ ] Firmware uploads successfully
* [ ] UI works on physical hardware
* [ ] Touch input validated
* [ ] No serial errors
* [ ] Power usage tested
* [ ] Documentation updated

---

# Long Term Goal

Create a dedicated audiobook appliance:

* Pocket-sized
* Battery powered
* Touch controlled
* Audiobookshelf synchronized
* Comfortable for daily use
* Easy to maintain through Git deployments

```
```
