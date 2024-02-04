#!/bin/bash
MYUSER=$USER
brew install pueue
echo
rm -f /run/user/1000/pueue.pid
sudo chown $MYUSER: /run/user/1000/ -R
echo
pueued -d
echo
pueue add -- ls

