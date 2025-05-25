#!/bin/bash

COMMAND=$1
NUM=$2
OFFSET=$3
MON=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true) | .name')

if [ "$MON" = "eDP-1" ]; then
    hyprctl dispatch $COMMAND $NUM
elif [ "$MON" = "HDMI-A-1" ]; then
    hyprctl dispatch $COMMAND $((NUM+$OFFSET))
fi
