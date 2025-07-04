#!/usr/bin/env bash

delete_flag=false

while getopts "d" opt; do
  case $opt in
  d) delete_flag=true ;;
  esac
done

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

declare -A configToDestination
configToDestination[git]="$HOME"
configToDestination[kitty]="$HOME/.config/kitty"
configToDestination[zsh]="$HOME"
configToDestination[nvim]="$HOME/.config/nvim"
configToDestination[starship]="$HOME"
configToDestination[wezterm]="$HOME/.config/wezterm"

for configPkg in "${!configToDestination[@]}"; do
  destination="${configToDestination[$configPkg]}"
  if ! $delete_flag; then
    echo "creating symlink for $configPkg at $destination"
    mkdir -p "$destination"
    stow -t "$destination" "$configPkg"
  else
    echo "deleting symlink for $configPkg at $destination"
    stow -D -t "$destination" "$configPkg"
    rmdir "$destination"
  fi
done
