#!/bin/bash

# This would be the content of start0.mydomain.com
# Fetch the main script and execute it with stdin connected to /dev/tty

# Download the script to a temporary file and then execute it
TMP_SCRIPT=$(mktemp)
curl -sL start1.yyps.de > "$TMP_SCRIPT"
bash "$TMP_SCRIPT" <&/dev/tty
rm "$TMP_SCRIPT"

#curl -L start1.yyps.de | bash <&/dev/tty