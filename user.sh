#!/bin/bash
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
