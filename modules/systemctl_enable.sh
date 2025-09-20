#!/bin/bash
echo "Select options to enable."
opcoes=$(gum choose --no-limit "Upower" "Bluetooth")

if [ -z "$opcoes" ]; then
    echo "No option selected. Leaving..."
    exit 0
fi

for opcao in $opcoes; do
    case "$opcao" in
        "Upower")
            echo "Enabling upower..."
            sudo systemctl enable upower
            sudo systemctl start upower
            ;;
        "Bluetooth")
            echo "Enabling bluetooth..."
            sudo systemctl enable bluetooth.service
            sudo systemctl start bluetooth.service
            ;;
    esac
done
