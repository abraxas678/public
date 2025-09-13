#!/bin/bash
if [ "$(id -u)" = 0 ]; then
    MYROOT=""
else
    MYROOT="sudo"
fi

$MYROOT apt update
$MYROOT apt install wget curl -y
$MYROOT apt-get update && $MYROOT apt-get install coreutils -y  #shred
mkdir ./start0tmp && mount -t tmpfs -o size=500m tmpfs ./start0tmp
cd start0tmp

wget https://s.xxxyzzz.xyz/start0.key.keyx.tar.age
wget https://s.xxxyzzz.xyz/start.age.key.kdbx

read -s -p "AGE PRIVATE KEY: > " me
echo $me >key.txt
#cat key.txt
unset me

age --decrypt -i key.txt -o start0.key.keyx.tar start0.key.keyx.tar.age
tar xf start0.key.keyx.tar
shred -uvn 10 start0.key.keyx.tar
shred -uvn 10 rm start0.key.keyx.tar.age
shred -uvn 10 rm key.txt

