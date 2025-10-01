#!/bin/bash
NAME="$(echo $1 | sed "s/.tar.zst//")"
mkdir -p "$PWD/$NAME"
tar --zstd -xf "$1" -C "$PWD/$NAME"
