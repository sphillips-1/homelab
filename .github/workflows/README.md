# GitHub Actions deployment

This repository now deploys through a GitHub self-hosted runner running on the homelab device itself.

## How it works

1. A self-hosted runner is installed on the target device.
2. GitHub Actions dispatches the workflow to that runner.
3. The runner checks out the repository and executes the bootstrap script locally.

## Required setup

On the target device, install and register a self-hosted runner for this repository.

The runner setup helper is available at [shared/scripts/setup-github-runner.sh](../../shared/scripts/setup-github-runner.sh).

## Runner registration

Generate a registration token from GitHub:

- Settings → Actions → Runners → New self-hosted runner

Then run:

```bash
export RUNNER_TOKEN="<registration token>"
export RUNNER_NAME="raspberrypi-03"
export RUNNER_LABELS="self-hosted,Linux,ARM64,homelab"
sudo bash /opt/homelab/shared/scripts/setup-github-runner.sh
```

## Workflow behavior

The workflow in [deploy.yml](deploy.yml) uses the self-hosted runner and triggers the deployment directly on the device.

No SSH secrets are required for this deployment method.
