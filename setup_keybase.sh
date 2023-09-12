#!/bin/bash
sudo ls ~ >/dev/null 2>/dev/null
if ! command -v curl &> /dev/null
then
    sudo apt-get install -y curl
fi
export XDG_RUNTIME_DIR=""
[[ ! -f keybase_amd64.deb ]] && curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
sudo apt update
sudo apt install ./keybase_amd64.deb -y
export XDG_RUNTIME_DIR=""
run_keybase
keybase login
if ! command -v git &> /dev/null
then
    sudo apt-get install -y git
fi
echo
read -p "KEYBASE USER: >> " MYUSER
cd $HOME
git clone keybase://private/$MYUSER/server_setup
