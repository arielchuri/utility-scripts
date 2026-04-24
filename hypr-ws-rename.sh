#!/bin/bash
read -p "Rename workspace (number name, or just name for current): " input
parts=($input)
if [[ ${#parts[@]} -ge 2 ]]; then
    hyprctl dispatch renameworkspace "${parts[0]}" "${parts[@]:1}"
else
    current=$(hyprctl activeworkspace -j | jq .id)
    hyprctl dispatch renameworkspace "$current" "${parts[0]}"
fi
