#!/usr/bin/env bash
pnpm store prune
pnpm config set store-dir ~/.pnpm-store
pnpm config set global-bin-dir ~/.local/bin
# this is only for shell aka .zshrc
# export PATH="$HOME/.local/bin:$PATH"
