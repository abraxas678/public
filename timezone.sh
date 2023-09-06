#!/bin/bash
#sudo dpkg-reconfigure tzdata
sudo timedatectl set-timezone Europe/Berlin
sleep 1; printf "your time now: "; sudo hwclock --show
