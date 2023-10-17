#!/bin/bash
mkdir $HOME/tmp -p
cd $HOME/tmp
curl https://i.jpillora.com/slavaGanzin/await! >await.sh
chmod +x await.sh
sudo ./await.sh
