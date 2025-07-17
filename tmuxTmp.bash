#!/usr/bin/env bash

DEST="$HOME/.config/.tmux/plugins/"
rm -r "$DEST/tmp" &>/dev/null
mkdir -p "$DEST"
git clone https://github.com/tmux-plugins/tpm "$DEST"
