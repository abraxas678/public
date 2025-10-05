#! /bin/bash
mkdir -p $HOME/tmp
cd $HOME/tmp
wget https://app.raidrive.com/deb/pool/main/r/raidrive/raidrive_2024.9.27.6-linux_amd64.deb
sudo apt update
sudo apt install -y ./raidrive_2024.9.27.6-linux_amd64.deb

