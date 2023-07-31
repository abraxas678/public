#!/bin/bash
echo
read -n 1 -p "WSL? (y/n) >>" WSL
echo
read -p "HOSTNAME: >>" HOSTNAME
if [[ $WSL = "y" ]]; then
  cd /home/abraxas/public
  cp wsl.conf wsl-work.conf
  sed -i "s/CHANGEME/$HOSTNAME/g" wsl-work.conf
  sudo mv wsl-work.conf /etc/wsl.conf
  cp /etc/hosts .
  cp /etc/hostname .
  sed -i "s/$(hostname)/$HOSTNAME/g" hosts
  sed -i "s/$(hostname)/$HOSTNAME/g" hostname
  sudo mv hosts /etc/
  sudo mv hostname /etc/
  echo
  echo === REBOOT NOW ===
  echo
  read -n 1 -p "SHALL I REBOOT FOR YOU? (y/n) >>" REBOOT
  [[ $REBOOT = "y" ]] && sudo reboot -f
else
  cd /home/abraxas/public
  cp /etc/hosts .
  cp /etc/hostname .
  sed -i "s/$(hostname)/$HOSTNAME/g" hosts
  sed -i "s/$(hostname)/$HOSTNAME/g" hostname
  sudo mv hosts /etc/
  sudo mv hostname /etc/
fi
