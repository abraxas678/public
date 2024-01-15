#!/bin/bash
apt update
apt install -y curl openssh-client wget nano
curl -fsSL https://tailscale.com/install.sh | sh
tailscaled &
tailscale up
