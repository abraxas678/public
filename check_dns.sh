#!/bin/bash
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
