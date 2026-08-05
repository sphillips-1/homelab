# AGENTS.md

# Homelab AI Contributor Guide

This document provides guidance for AI coding assistants and human contributors working in this repository.

The goal is to make every change consistent, reproducible, and easy to maintain.

---

# Project Goal

This repository builds and maintains a Raspberry Pi based homelab using infrastructure-as-code principles.

The long-term objective is to create an appliance-like system that can be rebuilt from a clean Raspberry Pi OS installation with only a few commands.

Every improvement should move the project toward that goal.

---

# Core Principles

## Automation First

Anything performed manually more than once should eventually become automated.

## Infrastructure as Code

Configuration belongs in the repository whenever practical.

Avoid undocumented manual configuration.

## Reproducibility

A replacement Raspberry Pi should be able to assume the role of a failed device with minimal manual intervention.

## Simplicity

Prefer obvious solutions over clever ones.

Prefer Bash and Docker Compose over unnecessary frameworks.

## Reliability

This homelab is intended to run continuously.

Reliability is more important than novelty.

---

# Repository Organization

Repository layout should follow these conventions.

```
audiobooks/
shared/
docs/
```

Avoid placing miscellaneous files in the repository root.

---

# Bash Standards

Scripts should:

- use `#!/usr/bin/env bash`
- begin with

```bash
set -euo pipefail
```

Scripts should:

- be idempotent whenever practical
- produce useful log output
- validate prerequisites
- fail with meaningful error messages
- avoid unnecessary dependencies

Comment *why*, not *what*.

---

# Docker Standards

Use Docker Compose.

Each service should:

- use persistent storage
- define restart behavior
- expose only required ports
- use bind mounts for configuration when practical
- use stable image tags when appropriate

---

# Raspberry Pi Standards

Primary platform:

- Raspberry Pi 4
- Raspberry Pi OS (Debian)
- ARM64

Avoid assumptions that require x86 hardware.

Desktop software should only be required for dashboard functionality.

---

# Dashboard Standards

Dashboard software should:

- launch automatically
- recover automatically after reboot
- be usable without keyboard or mouse
- remain readable from across a room
- prioritize reliability over visual effects

---

# Documentation Standards

Any feature that changes installation or operation should update documentation.

Documentation should explain:

- purpose
- installation
- configuration
- verification
- recovery

---

# Git Guidelines

Prefer small commits.

Commit messages should explain *why* the change exists.

Avoid unrelated formatting changes.

---

# AI Expectations

Before adding new code:

- Look for existing implementations first.
- Extend existing scripts when appropriate.
- Avoid duplicate functionality.

When proposing architectural changes:

- Explain the tradeoffs.
- Prefer incremental improvements.

Do not:

- remove user customizations
- introduce unnecessary dependencies
- rewrite working code without clear benefit

---

# Definition of Done

## Scripts

- Script created or updated
- Idempotent when practical
- Error handling included
- Verification documented
- README updated if required

---

## Docker Services

- Compose configuration added
- Persistent storage configured
- Restart policy configured
- Verification steps included
- Documentation updated

---

## Dashboard Features

- Display tested
- Automatic startup verified
- Readability considered
- Failure recovery documented

---

## Hardware Changes

- Hardware inventory updated
- BOM updated
- Wiring documented if applicable
- Photos added when beneficial

---

## Repository

Before considering work complete:

- Documentation updated
- No hardcoded secrets
- Consistent formatting
- Existing functionality preserved

---

# Long-Term Vision

This repository should become a complete blueprint for reproducing the homelab from hardware assembly through software deployment with minimal manual effort.