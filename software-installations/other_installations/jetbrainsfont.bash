#!/usr/bin/env bash
set -e
#sudo dnf copr enable maveonair/jetbrains-mono-nerd-fonts
#sudo dnf install jetbrains-mono-nerd-fonts jetbrains-mononl-nerd-fonts
#fc-cache -fv
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
unzip JetBrainsMono.zip -d JetBrainsMono
mkdir -p ~/.local/share/fonts
cp JetBrainsMono/*.ttf ~/.local/share/fonts/
fc-cache -fv
rm -r JetBrainsMono && rm JetBrainsMono.zip
