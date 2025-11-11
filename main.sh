#!/bin/bash
# Check if running as root
ensure_gum() {
    if ! command -v gum > /dev/null 2>&1; then
        echo -n "The command gum was not found, do you wish to install it (Y/n)"
	read -r answer
	answer=${answer:-Y}

	case "$answer" in
            Y|y)
                sudo pacman -S --noconfirm gum
		;;
            N|n)
	        echo "gum is required. Exiting."
		exit 1
		;;
	    *)
	        echo "Invalid option. Exiting"
		exit 1
	        ;;
	esac
    fi
}

clear
ensure_gum

if [[ $EUID -eq 0 ]]; then
    echo "You are running this script as root."
    if ! gum confirm "Running as root may cause issues. Are you sure you to continue?"; then
        echo "Exiting..."
        exit 1
    fi
fi

actions=(
    "Install paru:./modules/install_paru.sh"
    "Install packages:./modules/install_packages.sh"
    "Symlink configs (stow):./modules/stow_configs.sh"
    "Enable services:./modules/systemctl_enable.sh"
)

action_names=()
for action_pair in "${actions[@]}"; do
    action_names+=("${action_pair%%:*}")
done

selected=$(gum choose "${action_names[@]}")

for action_pair in "${actions[@]}"; do
    name="${action_pair%%:*}"
    script="${action_pair#*:}"

    if [[ "$selected" == "$name" ]]; then
        echo "Executing: $name..."
        cd "$(dirname "$0")" || exit 1
        $script
        break
    fi
done
