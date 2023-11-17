#!/bin/bash
cd $HOME
if [[ $USER != *"abrax"* ]]; then
  su abrax
  sudo adduser abrax
  sudo usermod -aG sudo abrax
  su abrax
fi

if [[ ! -f ~/head.json ]]; then
read -p "headless service key: >> " SKEY
echo $SKEY >head.json
echo
cat head.json
read -t 10 me
fi
# Update and upgrade system
ts=$(date +%s)
if [[ -f ~/last_apt_update.txt ]]; then
  DIFF=$(($ts-$(cat ~/last_apt_update.txt)))
  echo DIFF $DIFF
  sleep 5
  [[ $DIFF -gt "600" ]] && sudo apt update && sudo apt upgrade -y
else
  sudo apt update && sudo apt upgrade -y
fi
echo $ts >~/last_apt_update.txt

# Install nfs-common
sudo apt install nfs-common -y

# Install Twingate
if [[ "$(command twingate 2>&1)" = *"command not found"* ]]; then
  curl -s https://binaries.twingate.com/client/linux/install.sh | sudo bash
fi
if [[ $(twingate status) = *"not-running"* ]]; then
  sudo twingate setup --headless head.json
fi
[[ $(twingate resources) = *"Not authenticated"* ]] && sudo twingate auth snas
[[ $(twingate status) != *"online"* ]] && timeout 10 /usr/bin/twingate-notifier console

# Mount SNAS setup
sudo mkdir -p /home/mnt/snas/sync
sudo mkdir /home/mnt/snas/setup -p
[[ ! -f /home/mnt/snas/sync/MOUNT_CHECK ]] && sudo chown $USER: -R /home/mnt/snas/sync
[[ ! -f /home/mnt/snas/setup/MOUNT_CHECK ]] && sudo chown $USER: -R /home/mnt/snas/setup
[[ ! -f /home/mnt/snas/sync/MOUNT_CHECK ]] && sudo chmod 777 /home/mnt/snas/sync -R
[[ ! -f /home/mnt/snas/setup/MOUNT_CHECK ]] && sudo chmod 777 /home/mnt/snas/setup -R
echo
echo mount nfs version 3
echo; sleep 1
[[ ! -f /home/mnt/snas/sync/MOUNT_CHECK ]] && sudo mount -t nfs -o vers=3 192.168.178.35:/volume2/sync /home/mnt/snas/sync
[[ ! -f /home/mnt/snas/setup/MOUNT_CHECK ]] && sudo mount -t nfs -o vers=3 192.168.178.35:/volume1/setup /home/mnt/snas/setup
sudo chown $USER: -R /home/mnt/snas/setup
sudo chmod 777 /home/mnt/snas/setup -R

x=0
while [[ $x = "0" ]]; do
  sleep 1
  [[ -f /home/mnt/snas/setup/MOUNT_CHECK ]] && x=1 
done

source /home/mnt/snas/setup/start2.sh
