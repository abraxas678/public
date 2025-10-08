#!/bin/bash
wget https://github.com/espanso/espanso/releases/latest/download/espanso-debian-x11-amd64.deb
sudo apt install ./espanso-debian-x11-amd64.deb
# Register espanso as a systemd service (required only once)
#espanso service register

# Start espanso
#espanso start
espanso start --unmanaged
