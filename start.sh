#!/bin/bash
cd $HOME
if [[ $USER != *"abrax"* ]]; then
  su abrax
  sudo adduser abrax
  sudo usermod -aG sudo abrax
fi

read -p "headless service key: >> " SKEY
echo $SKEY >head.json
cat head.json
read me
# Update and upgrade system
sudo apt update && sudo apt upgrade

# Install nfs-common
sudo apt install nfs-common

# Install Twingate
curl -s https://binaries.twingate.com/client/linux/install.sh | sudo bash
if [[ $(twingate status) = *"not-running"* ]]; then
  sudo twingate setup --headless head.json
fi
[[ $(twingate resources) = *"Not authenticated"* ]] && sudo twingate auth snas
[[ $(twingate status) != *"online"* ]] && timeout 10 /usr/bin/twingate-notifier console

# Mount SNAS setup
sudo mkdir /home/mnt/snas/setup -p
sudo chown $USER: -R /home/mnt/snas
echo
echo mount nfs version 3
echo; sleep 3
mkdir -p /home/mnt/snas/sync
[[ ! -f /home/mnt/snas/sync/MOUNT_CHECK ]] && sudo mount -t nfs -o vers=3 192.168.178.35:/volume2/sync /home/mnt/snas/sync
[[ ! -f /home/mnt/snas/setup/MOUNT_CHECK ]] && sudo mount -t nfs -o vers=3 192.168.178.35:/volume1/setup /home/mnt/snas/setup
sudo chown $USER: -R /home/mnt/snas
sudo chmod 777 /home/mnt/snas -R

x=0
while [[ $x = "0" ]]; do
  sleep 1
  [[ -f /home/mnt/snas/setup/MOUNT_CHECK ]] && x=1 
done

source /home/mnt/snas/setup/start2.sh
