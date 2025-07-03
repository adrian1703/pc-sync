#!/usr/bin/env bash

to_install=(
  neovim
  google-chrome-stable
  xclip
  akmod-nvidia akmods kernel-devel kernel-headers # nvidia schenanigans
  stow
  zsh
  wezterm
)

repo_to_activate=(
  wezfurlong/wezterm-nightly
)
# Enable COPR repos if not already enabled
for repo in "${repo_to_activate[@]}"; do
  if ! sudo dnf repolist enabled | grep -q "^${repo}"; then
    echo "➕ Enabling COPR repo: $repo"
    sudo dnf copr enable -y "$repo"
  else
    echo "✔ COPR repo $repo already enabled"
  fi
done

# Install packages
for pkg in "${to_install[@]}"; do
  if rpm -q "$pkg" &>/dev/null; then
    echo "✔ $pkg is already installed"
  else
    echo "➕ Installing $pkg ..."
    sudo dnf install -y "$pkg"
  fi
done
