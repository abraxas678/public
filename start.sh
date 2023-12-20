#!/bin/bash
clear
echo v0.1
sleep 1

MYPWD=$PWD
cd $HOME

which tmux >/dev/null 2>&1; [[ "$?" != "0" ]] && sudo apt update && sudo apt install tmux tmuxinator -y

curl -L https://raw.githubusercontent.com/abraxas678/public/master/start_TMUX.sh -o ~/tmp/start_TMUX.sh
chmod +x ~/tmp/start_TMUX.sh

curl -L https://raw.githubusercontent.com/abraxas678/public/master/setup.yml -o ~/tmp/setup.yml

tmuxinator start -p $HOME/tmp/setup.yml
exit
