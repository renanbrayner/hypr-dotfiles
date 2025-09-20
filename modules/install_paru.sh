#!/bin/bash
cd "$(dirname "$0")" || exit 1
sudo pacman -Syu --needed --noconfirm git base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
rm -rf ./paru
