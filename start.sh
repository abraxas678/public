#!/bin/bash
echo
MYPWD=$PWD
# Check if script is running with root privileges
if [ "$(id -u)" = 0 ]; then
    MYSUDO=""
else
    MYSUDO="sudo"
fi
instme() {
   if ! command -v $1 &> /dev/null; then
      echo -e "\033[32mInstalling $1...\033[0m"
      $MYSUDO apt update && $MYSUDO apt install $1 -y
   else
       echo -e "\033[33mgh is already installed\033[0m"
   fi

}

#[[ ! -f /media/abrax/KopiaBackup/chez.tar.cpt ]] && echo "/media/abrax/KopiaBackup/chez.tar.cpt" && exit
mkdir -p ~/.ssh
mkdir -p ~/.config/chezmoi
#cp /media/abrax/KopiaBackup/chez.tar.cpt ~/.config/chezmoi/
#sleep 3

#instme ccrypt
instme fd

cd ~/.config/chezmoi
#if [[ ! -f ~/.ssh/bws.dat ]]; then
#ccrypt -d chez.tar.cpt
#tar xf chez.tar
#fi
cd
mv $(fdfind bws.dat) $HOME/.ssh/
mv $(fdfind chezmoi.toml) $HOME/.config/chezmoi/
mv $(fdfind key.txt) $HOME/.config/chezmoi/

# Check if age is installed, install if not
instme age
instme gh

# Check if bws.keyx already exists
#if [[ ! -f ~/.ssh/bws.keyx ]]; then
    # Decrypt bws.tar.age
#    read -p "age priv key: >" me
#    echo $me >~/.ssh/akey.txt
#    age -d -i ~/.ssh/key.txt ~/.ssh/bws.tar.age > ~/.ssh/bws.tar

    # Extract bws.tar
#    tar -xvf ~/.ssh/bws.tar -C ~/.ssh/
#else
#    echo -e "\033[33mbws.keyx already exists, skipping decryption and extraction\033[0m"
#fi

# Display system update menu

echo -e "\n\033[1;34m=== System Update ===\033[0m"
update_choice=n
read -t 5 -n 1 -p "Do you want to update and upgrade the system? (Y/n): " update_choice
echo

if [[ $update_choice =~ ^[Nn]$ ]]; then
    echo -e "\033[33mSkipping system update\033[0m"
else
    # Update and upgrade system
    update_system() {
        echo -e "\033[32mUpdating package lists...\033[0m"
        $MYSUDO apt update
        if [ $? -eq 0 ]; then
            echo -e "\033[32mUpgrading packages...\033[0m"
            $MYSUDO apt upgrade -y
        else
            echo -e "\033[31mFailed to update package lists\033[0m"
            exit 1
        fi
    }
    update_system
fi

if [[ ! -f $HOME/.ssh/STANDARD_USER ]]; then
# Create new user account
while true; do
    echo -e "\n\033[1;34m=== User Account Creation ===\033[0m"
    read -p "Please enter the desired username: " STANDARD_USER
    if [[ $STANDARD_USER =~ ^[a-z_][a-z0-9_-]*$ ]]; then
        echo $STNDARD_USER >$HOME/.ssh/STANDARD_USER
        break
    else
        echo "Invalid username. Use only lowercase letters, numbers, underscores and hyphens. Must start with a letter or underscore."
    fi
done
else
  STANDARD_USER=$(cat $HOME/.ssh/STANDARD_USER)
fi
# Create and configure new user account
configure_user() {
    if ! id "$STANDARD_USER" &>/dev/null; then
        $MYSUDO adduser $STANDARD_USER && $MYSUDO usermod -aG sudo $STANDARD_USER && passwd $STANDARD_USER
    fi
}
configure_user

# Install Tailscale
tailscale_setup() {
    tailscale status >/dev/null 2>&1
    RES="$?"
    [[ $RES != 0 ]] && curl -fsSL https://tailscale.com/install.sh | sh

    sudo tailscale up -ssh
}

# Install Thorium browser
install_thorium() {
    command -v thorium-browser
    RES=$?
    if [[ $RES != 0 ]]; then
         wget $($MYPWD/github_latest_release_url.sh Alex313031 thorium)
         $MYSUDO apt update
#         $MYSUDO apt install *thorium*deb
#        cd ~/Downloads
#        echo open https://github.com/Alex313031/thorium/releases
#        open https://github.com/Alex313031/thorium/releases
        
#        x=1
#        while [[ $x = 1 ]]; do
#             [[ $(ls ~/Downloads/thorium-browser*.deb | wc -l) -gt 0 ]] && x=0 || sleep 1
#        done
#        read -p "URL for thorium: > " THURL
#        wget $THURL
#        sudo apt install -y ./$(basename $THURL)
#        $MYSUDO apt update
        $MYSUDO apt install -y ./$(ls thorium*deb | head -n 1)
        echo
        echo "THORIUM DONE - close after BW & PROTON setup"
        sleep 5
        thorium-browser
    fi
}
install_thorium
echo
echo "CLOSE FIREFOX AND PRESS ENTER"
echo
read me
sudo apt purge firefox -y
sudo apt purge firefox-esr -y

# Install additional packages
install_packages() {
    echo
#    sudo apt update
    instme ansible 
    instme restic 
    instme copyq 
    instme rclone
}
install_packages
sudo restic self-update

# Wait for chezmoid configuration files
gh auth login

wait_for_chezmoid() {
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
}
wait_for_chezmoid

# Initialize Chezmoi
read -p "GITHUB_USERNAME: > " GITHUB_USERNAME
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --ssh --apply $GITHUB_USERNAME
echo

# Install Atuin
install_atuin() {
    command -v atuin 
    RES=$?
    if [[ $RES != 0 ]]; then
        echo ATUIN
        curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
    fi
}
install_atuin

# Setup Tailscale
tailscale_setup
