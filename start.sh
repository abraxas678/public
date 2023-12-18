#!/bin/bash

# Change directory to home
cd $HOME
which tmux >/dev/null 2>&1; [[ "$?" != "0" ]] && sudo apt update && sudo apt install tmux -y

# Get SNAS-IP from user
read -p "SNAS-IP: >> " SNASIP
echo "SNASIP: $SNASIP"
sleep 2

# Check if user is not abrax, if not then switch to abrax
if [[ $USER != *"abrax"* ]]; then
  su abrax
  sudo adduser abrax
  sudo usermod -aG sudo abrax
  su abrax
fi

# Check if head.json file exists, if not then create it
if [[ ! -f ~/head.json ]]; then
  read -p "headless service key: >> " SKEY
  echo $SKEY >head.json
  cat head.json
  read -t 10 me
fi

# Update and upgrade system
ts=$(date +%s)
if [[ -f ~/last_apt_update.txt ]]; then
  DIFF=$(($ts-$(cat ~/last_apt_update.txt)))
  if [[ $DIFF -gt "600" ]]; then
    sudo apt update && sudo apt upgrade -y
  fi
else
  sudo apt update && sudo apt upgrade -y
fi
echo $ts >~/last_apt_update.txt

# Install ubuntu-desktop and xrdp
sudo apt install ubuntu-desktop xrdp -y

# Install nfs-common
sudo apt install nfs-common -y

# Install Twingate if not already installed
if [[ "$(command twingate 2>&1)" = *"command not found"* ]]; then
  curl -s https://binaries.twingate.com/client/linux/install.sh | sudo bash
fi

# Setup Twingate if not running
if [[ $(twingate status) = *"not-running"* ]]; then
  sudo twingate setup --headless head.json
fi

# Authenticate Twingate if not authenticated
if [[ $(twingate resources) = *"Not authenticated"* ]]; then
  sudo twingate auth snas
fi

# Check Twingate status, if not online then start it
if [[ $(twingate status) != *"online"* ]]; then
  timeout 10 /usr/bin/twingate-notifier console
fi

# Create directories for SNAS setup
sudo mkdir -p /home/mnt/snas/sync
sudo mkdir -p /home/mnt/snas/setup
sudo mkdir -p /home/mnt/snas/downloads2

# Change ownership and permissions if directories are not mounted
for dir in sync setup downloads2; do
  if [[ ! -f /home/mnt/snas/$dir/MOUNT_CHECK ]]; then
    sudo chown $USER: -R /home/mnt/snas/$dir
    sudo chmod 777 /home/mnt/snas/$dir -R
  fi
done

# Mount directories if not already mounted
for dir in sync setup downloads2; do
  if [[ ! -f /home/mnt/snas/$dir/MOUNT_CHECK ]]; then
    sudo mount -t nfs -o vers=3 $SNASIP:/volume2/$dir /home/mnt/snas/$dir
  fi
done

# Change ownership and permissions for setup directory
sudo chown $USER: -R /home/mnt/snas/setup
sudo chmod 777 /home/mnt/snas/setup -R

# Wait until setup directory is mounted
while [[ ! -f /home/mnt/snas/setup/MOUNT_CHECK ]]; do
  sleep 1
done

# Source start2.sh script
source /home/mnt/snas/setup/start2.sh
