#!/bin/bash
sudo apt update
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vlt -y
sudo apt install firefox -y
sudo apt install firefox-esr -y
export DISPLAY=$(awk '/nameserver/ {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
firefox
vlt config init
