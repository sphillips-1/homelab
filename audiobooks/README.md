# Audiobookshelf Recovery Guide

This folder contains the Audiobookshelf role for the homelab.

## Purpose

This README documents the manual steps needed after a Raspberry Pi is rebuilt with a new SD card and the `homelab/audiobooks` role must be restored.

## Prerequisites

- Pi is booted and connected to the network
- The audiobook storage drive is available and uses the configured UUID in `shared/templates/homelab.env`
- `docker` and `docker compose` are installed, or the bootstrap script is available to install them
- `git` may not be installed by default on the Pi; if needed install it or copy the repo manually

## Manual recovery steps after a new SD card
1. Open a shell on the Pi.


```bash
ssh admin@raspberrypi-03
sudo apt update
sudo apt install -y git
cd ~
git clone https://github.com/sphillips-1/homelab.git

chmod +x audiobooks/bootstrap.sh 
sudo bash scripts/mount-storage.sh
sudo bash scripts/create-directories.sh
sudo docker compose -f audiobookshelf/audiobookshelf/compose.yml up -d
latest_backup=$(find /mnt/audiobooks/backups -maxdepth 1 -name 'audiobookshelf-*.tar.gz' -printf '%T@ %p\n' | sort -nr | cut -d' ' -f2- | head -n 1)
sudo bash restore.sh "$latest_backup"
```

## Verify the service

Check the container status:

```bash
docker ps --filter "name=audiobookshelf"
```

Inspect logs if the service is not running:

```bash
docker logs audiobookshelf
```



## Notes

- `scripts/mount-storage.sh` expects the audiobook drive UUID and mount point from `shared/templates/homelab.env`.
- If the Pi does not have the repository checked out, the manual recovery steps require that checkout first.
- If the bootstrap script can run successfully, it is the preferred path for a full role setup:

```bash
cd ~/repos/homelab/audiobooks
sudo bash bootstrap.sh
```
