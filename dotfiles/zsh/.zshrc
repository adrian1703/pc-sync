# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd beep extendedglob nomatch notify
bindkey -v
# End of lines configured by zsh-newuser-install

# This gets the actual keycode your terminal sends for Delete and Backspace
# Press Ctrl-V then the key to check (e.g., Ctrl-V Del might show ^[[3~)

# Common bindings:
bindkey -M viins '^?' backward-delete-char    # Backspace
bindkey -M viins '^[[3~' delete-char           # Delete
bindkey -M vicmd '^?' backward-delete-char     # Backspace in normal mode
bindkey -M vicmd '^[[3~' delete-char           # Delete in normal mode

# The following lines were added by compinstall
zstyle :compinstall filename '/home/adrian/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.starship.toml

# Auto suggestion
bindkey '^w' autosuggest-execute
bindkey '^e' autosuggest-accept
bindkey '^u' autosuggest-toggle
bindkey '^L' vi-forward-word
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search

# Programs
alias reload='source ~/.zshrc'
alias n='nvim'
alias vim='nvim'
alias toolbox='~/jetbrains/toolbox/bin/jetbrains-toolbox'
alias ts3='/opt/TeamSpeak3-Client-linux_amd64/ts3client_runscript.sh'
alias work='xfreerdp /run/media/adrian/Stick/arbeit.rdp /f /smart-sizing:3440x1440 /scale-desktop:125'
alias zeit='n /run/media/adrian/Stick/zeit.txt'
alias docker='podman'

alias ollama-up='sudo podman run -d \
  --name ollama \
  -p 11434:11434 \
  --gpus all \
  -v ollama_data:/root/.ollama \
  ollama/ollama'
alias ollama-down='sudo podman rm -f ollama'
alias ollama-logs='sudo podman logs -f ollama'

# Misc 
alias cl=clear 

# Ls
alias ll='ls -lah --color=auto'
alias l='ls -lh --color=auto'
alias lt="tree -C -L 2"

# Dirs
alias cd='cd_func() { builtin cd "$@" && l; }; cd_func'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias cr="cd -"
alias ch="cd ~"

# Docker
# alias dco="docker compose"
# alias dps="docker ps"
# alias dpa="docker ps -a"
# alias dl="docker ps -l -q"
# alias dx="docker exec -it"

alias dco="podman compose"
alias dps="podman ps"
alias dpa="podman ps -a"
alias dl="podman ps -l -q"
alias dx="podman exec -it"

# Git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias gaa='git add .'
alias gam='git add . && git commit -m'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'
alias gs='git switch'

# ENV

export LANG=en_US.UTF-8


# Created by `pipx` on 2025-07-19 10:43:40
export PATH="$PATH:/home/adrian/.local/bin"
