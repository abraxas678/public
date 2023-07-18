#!/bin/bash
USER=$(whoami)
MY_MAIN_USER=abraxas
echo "#####################################################################"
echo "                      CHECKING USER DETAILS                          "
echo "#####################################################################"
echo
echo "CURRENT USER: $USER"
echo "MY_MAIN_USER: $MY_MAIN_USER"
echo
read -p BUTTON5 -t 5 me
#echo  >/home/$MY_MAIN_USER/mysudo
### && [[ ! $(id -u $MY_MAIN_USER) ]]
if [[ $USER != "$MY_MAIN_USER" ]]; then
  sudo adduser $MY_MAIN_USER 
  sudo passwd $MY_MAIN_USER 
  sudo usermod -aG sudo  $MY_MAIN_USER 
  su $MY_MAIN_USER
fi
#[[ $USER != "$MY_MAIN_USER" ]] && su $MY_MAIN_USER
[[ $USER != "$MY_MAIN_USER" ]] && echo BUTTON && read me || read -t 1 me
