#!/bin/bash
echo "Installing paru..."

sudo pacman -Syu --needed --noconfirm git base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
rm -rf ./paru
