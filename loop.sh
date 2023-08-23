#!/bin/bash
while [[ 1 = 1 ]]; do
curl -d "$(hostname) loop" https://n.yyps.de/auto
sleep 60
done
