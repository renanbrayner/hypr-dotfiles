#!/bin/bash
# Check if running as root
if [[ $EUID -eq 0 ]]; then
    echo "You are running this script as root."
    if ! gum confirm "Running as root may cause issues. Are you sure you to continue?"; then
        echo "Exiting..."
        exit 1
    fi
fi

actions=(
    "Install paru:./scripts/install_paru.sh"
    "Install packages:./scripts/install_packages.sh"
    "Symlink configs (stow):./scripts/stow_configs.sh"
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
