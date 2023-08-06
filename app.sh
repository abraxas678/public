#!/bin/bash
echo
echo ">>> app.sh: $1 <<<" #yellow
curl -L $1.yyps.de >apptmp.sh 
chmod +x apptmp.sh 
./apptmp.sh 
rm -f apptmp.sh
