# Audiobooks Test Guide

This folder contains the Audiobookshelf role for the homelab.
Use this guide when validating the backup and restore workflow on a test host.

## Test bootstrap

Run the minimal test bootstrap to install Docker, mount storage, create directories, and deploy Audiobookshelf:

```bash
cd ~/repos/homelab
bash audiobooks/test-bootstrap.sh
```

> The test bootstrap is intentionally minimal. It installs only what is needed to verify the Audiobookshelf backup/restore flow.

## Verify Audiobookshelf

After bootstrap completes, verify the service is running:

```bash
docker ps --filter "name=audiobookshelf"
```

If the container is not running, inspect the logs:

```bash
docker logs audiobookshelf
```

## Backup test

Create a backup with:

```bash
cd ~/repos/homelab/audiobooks
bash backup.sh
```

The script writes a `.tar.gz` archive into `/mnt/audiobooks/backups`.

## Restore test

Restore from a backup archive with:

```bash
cd ~/repos/homelab/audiobooks
bash restore.sh /mnt/audiobooks/backups/audiobookshelf-<TIMESTAMP>.tar.gz
```

After restore completes, verify the container is running again:

```bash
docker ps --filter "name=audiobookshelf"
```

## Notes

- This guide is meant for validation on a test host such as a Pi Zero 2.
- For production hosts, use `audiobooks/bootstrap.sh` instead of the test bootstrap.
