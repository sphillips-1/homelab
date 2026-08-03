# GitHub Actions deployment

This repository expects the following repository secrets to be configured:

- HOMELAB_SSH_PRIVATE_KEY: private key for the deployment user
- HOMELAB_HOST: target host or IP address
- HOMELAB_USER: SSH username for deployment
- HOMELAB_PORT: optional SSH port, defaults to 22

The workflow will connect to the host over SSH, clone or update the repository under /opt/homelab, and run the bootstrap script.
