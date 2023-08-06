#!/bin/bash
mkdir $HOME/tmp >/dev/null 2>/dev/null
cd $HOME/tmp
VERSION=$(curl -Ls https://github.com/Nukesor/pueue/releases/latest | grep "<title>Release " | sed 's/.*<title>Release //' | sed 's/┬À Nukesor.*//' | sed 's/ //g')
wget "https://github.com/Nukesor/pueue/releases/download/$VERSION/pueued-linux-x86_64"
wget "https://github.com/Nukesor/pueue/releases/download/$VERSION/pueue-linux-x86_64"
mv pueued-linux-x86_64 pueued
mv pueue-linux-x86_64 pueue
chmod +x pueued
chmod +x pueue
sudo mv pueued /usr/bin/
sudo mv pueue /usr/bin/
/usr/bin/pueued -d
/usr/bin/pueue
echo done
