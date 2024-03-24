#!/bin/bash

# Check if an argument was provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <server_address>"
  exit 1
fi

SERVER=$1

# Ping the server once
if ping -c 1 "$SERVER" &> /dev/null; then
  echo "Server $SERVER is reachable."
else
  echo "Server $SERVER is not reachable."
fi
