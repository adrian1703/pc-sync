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
configToDestination[zsh]="$HOME"
configToDestination[starship]="$HOME"
configToDestination[intellij]="$HOME"

declare -A configToDestinationDir
configToDestinationDir[tmux]="$HOME/.config/tmux"
configToDestinationDir[wezterm]="$HOME/.config/wezterm"
configToDestinationDir[nvim]="$HOME/.config/nvim"
configToDestinationDir[kitty]="$HOME/.config/kitty"

for configPkg in "${!configToDestination[@]}"; do
  destination="${configToDestination[$configPkg]}"
  if ! $delete_flag; then
    echo "creating symlink for $configPkg at $destination"
    mkdir -p "$destination"
    stow -t "$destination" "$configPkg"
  else
    echo "deleting symlink for $configPkg at $destination"
    stow -D -t "$destination" "$configPkg"
  fi
done

for configPkg in "${!configToDestinationDir[@]}"; do
  destination="${configToDestinationDir[$configPkg]}"
  if ! $delete_flag; then
    echo "creating symlink for $configPkg at $destination"
    mkdir -p "$destination"
    stow -t "$destination" "$configPkg"
  else
    echo "deleting symlink for $configPkg at $destination"
    stow -D -t "$destination" "$configPkg"
    rm -r "$destination"
  fi
done
