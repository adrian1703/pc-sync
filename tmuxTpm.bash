#!/usr/bin/env bash

DEST="$HOME/.config/tmux/plugins/tpm"
rm -r "$DEST"
mkdir -p "$DEST"
git clone https://github.com/tmux-plugins/tpm "$DEST"
