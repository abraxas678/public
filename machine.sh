#!/bin/bash
echo v0.2
cd $HOME
sudo apt install -y wget
read -p "new hostname: >> " HOSTNAME
HOSTNAME_OLD=$(hostname)
sudo hostnamectl set-hostname "$HOSTNAME"
sudo echo "$HOSTNAME" >$HOME/hostname
sudo mv $HOME/hostna; e /etc/hostname
echo; echo "/etc/hostname: "; cat /etc/hostname; echo
sudo sed -i "s/$HOSTNAME_OLD/$HOSTNAME/g" /etc/hosts
echo; echo "/etc/hosts: "; cat /etc/hosts; echo
cd $HOME
wget https://raw.githubusercontent.com/abraxas678/public/master/wsl.conf
#cp $HOME/server_setup/wsl.conf $HOME
sed -i "s/CHANGEHOSTNAME/$HOSTNAME/g" $HOME/wsl.conf
sudo mv wsl.conf /etc/
