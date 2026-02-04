#!/usr/bin/env bash

export NVIDIA_CONTAINER_TOOLKIT_VERSION=1.17.8-1

to_install=(
  dnf-plugins-core dnf-utils
  neovim
  stow
  akmod-nvidia akmods kernel-devel kernel-headers # nvidia schenanigans
  starship zsh wezterm kitty tmux                 # terminal stuff
  python3-pip
  pnpm yarnpkg                                                  # javascript
  podman podman-compose podman-docker                           # docker stuff
  latexmk texlive texlive-scheme-full zathura zathura-pdf-mupdf # latex stuff
  pipewire pipewire-pulseaudio pipewire-alsa wireplumber        #audio
  #nvidia-container-toolkit-${NVIDIA_CONTAINER_TOOLKIT_VERSION}
  #nvidia-container-toolkit-base-${NVIDIA_CONTAINER_TOOLKIT_VERSION}
  #libnvidia-container-tools-${NVIDIA_CONTAINER_TOOLKIT_VERSION}
  #libnvidia-container1-${NVIDIA_CONTAINER_TOOLKIT_VERSION}
  thunderbird # email
  google-chrome-stable
  coolercontrol
  lazygit # CLI tools
  google-cloud-cli
  glow # markdown renderer
  gh   # github
  gzip
  yq # yaml parser for cli
  fd-find
  lshw
  xclip
)

repo_to_activate=(
  wezfurlong/wezterm-nightly
  atim/starship
  codifryed/CoolerControl
  dejan/lazygit
)
# Enable COPR repos if not already enabled
for repo in "${repo_to_activate[@]}"; do
  repoId=$(sed 's/\//:/g' <<<"$repo")
  if ! sudo dnf repolist | grep -q "${repoId}"; then
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
if [[ ! -f /etc/yum.repos.d/google-cloud-sdk.repo ]]; then
  echo "➕ Adding google cloud container repo ..."
  sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo <<EOM
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el8-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM
else
  echo "✔ google-cloud-cli repo already exists"
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

sudo dnf update -y
