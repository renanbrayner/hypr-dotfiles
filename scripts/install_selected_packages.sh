#!/bin/bash
cd "$(dirname "$0")" || exit 1
./check_paru.sh


SYS_MON="btop htop wavemon"
AUDIO="gst-plugin-pipewire helvum pavucontrol pipewire pipewire-alsa pipewire-jack pipewire-pulse libpulse wireplumber"
TUI_UTILS="lazygit lazydocker ranger zellij"
CLI_UTILS="jq neofetch mise bat eza reflector"
TEXT_EDITORS="neovim nano micro zed"
DEPS="brightnessctl jq aylurs-gtk-shell-git reflector xdg-user-dirs gvfs gvfs-afc gvfs-gphoto2 gvfs-mtp gvfs-smb hyprpaper hyprpicker slurp stow wl-clipboard"
FILE_MANAGER="file-roller thunar ranger"
FONTS="font-manager otf-space-grotesk ttf-roboto-mono-nerd ttf-space-mono-nerd noto-fonts-emoji ttf-fira-sans ttf-nerd-fonts-symbols ttf-ubuntu-font-family ttf-monoid-nerd ttf-cascadia-code-nerd ttf-firacode-nerd ttf-fira-code ttf-fira-mono"
TERMINAL_EMULATORS="ghostty alacritty zellij"
BROWSERS="google-chrome"
GUI_SYS_CONFIG="nwg-displays nwg-look"
NETWORK="wireless_tools wavemon iwd"
ZSH="zsh oh-my-posh"
XDG="xdg-desktop-portal-gtk xdg-desktop-portal-hyprland xdg-user-dirs xdg-utils"


# Create menu with all package categories
SELECTED_CATEGORIES=$(gum choose --no-limit --header "Select package categories to install:" \
    "System Monitors" \
    "Audio" \
    "TUI Utils" \
    "CLI Utils" \
    "Text Editors" \
    "Dependencies" \
    "File Managers" \
    "Fonts" \
    "Terminal Emulators" \
    "Browsers" \
    "GUI System Config" \
    "Network" \
    "ZSH" \
    "XDG")

# Install selected package categories
for category in $SELECTED_CATEGORIES; do
    case $category in
        "System Monitors")
            paru -Syu --needed --noconfirm $SYS_MON
            ;;
        "Audio")
            paru -Syu --needed --noconfirm $AUDIO
            ;;
        "TUI Utils")
            paru -Syu --needed --noconfirm $TUI_UTILS
            ;;
        "CLI Utils")
            paru -Syu --needed --noconfirm $CLI_UTILS
            ;;
        "Text Editors")
            paru -Syu --needed --noconfirm $TEXT_EDITORS
            ;;
        "Dependencies")
            paru -Syu --needed --noconfirm $DEPS
            ;;
        "File Managers")
            paru -Syu --needed --noconfirm $FILE_MANAGER
            ;;
        "Fonts")
            paru -Syu --needed --noconfirm $FONTS
            ;;
        "Terminal Emulators")
            paru -Syu --needed --noconfirm $TERMINAL_EMULATORS
            ;;
        "Browsers")
            paru -Syu --needed --noconfirm $BROWSERS
            ;;
        "GUI System Config")
            paru -Syu --needed --noconfirm $GUI_SYS_CONFIG
            ;;
        "Network")
            paru -Syu --needed --noconfirm $NETWORK
            ;;
        "ZSH")
            paru -Syu --needed --noconfirm $ZSH
            ;;
        "XDG")
            paru -Syu --needed --noconfirm $XDG
            ;;
    esac
done
