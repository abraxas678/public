#!/bin/bash
clear
cd $HOME
echo version: NEWv0.2
read -t 2 me
echo
echo check_dns
cd $HOME
ping -c 1 google.com >/dev/null && echo "Online" || echo "Offline"
ping -c 1 google.com >/dev/null && ONL=1 || ONL=0
if [[ $ONL = "0" ]]; then
  CHECK=$(cat /etc/resolv.conf)
  if [[ $CHECK != *"8.8.8.8"* ]] ; then
    echo nameserver 8.8.8.8 >~/resolv.conf
    cat /etc/resolv.conf>>~/resolv.conf
    sudo mv ~/resolv.conf /etc/
  fi
ping -c 1 google.com >/dev/null && echo "Online" || echo "Offline"
fi

read -p "RCLONE_CONFIG_PASS >> " MYPW
export RCLONE_CONFIG_PASS="$MYPW"
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
  echo
  header1 $@
  countdown 1
}

installme() {
  which $@
  if [[ $? != "0" ]]; then
    echo
    echo -e "\e[33mINSTALL: $1\e[0m"  
  #  countdown 1
    sudo apt install $1 -y
  fi
}

#echo user1
TASK "CHECK: USER = abrax? "
# Check if user is not abrax, if not then switch to abrax
if [[ $USER != *"abrax"* ]]; then
  apt install -y sudo
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
#echo user2

TASK "check last update time"
ts=$(date +%s)
if [[ -f ~/last_apt_update.txt ]]; then
  DIFF=$(($ts-$(cat ~/last_apt_update.txt)))
  if [[ $DIFF -gt "6000" ]]; then
    sudo apt update && sudo apt upgrade -y
  fi
else
  sudo apt update && sudo apt upgrade -y
fi
echo $ts >~/last_apt_update.txt

TASK "install dependencies using apt"
installme git
git config --global user.email "abraxas678@gmail.com"
git config --global user.name "abraxas678"

installme curl
installme wget
installme nfs-common
installme rclone
installme restic
installme unison
installme python3-full
installme python3-pip
installme zsh
TASK "oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
TASK ".p10k"
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k



RES=$(which tailscale)
which tailscale >/dev/null 2>&1
if [[ $? != "0" ]]; then
  echo install tailscale
  #sleep 3
  curl -L https://tailscale.com/install.sh 
  #curl -s 5 -fsSL https://tailscale.com/install.sh | sh
  curl -L https://tailscale.com/install.sh | sh
fi
sudo tailscale up --ssh
tailscale status
sleep 1

tailscale status
if [[ $? != "0" ]]; then
  sudo tailscaled --tun=userspace-networking --socks5-server=localhost:1055 --outbound-http-proxy-listen=localhost:1055 &
  sudo tailscale up --ssh
fi
echo
export BH_URL="http://$( tailscale status | grep ionos0  | awk '{print $1}'):8081"
mybh="y"
which bh
if [[ $? != "0" ]]; then
read -t 10 -n 1 -p "BASHHUB? >> " mybh
if [[ $mybh = "y" ]]; then
TASK bashhub 
curl -OL https://bashhub.com/setup && $SHELL setup
fi
fi

SNAS_IP=$(tailscale status | grep snas | awk '{print $1}')
COUNT=${#SNAS_IP}
[[ "$COUNT" = "0" ]] && read -p "SNAS-IP: >> " SNAS_IP
echo
header2 "SNAS_IP: $SNAS_IP"
echo
read -t 1 me

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
read -t 1 -p "starting: $TASK" me; echo

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
read -t 1 -p "starting: $TASK" me; echo
curl -s -L https://raw.githubusercontent.com/abraxas678/public/master/mount.sh -o mount.sh
echo
TASK="start mount.sh"
read -t 1 -p "starting: $TASK" me; echo

source ./mount.sh
echo
TASK="mount dirs"
read -t 1 -p "starting: $TASK" me; echo

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
read -t 1 -p "starting: $TASK" me; echo
fi

# Wait until setup directory is mounted
while [[ ! -f /home/mnt/snas/setup/MOUNT_CHECK ]]; do
  echo "checking mount"
  sleep 1
done

mkdir /home/abrax/.config -p
[[ ! -f /home/abrax/.config/sync.txt ]] && cp /home/mnt/snas/setup/sync.txt /home/abrax/.config/
mkdir -p /home/abrax/.config/rclone/
[[ ! -f /home/abrax/.config/rclone/rclone.conf ]] && cp /home/mnt/snas/setup/rclone.conf /home/abrax/.config/rclone/
[[ ! -f /home/abrax/bin/sync.sh ]] && cp /home/mnt/snas/setup/sync.sh /home/abrax/bin/
[[ ! -f /home/abrax/bin/age ]] && cp /home/mnt/snas/setup/age /home/abrax/bin/
chmod +x /home/abrax/bin/*
sudo -v ; curl https://rclone.org/install.sh | sudo bash -s beta
echo
if [[ ! -f /home/abrax/.config/rclone/rclone.conf ]]; then
header1 'execute   curl -s -T ~/.config/rclone/rclone.conf "pcopy.dmw.zone/rc?t=3m"'
echo
read -p BUTTON me
curl -L pcopy.dmw.zone/rc -o ~/.config/rclone/rclone.conf
COUNT=$(rclone listremotes | wc -l)
[[ $COUNT > "100" ]] && echo "rclone.conf: OK"
fi
rclone copy snas:mutagen/.ssh ~/.ssh -P --progress-terminal-title --stats-one-line
rclone copy snas:mutagen/bin/sync.sh ~/bin/ -P --progress-terminal-title --stats-one-line
rclone copy snas:mutagen/bin/header.sh ~/bin/ -P --progress-terminal-title --stats-one-line
rclone copy snas:mutagen/bin/uni.sh ~/bin/ -P --progress-terminal-title --stats-one-line
rclone copy snas:mutagen/.config/sync.txt ~/.config/ -P --progress-terminal-title --stats-one-line
sudo chmod +x ~/bin/*
#sudo apt install -y python3-rich_cli
#export RCLONE_PASSWORD_COMMAND="ssh abraxas@snas cat /volume2/mutagen/.ssh/rclonepw.sh | bash"
echo
header1 sync.sh --skip --force
/home/abrax/bin/sync.sh --skip --force

# Source start2.sh script
#echo
#echo "STARTING START2.SH"
#sleep 1

#source /home/mnt/snas/setup/start2.sh
