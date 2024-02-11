#!/bin/bash
clear
cd $HOME
echo v0.99
read -t 5 me

mkdir ~/tmp -p
MYPWD=$PWD
cd $HOME/tmp

header1(){
  echo -e "\e[33m$@\e[0m"  
}

header2(){
  TEXT=$(echo "$@" | tr '[:lower:]' '[:upper:]')
  echo -e "\e[94m$TEXT\e[0m"
}

countdown() {
    if [ -z "$1" ]; then
        echo "No argument provided. Please provide a number to count down from."
        exit 1
    fi

    tput civis
    for ((i=$1; i>0; i--)); do
        if (( i > $1*66/100 )); then
            echo -ne "\033[0;32m$i\033[0m\r"
        elif (( i > $1*33/100 )); then
            echo -ne "\033[0;33m$i\033[0m\r"
        else
            echo -ne "\033[0;31m$i\033[0m\r"
        fi
        sleep 1
        echo -ne "\033[0K"
    done
    echo -e "\033[0m"
    tput cnorm
}

TASK() {
  header1 $@
  countdown 1
}

installme() {
  which $@
  if [[ $? != "0" ]]; then
    echo
    echo -e "\e[33mINSTALL: $1\e[0m"  
    countdown 2
    sudo apt install $1 -y
  fi
}

echo user1
TASK "CHECK: USER = abrax? "
# Check if user is not abrax, if not then switch to abrax
if [[ $USER != *"abrax"* ]]; then
  if [[ $USER = *"root"* ]]; then
    su abrax
    adduser abrax
    usermod -aG sudo abrax
    su abrax
    exit
  else
    su abrax
    sudo adduser abrax
    sudo usermod -aG sudo abrax
    su abrax
    exit
  fi
fi
echo user2

TASK "check last update time"
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

installme git
git config --global user.email "abraxas678@gmail.com"
git config --global user.name "abraxas678"

installme curl
installme wget
installme nfs-common
echo

RES=$(which tailscale)
if [[ $? != "0" ]]; then
  echo install tailscale
  sleep 3
  curl -s 5 -fsSL https://tailscale.com/install.sh 
  curl -s 5 -fsSL https://tailscale.com/install.sh | sh
fi
sudo tailscale up --ssh
echo
export BH_URL="http://100.68.60.71:8081"
which bh
if [[ $? != "0" ]]; then
TASK bashhub 
curl -OL https://bashhub.com/setup && $SHELL setup
fi

SNAS_IP=$(tailscale status | grep snas | awk '{print $1}')
COUNT=${#SNAS_IP}
[[ "$COUNT" = "0" ]] && read -p "SNAS-IP: >> " SNAS_IP
echo
header2 "SNAS_IP: $SNAS_IP"
echo
read -t 2 me

if [[ ! -f /home/mnt/snas/setup/MOUNT_CHECK ]]; then
# Install ubuntu-desktop and xrdp
#sudo apt install ubuntu-desktop xrdp -y

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
echo
TASK="MOUNT SNAS"
read -t 2 -p "starting: $TASK" me; echo

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
echo
TASK="get mount.sh"
read -t 2 -p "starting: $TASK" me; echo
echo
curl -s -L https://raw.githubusercontent.com/abraxas678/public/master/mount.sh -o mount.sh
echo
TASK="start mount.sh"
read -t 2 -p "starting: $TASK" me; echo

source ./mount.sh
echo
TASK="mount dirs"
read -t 2 -p "starting: $TASK" me; echo

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
echo
TASK="check mount"
read -t 2 -p "starting: $TASK" me; echo
fi

# Wait until setup directory is mounted
while [[ ! -f /home/mnt/snas/setup/MOUNT_CHECK ]]; do
  echo "checking mount"
  sleep 1
done

mkdir /home/abrax/.config -p
[[ ! -f /home/abrax/.config/sync.txt ]] && cp /home/mnt/snas/setup/sync.txt /home/abrax/.config/
[[ ! -f /home/abrax/bin/sync.sh ]] && cp /home/mnt/snas/setup/sync.sh /home/abrax/bin/

echo
header1 sync.sh --skip
/home/abrax/bin/sync.sh --skip

# Source start2.sh script
echo
echo "STARTING START2.SH"
sleep 2

source /home/mnt/snas/setup/start2.sh
