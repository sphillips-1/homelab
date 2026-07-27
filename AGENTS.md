# Homelab Agent Instructions

## Project Rules

- Do not make partial file replacements.
- When changing scripts, provide complete file contents.
- Never delete existing functionality without confirmation.
- Always inspect git diff before commit.

## Environment

Development:
- Windows
- VS Code
- Git Bash

Server:
- Raspberry Pi
- Debian 13
- Docker

## Deployment Flow

1. Modify locally
2. Run validation scripts
3. Review git diff
4. Commit
5. Push
6. Pull on Pi
7. Deploy