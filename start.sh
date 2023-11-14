#!/bin/bash
cd $HOME
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
[[ ! -f /home/mnt/snas/setup/MOUNT_CHECK ]] && sudo mount -t nfs 192.168.178.35:/volume1/setup /home/mnt/snas/setup
sudo chown $USER: -R /home/mnt/snas
sudo chmod 777 /home/mnt/snas -R

# Install apps using apt-get
while read -r app; do
  if ! command -v $app &> /dev/null; then
    sudo apt-get install $app -y
  fi
done < /home/mnt/snas/setup/app_install.txt

# Install apps using pip
while read -r app; do
  if ! pip show "$app" >/dev/null 2>&1; then
    pip install "$app"
  fi
done < /home/mnt/snas/setup/pip_install.txt

# Install apps using brew
if [[ $(brew) = *"Example usage:"* ]]; then
  printf "brew "; /home/mnt/snas/setup/green_checkmark.sh
else
  echo "Installing brew"
fi

while read -r app; do
  if ! brew list "$app" &>/dev/null; then
    brew install "$app"
  fi
done < /home/mnt/snas/setup/brew_install.txt

# Report to user
echo "Setup and installations completed successfully."
