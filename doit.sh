#!/bin/sh
echo "$(md5sum "$1" | awk '{print $1}')|$1|$(basename "$1")"
