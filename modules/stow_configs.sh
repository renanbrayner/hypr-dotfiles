#!/bin/bash
DOTFILES_DIR="$HOME/.dotfiles/stow"
TARGET_DIR="$HOME"

if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Directory $DOTFILES_DIR not found."
    exit 1
fi

cd "$DOTFILES_DIR" || exit 1
PACKAGES=$(find . -maxdepth 1 -type d -not -path "." | sed 's|^\./||' | sort)

if [ -z "$PACKAGES" ]; then
    echo "No directories found in $DOTFILES_DIR"
    exit 1
fi

SELECTED=$(echo "$PACKAGES" | gum choose --no-limit --header "Select a packages to stow:")

for PKG in $SELECTED; do
    stow -v -t "$TARGET_DIR" "$PKG"
done
