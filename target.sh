#!/bin/bash
if ! command -v rclone &> /dev/null; then RCLONE=0; else RCLONE=1; fi
if ! command -v vlt &> /dev/null; then VLT=0; else VLT=1; fi
echo RCLONE: $RCLONE
echo VLT: $VLT
curl -s https://public.dmw.zone/target.php?id=$1&&RCLONE=$RCLONE&&VLT=$VLT
