#!/usr/bin/env bash

to_install=(
	nvim
	google-chrome
	xclip
	akmod-nvidia akmods kernel-devel kernel-headers # nvidia schenanigans
	)
for pkg in "${to_install[@]}"; do
	echo "Installing $pkg ..."
	dnf install -y "$pkg" 
done
