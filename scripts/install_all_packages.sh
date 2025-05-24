#!/bin/bash
cd "$(dirname "$0")" || exit 1
./check_paru.sh

PACKAGES="aylurs-gtk-shell-git bat brightnessctl btop btrbk btrfs-progs edk2-shell efibootmgr eza \
file-roller font-manager ghostty google-chrome grim gst-plugin-pipewire gvfs gvfs-afc \
gvfs-gphoto2 gvfs-mtp gvfs-smb helvum htop hyprland hyprpaper hyprpicker intel-media-driver \
intel-ucode iwd jq alacritty lazydocker lazygit less libpulse libva-intel-driver luarocks ly mandoc \
micro mise nano neofetch neovim network-manager-applet networkmanager noto-fonts-emoji nwg-displays \
nwg-look oh-my-posh otf-space-grotesk pavucontrol pipewire pipewire-alsa pipewire-jack pipewire-pulse \
polkit-kde-agent qt5-wayland qt6-wayland ranger reflector slurp smartmontools sof-firmware stow thunar \
thunar-archive-plugin ttf-roboto-mono-nerd ttf-space-mono-nerd vim vulkan-intel wavemon wget wireless_tools \
wireplumber wl-clipboard wofi xdg-desktop-portal-gtk xdg-desktop-portal-hyprland xdg-user-dirs xdg-utils \
xorg-server xorg-xinit zed zellij zram-generator zsh"

# Install packages
paru -Syu --needed --noconfirm $PACKAGES
