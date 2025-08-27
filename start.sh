#!/bin/bash
mkdir /mnt/snas/setup -p
MYUSER=$(whoami)
sudo chown $MYUSER: -R /mnt/snas/setup
echo
echo COPY:
echo
echo snas.test:/volume1/setup /mnt/snas/setup nfs4 nfsvers=4.1,proto=tcp,hard,intr,timeo=600,retrans=2,rsize=32768,wsize=32768,nodev,nosuid,noexec 0 0
echo
echo
read -p "BUTTON" me
sudo nano /etc/fstab
sudo systemctl daemon-reload
sudo mount -a
