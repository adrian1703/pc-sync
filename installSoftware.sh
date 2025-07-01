#!/usr/bin/env bash

to_install=(
	neovim
	google-chrome-stable	
	xclip
	akmod-nvidia akmods kernel-devel kernel-headers # nvidia schenanigans
	stow
)
for pkg in "${to_install[@]}"; do
	if rpm -q "$pkg" &> /dev/null; then
		echo "✔ $pkg is already installed"
	else		
		echo "Installing $pkg ..."
		sudo dnf install -y "$pkg" 
	fi
done
