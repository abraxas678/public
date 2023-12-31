#!/bin/bash
mkdir $HOME/tmp -p
cd $HOME/tmp
wget https://github.com/binwiederhier/pcopy/releases/download/v0.6.1/pcopy_0.6.1_amd64.deb
sudo apt install pcopy_0.6.1_amd64.deb -y
