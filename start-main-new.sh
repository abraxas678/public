#!/bin/bash

# Clear the terminal
clear

# Set home directory variable
MYHOME=$HOME
echo "MYHOME=$MYHOME"

# Pause for 1 second
sleep 1

# Change to home directory
cd $HOME

# Print version
echo "version: NEWv14"

# Print sync files and rclone config
echo
echo "cd $MYHOME/bin/ 
up sync.sh 
up down.sh 
up sync.txt 
up header.sh
up header2.sh
up ~/.config/rclone/rclone.conf"
echo

# Color definitions
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
ORANGE='\033[0;33m'
GREY='\033[0;37m'
LIGHT_BLUE='\033[1;34m'
RESET='\033[0m'
RC='\033[0m'

# Get current release version
CUR_REL=$(curl -L start.yyps.de | grep "echo version:" | sed 's/echo version: NEWv//')
NEW_REL=$((CUR_REL + 1))

# Print current and new release versions
echo "CUR_REL: $CUR_REL"
echo "NEW_REL: $NEW_REL"

# Install a package if not already installed
installme() {
  which $@ > /dev/null
  if [[ $? != 0 ]]; then
    echo -e "${YELLOW}INSTALL: $1${RESET}"
    countdown 1
    sudo apt install -y $1
  fi
}

# Install Homebrew and its dependencies
brew_install() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
  sudo apt-get install -y build-essential
  brew install gcc
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $MYHOME/.zshrc
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  exec zsh
  export ANS=n
}

# Wait for a new release
release_wait() {
  while true; do
    echo "WAITING FOR RELEASE"
    sleep 5
    CUR_REL=$(curl -L start.yyps.de | grep "echo version:" | sed 's/echo version: NEWv//')
    echo "$CUR_REL $NEW_REL"
    [[ $CUR_REL == $NEW_REL ]] && break
  done
  echo "Release ready"
  exit
}

# Check if user wants to wait for the next release
VERS="n"
read -t 5 -n 1 -p "[W]AIT FOR NEXT RELEASE - v$NEW_REL? >>" VERS
[[ $VERS == "w" ]] && release_wait
echo

# Check DNS and connectivity
check_dns() {
  echo "check_dns"
  cd $HOME
  sudo ping -c 1 google.com > /dev/null && echo "Online" || echo "Offline"
  sudo ping -c 1 google.com > /dev/null && ONL=1 || ONL=0
  if [[ $ONL == 0 ]]; then
    CHECK=$(cat /etc/resolv.conf)
    if [[ $CHECK != *"8.8.8.8"* ]] ; then
      echo "DNS is not set to 8.8.8.8"
    fi
    sudo ping -c 1 google.com > /dev/null && echo "Online" || echo "Offline"
  fi
}

# Print header1
header1(){
  echo -e "${YELLOW}$@${RESET}"  
}

# Print header2
header2(){
  TEXT=$(echo "$@" | tr '[:lower:]' '[:upper:]')
  echo -e "${LIGHT_BLUE}$TEXT${RESET}"
}

# Countdown function
countdown() {
  if [ -z "$1" ]; then
    echo "No argument provided. Please provide a number to count down from."
    exit 1
  fi

  tput civis
  for ((i=$1; i>0; i--)); do
    if (( i > $1*66/100 )); then
      echo -ne "${GREEN}$i${RESET}\r"
    elif (( i > $1*33/100 )); then
      echo -ne "${YELLOW}$i${RESET}\r"
    else
      echo -ne "${RED}$i${RESET}\r"
    fi
    sleep 1
    echo -ne "\033[0K"
  done
  echo -e "${RESET}"
  tput cnorm
}

# Task function with header and countdown
TASK() {
  echo
  header1 "$@"
  countdown 1
}

# Initial DNS check
check_dns

# Change machine name if hostname is 'lenovo'
if [[ "$(hostname)" == "lenovo" ]]; then
  header2 "change machine name"
  echo "hostname=lenovo"
  cd $HOME
  curl -sL machine.yyps.de > machine.sh
  chmod +x machine.sh
  ./machine.sh
fi

# Create temporary directory and update apt
mkdir -p ~/tmp
cd ~/tmp
sudo apt update && sudo apt install -y unzip
[[ ! -f Terminus.zip ]] && [[ ! -d Terminus ]] && wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Terminus.zip && unzip Terminus.zip && sudo mv *.ttf /usr/share/fonts/truetype && sudo fc-cache -fv 

# Task: Check if user is 'abrax'
TASK "CHECK: USER = abrax?"
if [[ $USER != *"abrax"* ]]; then
  sudo apt install -y sudo
  if [[ $USER == *"root"* ]]; then
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

# Task: Check last apt update time
TASK "check last update time"
ts=$(date +%s)
if [[ -f ~/last_apt_update.txt ]]; then
  DIFF=$(($ts - $(cat ~/last_apt_update.txt)))
  if [[ $DIFF -gt 6000 ]]; then
    sudo apt update && sudo apt upgrade -y
  fi
else
  sudo apt update && sudo apt upgrade -y
fi
echo $ts > ~/last_apt_update.txt

# Task: Install dependencies using apt
header2 "install dependencies using apt"
countdown 1
installme curl
installme git
installme gh
git config --global user.email "abraxas678@gmail.com"
git config --global user.name "abraxas678"

# GitHub authentication and cloning repositories
gh repo list > /dev/null
if [[ $? == 0 ]]; then
  echo "gh logged in"
  sleep 1
else
  gh status
  gh auth refresh -h github.com -s admin:public_key
  gh ssh-key add ./id_ed25519.pub
fi
echo

# Clone repositories if not already cloned
cd
if [[ ! -d $MYHOME/bin ]]; then
  gh repo clone abraxas678/bin
  sleep 1
  gh repo clone abraxas678/.config
  sleep 1
fi

# Set permissions for bin scripts
chmod +x ~/bin/*

# Install additional packages
installme davfs2
installme unzip
installme wget
installme zoxide
installme copyq
installme keepassxc

# Install rclone beta
echo "rclone beta"
countdown 1
sudo -v
curl https://rclone.org/install.sh | sudo bash -s beta

# Install Python packages using pipx
installme python3-pip
installme pipx
pipx install rich-cli
pipx install shell-gpt
pipx install apprise

# Install Tailscale
which tailscale > /dev/null
if [[ $? != 0 ]]; then
  echo "install tailscale"
  sleep 1
  curl -L https://tailscale.com/install.sh | sh
fi
sudo tailscale up --ssh --accept-routes
tailscale status
countdown 2

tailscale status
if [[ $? != 0 ]]; then
  sudo tailscaled --tun=userspace-networking --socks5-server=localhost:1055 --outbound-http-proxy-listen=localhost:1055 &
  countdown 2
  sudo tailscale up --ssh --accept-routes
fi

# DNS check
echo
check_dns

# Set BH_URL environment variable
export BH_URL="http://100.98.141.82:8081"
echo
echo "BH_URL: $BH_URL"
echo
sleep 1

# Add BH_URL to shell rc files if not already present
if [[ $(cat ~/.bashrc) != *"BH_URL"* ]]; then
  echo "export BH_URL=\"http://$( tailscale status | grep hetzner | awk '{print $1}'):8081\"" >> ~/.bashrc
fi
if [[ $(cat ~/.zshrc) != *"BH_URL"* ]]; then
  echo "export BH_URL=\"http://$( tailscale status | grep hetzner | awk '{print $1}'):8081\"" >> ~/.zshrc
fi
source ~/.zshrc
source ~/.bashrc

# DNS check
check_dns

# Install nvm, node, and yarn
which nvm > /dev/null
if [[ $? != 0 ]]; then
  echo -e "${YELLOW}INSTALL: nvm${RESET}"
  countdown 1
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi
which node > /dev/null
if [[ $? != 0 ]]; then
  echo -e "${YELLOW}INSTALL: node${RESET}"
  countdown 1
  nvm install --lts
fi
which yarn > /dev/null
if [[ $? != 0 ]]; then
  echo -e "${YELLOW}INSTALL: yarn${RESET}"
  countdown 1
  npm install --global yarn
fi

# Install Homebrew if not already installed
which brew > /dev/null
if [[ $? != 0 ]]; then
  echo -e "${YELLOW}INSTALL: Homebrew${RESET}"
  countdown 1
  brew_install
fi

# Install utilities using Homebrew
installme bat
installme exa
installme zoxide
installme fzf
installme fd
installme neovim
installme chezmoi
installme zsh
installme tmux
installme starship
installme ripgrep

# Run chezmoi init
chezmoi init abraxas678 --apply

# Update or initialize dotfiles repository
DOTFILES_DIR="$MYHOME/.local/share/chezmoi"
cd "$DOTFILES_DIR"
git pull
[[ $? != 0 ]] && git init && git remote add origin git@github.com:abraxas678/chezmoi.git && git pull origin master

# Tailscale status check
TAILSCALE=$(tailscale status | grep dasaqwe | wc -l)
echo "Tailscale connected devices: $TAILSCALE"

# Set up rclone
TASK "check: rclone"
if [[ ! -f $MYHOME/.config/rclone/rclone.conf ]]; then
  mkdir -p $MYHOME/.config/rclone
  curl https://rclone.org/rclone.conf -o $MYHOME/.config/rclone/rclone.conf
  echo -e "${YELLOW}EDIT: rclone.conf${RESET}"
  read -p "Press any key to continue..." -n1 -s
  vim $MYHOME/.config/rclone/rclone.conf
fi

# Check GitHub repository for updates
TASK "Check: GitHub"
GITSTATUS=$(git status)
echo $GITSTATUS
[[ $GITSTATUS != *"nothing to commit"* ]] && git add . && git commit -m "Auto-update" && git push

# Additional tasks and clean-up
echo "Additional setup tasks..."

# Final echo statement
echo "Script execution completed."
