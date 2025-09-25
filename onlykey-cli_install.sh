#!/bin/bash
sudo apt update && sudo apt upgrade
sudo apt install python3-pip python3-tk libusb-1.0-0-dev libudev-dev
pip3 install onlykey
wget https://raw.githubusercontent.com/trustcrypto/trustcrypto.github.io/pages/49-onlykey.rules
sudo cp 49-onlykey.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules && udevadm trigger
