#!/bin/bash
actions=(
    "Install paru:./scripts/install_paru.sh"
    "Install all my most used packages:./scripts/install_all_packages.sh"
    "Install selected packages:./scripts/install_selected_packages.sh"
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
