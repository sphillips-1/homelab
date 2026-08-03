# GitHub self-hosted runner

Use this when you want GitHub Actions to run directly on the homelab device.

## Prerequisites

- A GitHub repository with Actions enabled
- A GitHub account that can create self-hosted runners
- Network access from the device to GitHub

## Install the runner

Run the script on the target device:

```bash
sudo bash /opt/homelab/scripts/setup-github-runner.sh
```

Set the required environment variables before running it:

```bash
export RUNNER_TOKEN="<registration token>"
export RUNNER_NAME="raspberrypi-03"
export RUNNER_LABELS="self-hosted,Linux,ARM64,homelab"
```

## Notes

- The runner is installed under /opt/actions-runner.
- The script registers the runner and starts it in the foreground.
- For production use, it is better to install it as a system service using the runner's built-in service setup.
- The workflow in .github/workflows/deploy.yml already targets self-hosted runners.
