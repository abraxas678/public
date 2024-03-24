#!/bin/bash
mkdir -p $HOME/tmp
cd $HOME/tmp
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
ORANGE='\033[0;33m'
GREY='\033[0;37m'
LIGHT_BLUE='\033[1;34m'
RC='\033[0m'
echo
echo -e "${YELLOW}>>> app.sh: $1 <<<${RC}" #yellow
echo
echo -e "${BLUE}content:${LIGHT_BLUE}" #yellow
curl -sL $1.yyps.de | tee apptmp.sh 
[[ $? = 0 ]] && echo && echo -e "${GREEN}DOWNLOAD SUCCESSFULL${RC}"
echo "echo" >>apptmp.sh
chmod +x apptmp.sh 
echo
echo -e "${YELLOW}>>> executing $1.yyps.de $2 <<<${RC}" #yellow
echo
./apptmp.sh $2
[[ $? = 0 ]] && echo -e "${GREEN}DONE${RC}"
[[ $? != 0 ]] && echo -e "${RED}DONE WITH ERROR${RC}"

rm -f apptmp.sh
