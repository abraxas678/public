#!/bin/bash
mkdir -p $HOME/tmp
cd $HOME/tmp
#wget https://nx7.xxxyzzz.xyz/s/bwsinstall/download/bws_install.sh
#chmod +x bws_install.sh
#./bws_install.sh
sudo apt update && sudo apt upgrade -y; sudo apt install wget curl git gh keepassxc -y
[[ ! -f start.kdbx ]] && wget https://nx7.xxxyzzz.xyz/s/startkddb/download/start.kdbx
pkill firefox -f
sudo apt purge firefox -y
sudo apt purge firefox-esr -y
command -v docker
[[ $? != 0 ]] && sh <(curl -sSL https://get.docker.com)
if [[ ! -f /usr/bin/bws ]]; then
   wget https://github.com/bitwarden/sdk-sm/releases/download/bws-v1.0.0/bws-x86_64-unknown-linux-gnu-1.0.0.zip
   unzip bws-x86_64-unknown-linux-gnu-1.0.0.zip
  sudo mv bws /usr/bin/
  /usr/bin/bws config server-base https://vault.bitwarden.eu
fi

x=1
while [[ $x = 1 ]]; do
  [[ ! -f /media/abrax/KEYS/MOUNT_CHECK ]] && echo "connect KEY and OK" && sleep 1 && tput cup 10 0 && tput ed || x=0
done
#sudo keepassxc-cli show ./start.kdbx BWS_ACCESS_TOKEN -k /media/abrax/KEYS/start.keyx  --yubikey 2 --show-protected --no-password | grep -v grep | grep Password | sed "s/Password: //"
export BWS_ACCESS_TOKEN="$(sudo keepassxc-cli show ./start.kdbx BWS_ACCESS_TOKEN -k /media/abrax/KEYS/start.keyx  --yubikey 2 --show-protected --no-password | grep -v grep | grep Password | sed "s/Password: //")"
echo BAT: $BWS_ACCESS_TOKEN
read -t 10 -p B me

command -v tailscale
[[ $? != 0 ]] && curl -fsSL https://tailscale.com/install.sh | sh
export TS_KEY1=d2d9e280-7e70-4cbd-aa68-b31500d0ecbe
/usr/bin/bws run echo $TS_KEY1
/usr/bin/bws run -- sudo tailscale up --auth-key=$TS_KEY1 --ssh
tailscale status
COUNT=$(gh auth status 2>&1 | grep 'Logged in to github.com as abraxas678' | wc -l)
[[ $COUNT = 0 ]] && gh auth login
mkdir -p $HOME/tmp
cd $HOME/tmp
[[ ! -d $HOME/tmp/public ]] && gh repo clone public
/bin/bash -c $HOME/tmp/public/start.sh
