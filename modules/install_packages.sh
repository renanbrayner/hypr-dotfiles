#!/bin/bash
cd "$(dirname "$0")" || exit 1
../libs/check_paru.sh

SYS_MON="btop htop wavemon mission-center"
AUDIO="gst-plugin-pipewire helvum pavucontrol pipewire pipewire-alsa pipewire-jack pipewire-pulse libpulse wireplumber"
TUI_UTILS="lazygit lazydocker ranger tmux"
CLI_UTILS="jq fastfetch mise bat eza reflector atuin"
TEXT_EDITORS="neovim nano micro zed"
DEPS="brightnessctl jq aylurs-gtk-shell-git reflector xdg-user-dirs gvfs gvfs-afc gvfs-gphoto2 gvfs-mtp gvfs-smb hyprpaper hyprpicker slurp stow wl-clipboard tlp atuin"
FILE_MANAGER="file-roller thunar ranger superfile"
FONTS="font-manager otf-space-grotesk ttf-roboto-mono-nerd ttf-space-mono-nerd noto-fonts-emoji ttf-fira-sans ttf-nerd-fonts-symbols ttf-ubuntu-font-family ttf-monoid-nerd ttf-cascadia-code-nerd ttf-firacode-nerd ttf-fira-code ttf-fira-mono"
TERMINAL_EMULATORS="ghostty alacritty tmux"
BROWSERS="google-chrome"
GUI_SYS_CONFIG="nwg-displays nwg-look"
NETWORK="wireless_tools wavemon iwd"
ZSH="zsh oh-my-posh"
XDG="xdg-desktop-portal-gtk xdg-desktop-portal-hyprland xdg-user-dirs xdg-utils"
BATTERY="upower tlp tlpui"
BLUETOOTH="blueman"
CAELESTIA="quickshell-git caelestia-cli ddcutil brightnessctl app2unit libcava networkmanager fish aubio libpipewire glibc qt6-declarative gcc-libs ttf-cascadia-code-nerd ttf-material-symbols-variable-git swappy libqalculate bash qt6-base cmake ninja" # lm-sensors material-symbols
DEV="asdf-vm"
EXTRA="btrbk btrfs-progs edk2-shell efibootmgr grim hyprland intel-media-driver \
intel-ucode less libva-intel-driver luarocks ly mandoc network-manager-applet networkmanager \
polkit-kde-agent qt5-wayland qt6-wayland smartmontools sof-firmware \
thunar-archive-plugin vim vulkan-intel wget \
wofi xorg-server xorg-xinit zram-generator"

ALL_PACKAGES="$SYS_MON $AUDIO $TUI_UTILS $CLI_UTILS $TEXT_EDITORS $DEPS $FILE_MANAGER $FONTS $TERMINAL_EMULATORS $BROWSERS $GUI_SYS_CONFIG $NETWORK $ZSH $XDG $EXTRA $BATTERY $BLUETOOTH $CAELESTIA $DEV"
ALL=$(echo "$ALL_PACKAGES" | tr ' ' '\n' | sort | uniq | tr '\n' ' ')

# Create an associative array to map category names to variable names
declare -A CATEGORY_MAP
CATEGORY_MAP["All"]="ALL"
CATEGORY_MAP["System Monitors"]="SYS_MON"
CATEGORY_MAP["Audio"]="AUDIO"
CATEGORY_MAP["Battery"]="BATTERY"
CATEGORY_MAP["Bluetooth"]="BLUETOOTH"
CATEGORY_MAP["TUI Utils"]="TUI_UTILS"
CATEGORY_MAP["CLI Utils"]="CLI_UTILS"
CATEGORY_MAP["Text Editors"]="TEXT_EDITORS"
CATEGORY_MAP["Dependencies"]="DEPS"
CATEGORY_MAP["File Managers"]="FILE_MANAGER"
CATEGORY_MAP["Fonts"]="FONTS"
CATEGORY_MAP["Terminal Emulators"]="TERMINAL_EMULATORS"
CATEGORY_MAP["Browsers"]="BROWSERS"
CATEGORY_MAP["GUI System Config"]="GUI_SYS_CONFIG"
CATEGORY_MAP["Caelestia"]="CAELESTIA"
CATEGORY_MAP["Network"]="NETWORK"
CATEGORY_MAP["Development"]="DEV"
CATEGORY_MAP["ZSH"]="ZSH"
CATEGORY_MAP["XDG"]="XDG"

CATEGORIES=$(printf "%s\n" "${!CATEGORY_MAP[@]}" | sort)

SELECTED_CATEGORIES=$(echo "$CATEGORIES" | gum choose --no-limit --header "Select package categories to install (check other pages):")

for category in $SELECTED_CATEGORIES; do
    var_name=${CATEGORY_MAP["$category"]}

    packages=${!var_name}

    echo "Installing $category packages..."
    paru -Syu --needed --noconfirm $packages
done
