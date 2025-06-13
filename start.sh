#!/bin/bash
if [ "$(id -u)" = 0 ]; then
    MYSUDO=""
else
    MYSUDO="sudo"
fi

echo -e "\n\033[1;34m=== System Update ===\033[0m"
read -n 1 -p "Do you want to update and upgrade the system? (Y/n): " update_choice
echo

if [[ $update_choice =~ ^[Nn]$ ]]; then
    echo -e "\033[33mSkipping system update\033[0m"
else
    echo -e "\033[32mUpdating package lists...\033[0m"
    $MYSUDO apt update
    if [ $? -eq 0 ]; then
        echo -e "\033[32mUpgrading packages...\033[0m"
        $MYSUDO apt upgrade -y
    else
        echo -e "\033[31mFailed to update package lists\033[0m"
        exit 1
    fi
fi

while true; do
    echo -e "\n\033[1;34m=== User Account Creation ===\033[0m"
    read -p "Please enter the desired username: " STANDARD_USER
    if [[ $STANDARD_USER =~ ^[a-z_][a-z0-9_-]*$ ]]; then
        break
    else
        echo "Invalid username. Use only lowercase letters, numbers, underscores and hyphens. Must start with a letter or underscore."
    fi
done

if ! id "$STANDARD_USER" &>/dev/null; then
    $MYSUDO adduser $STANDARD_USER && $MYSUDO usermod -aG sudo $STANDARD_USER && passwd $STANDARD_USER
fi

tailscale_setup() {
  tailscale status >/dev/null 2>&1
  RES="$?"
  [[ $RES != 0 ]] && curl -fsSL https://tailscale.com/install.sh | sh

  sudo tailscale up -ssh
}

command -v thorium-browser
RES=$?
if [[ $RES != 0 ]]; then
open https://github.com/Alex313031/thorium/releases
read -p "URL for thorium: > " THURL
wget $THURL
sudo apt install -y ./$(basename $THURL)
echo
echo "THORIUM DONE"
thorium-browser
sleep 5
fi

echo
sudo apt update
sudo apt install -y ansible restic copyq rclone
echo
x=1
while [[ $x = 1 ]]; do
  echo "waiting for toml & key in ~/Downloads"
  if [[ ! -f ~/.config/chezmoi/chezmoi.toml ]] || [[ ! -f ~/.config/chezmoi/key.txt ]]; then
  if [[ -f ~/Downloads/chezmoi.toml ]]; then
    if [[ -f ~/Downloads/key.txt ]]; then
      mv ~/Downloads/chezmoi.toml ~/.config/chezmoi/
      mv ~/Downloads/key.txt ~/.config/chezmoi/
      x=0
    fi
  fi
  else
    x=0
  fi
  sleep 3
  tput cuu1; tput ed
done

read -p "GITHUB_USERNAME: > " GITHUB_USERNAME
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --ssh --apply $GITHUB_USERNAME
echo
command -v atuin
RES=$?
if [[ $RES != 0 ]]; then
echo ATUIN
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
fi
echo
#sudo apt install -y libc6 libgcc-s1 libgl1 libgtk-3-0 libstdc++6 libx11-6
tailscale_setup
