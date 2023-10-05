
 1
 2
 3
 4
 5
 6
 7
 8
 9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
#!/bin/bash
USER=$(whoami)
SUDO="sudo"
[[ $USER = "root" ]] && SUDO=""
read -p "target user name: >> " MY_MAIN_USER
echo "#####################################################################"
echo "                      CHECKING USER DETAILS                          "
echo "#####################################################################"
echo
echo "CURRENT USER: $USER"
echo "MY_MAIN_USER: $MY_MAIN_USER"
echo
read -p BUTTON5 -t 5 me
#echo  >/home/$MY_MAIN_USER/my$SUDO
### && [[ ! $(id -u $MY_MAIN_USER) ]]
if [[ $USER != "$MY_MAIN_USER" ]]; then
  $SUDO adduser $MY_MAIN_USER 
  $SUDO passwd $MY_MAIN_USER 
  $SUDO usermod -aG $SUDO  $MY_MAIN_USER 
  su $MY_MAIN_USER
fi
#[[ $USER != "$MY_MAIN_USER" ]] && su $MY_MAIN_USER
[[ $USER != "$MY_MAIN_USER" ]] && echo BUTTON && read me || read -t 1 me
echo "#####################################################################"
echo "                      CHECKING MACHINE                               "
echo "#####################################################################"
curl -L wsl.yyps.de >wsl.conf
sed -i "s/CHANGEME/$MYHOSTNAME/" wsl.conf
$SUDO sed -i "s/$(hostname)/$MYHOSTNAME/g" /etc/hostname
$SUDO sed -i "s/$(hostname)/$MYHOSTNAME/g" /etc/hosts
