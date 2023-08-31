#!/bin/bash
export BH_URL=http://ionos1:8080
#export BH_URL=http://85.215.106.59:8080
curl -OL https://bashhub.com/setup 
chmod +x ./setup
./setup
