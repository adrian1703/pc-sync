#!/usr/bin/env bash

export NVIDIA_CONTAINER_TOOLKIT_VERSION=1.17.8-1

to_install=(
  neovim
  google-chrome-stable
  xclip
  akmod-nvidia akmods kernel-devel kernel-headers # nvidia schenanigans
  stow
  zsh
  wezterm
  kitty
  fd
  tmux
  lshw
  python3-pip
  podman
  podman-compose
  nvidia-container-toolkit-${NVIDIA_CONTAINER_TOOLKIT_VERSION}
  nvidia-container-toolkit-base-${NVIDIA_CONTAINER_TOOLKIT_VERSION}
  libnvidia-container-tools-${NVIDIA_CONTAINER_TOOLKIT_VERSION}
  libnvidia-container1-${NVIDIA_CONTAINER_TOOLKIT_VERSION}
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

# Add NVIDIA container repo if not already present
if [[ ! -f /etc/yum.repos.d/nvidia-container-toolkit.repo ]]; then
  echo "➕ Adding NVIDIA container repo ..."
  curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo |
    sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo >/dev/null
else
  echo "✔ NVIDIA container repo already exists"
fi

# Install packages
for pkg in "${to_install[@]}"; do
  if rpm -q "$pkg" &>/dev/null; then
    echo "✔ $pkg is already installed"
  else
    echo "➕ Installing $pkg ..."
    sudo dnf install -y "$pkg"
  fi
done
