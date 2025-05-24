#!/bin/bash
cd "$(dirname "$0")" || exit 1
PARU_PATH=$(which paru)

if [ -z "$PARU_PATH" ]; then
    gum confirm "Command paru was not found, do you want to install it?" && install_paru=true || exit 1
fi

if [ "$install_paru" = true ]; then
    ./install_paru.sh
fi
