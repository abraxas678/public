#!/bin/bash
clear
echo v0.3
sleep 1

mkdir ~/tmp -p
MYPWD=$PWD
cd $HOME/tmp

sudo apt install curl git wget -y
git config --global user.email "abraxas678@gmail.com"
git config --global user.name "abraxas678"

#which tmux >/dev/null 2>&1; [[ "$?" != "0" ]] && sudo apt update && sudo apt install tmux tmuxinator -y

#curl -s -L https://raw.githubusercontent.com/abraxas678/public/master/start_TMUX.sh -o ~/tmp/start_TMUX.sh
#chmod +x ~/tmp/start_TMUX.sh

#curl -s -L https://raw.githubusercontent.com/abraxas678/public/master/.p10kmini.zsh -o ~/.p10kmini.zsh
#curl -s -L https://raw.githubusercontent.com/abraxas678/public/master/setup.yml -o ~/tmp/setup.yml

#echo "STATE1" >~/tmp/setup_status.txt
#tmuxinator start -p $HOME/tmp/setup.yml
#~/tmp/start_TMUX.sh


#exit


#!/bin/bash
#            - tmux resize-pane -t 0 -y 2
#tmux send-keys -t 0 'clear; echo -e "\033[1;34mSETUP NEW MACHINE\033[0m"' C-m
#tmux send-keys -t 0 'start.sh'
#            - tmux send-keys -t 1 'clear' C-m

#tmux send-keys -t 1 'clear' C-m
#tmux send-keys -t 0 'clear' C-m
#tmux send-keys -t 0 'clear; echo -e "\033[1;34mSETUP NEW MACHINE\033[0m"' C-m
#tmux send-keys -t 0 'start_TMUX.sh'

#MYPWD=$PWD
# Change directory to home
#cd $HOME

# Get SNAS-IP from user
COUNT=${#SNAS_IP}
#echo COUNT $COUNT
[[ "$COUNT" = "0" ]] && read -p "SNAS-IP: >> " SNAS_IP
echo "SNAS_IP: $SNAS_IP"

sleep 2

# Check if user is not abrax, if not then switch to abrax
if [[ $USER != *"abrax"* ]]; then
  su abrax
  sudo adduser abrax
  sudo usermod -aG sudo abrax
  su abrax
fi

# Check if head.json file exists, if not then create it
#if [[ ! -f ~/head.json ]]; then
#  read -p "headless service key: >> " SKEY
#  echo $SKEY >head.json
#  cat head.json
#  read -t 10 me
#fi

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
#if [[ "$(command twingate 2>&1)" = *"command not found"* ]]; then
#  curl -s https://binaries.twingate.com/client/linux/install.sh | sudo bash
#fi

# Setup Twingate if not running
#if [[ $(twingate status) = *"not-running"* ]]; then
#  sudo twingate setup --headless head.json
#fi

# Authenticate Twingate if not authenticated
#if [[ $(twingate resources) = *"Not authenticated"* ]]; then
#  sudo twingate auth snas
#fi

# Check Twingate status, if not online then start it
#if [[ $(twingate status) != *"online"* ]]; then
#  timeout 10 /usr/bin/twingate-notifier console
#fi

# Create directories for SNAS setup
#sudo mkdir -p /home/mnt/snas/sync
sudo mkdir -p /home/mnt/snas/setup
#sudo mkdir -p /home/mnt/snas/downloads2

# Change ownership and permissions if directories are not mounted
#for dir in sync setup downloads2; do
for dir in setup; do
  if [[ ! -f /home/mnt/snas/$dir/MOUNT_CHECK ]]; then
    sudo chown $USER: -R /home/mnt/snas/$dir
    sudo chmod 777 /home/mnt/snas/$dir -R
  fi
done

curl -L https://raw.githubusercontent.com/abraxas678/public/master/mount.sh -o mount.sh
source mount.sh

# Mount directories if not already mounted
#for dir in sync setup downloads2; do
for dir in setup; do
  if [[ ! -f /home/mnt/snas/$dir/MOUNT_CHECK ]]; then
    sudo mount -t nfs -o vers=3 $SNAS_IP:/volume2/$dir /home/mnt/snas/$dir
    sudo mount -t nfs -o vers=3 $SNAS_IP:/volume1/$dir /home/mnt/snas/$dir
  fi
done

# Change ownership and permissions for setup directory
#sudo chown $USER: -R /home/mnt/snas/setup
#sudo chmod 777 /home/mnt/snas/setup -R

# Wait until setup directory is mounted
while [[ ! -f /home/mnt/snas/setup/MOUNT_CHECK ]]; do
  echo "checking mount"
  sleep 1
done

# Source start2.sh script
echo
echo "STARTING START2.SH"
echo
sleep 3

source /home/mnt/snas/setup/start2.sh
