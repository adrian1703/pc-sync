#!/usr/bin/env bash

set -euo pipefail

pnpm store prune
pnpm config set global-bin-dir "$PNPM_HOME"
# this is only for shell aka .zshrc
# export PATH="$HOME/.local/bin:$PATH"
