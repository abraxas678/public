#!/bin/bash
export XDG_RUNTIME_DIR=""
curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
apt update
apt install ./keybase_amd64.deb -y
export XDG_RUNTIME_DIR=""