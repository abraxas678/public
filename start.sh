#!/bin/bash
clear
echo v0.1
sleep 1

mkdir ~/tmp -p
MYPWD=$PWD
cd $HOME

which tmux >/dev/null 2>&1; [[ "$?" != "0" ]] && sudo apt update && sudo apt install tmux tmuxinator -y

curl -s -L https://raw.githubusercontent.com/abraxas678/public/master/start_TMUX.sh -o ~/tmp/start_TMUX.sh
chmod +x ~/tmp/start_TMUX.sh

curl -s -L https://raw.githubusercontent.com/abraxas678/public/master/.p10kmini.zsh -o ~/.p10kmini.zsh
curl -s -L https://raw.githubusercontent.com/abraxas678/public/master/setup.yml -o ~/tmp/setup.yml

echo "STATE1" >~/tmp/setup_status.txt
#tmuxinator start -p $HOME/tmp/setup.yml
~/tmp/start_TMUX.sh
exit
