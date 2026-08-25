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
bindkey '^R' history-incremental-search-backward

# The following lines were added by compinstall
zstyle :compinstall filename '/home/adrian/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Auto suggestion
bindkey '^w' autosuggest-execute
bindkey '^e' autosuggest-accept
bindkey '^u' autosuggest-toggle
bindkey '^L' vi-forward-word
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search

# Programs
alias tm='tmux'
alias tf='terraform'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias reload='source ~/.zshrc'
alias n='nvim'
alias vim='nvim'
alias toolbox='~/jetbrains/toolbox/bin/jetbrains-toolbox'
alias ts3='/opt/TeamSpeak3-Client-linux_amd64/ts3client_runscript.sh'
alias g='./gradlew'
alias gclb='./gradlew clean build'
alias obs='flatpak run md.obsidian.Obsidian'
alias lg='lazygit'

ask() {
  local continue_flag=""
  if [[ "$1" == "-c" ]]; then
    continue_flag="-c"
    shift
  fi
  llm -m d $continue_flag "$@" | glow
}


alias pdflocal='docker run -p 8080:8080 docker.stirlingpdf.com/stirlingtools/stirling-pdf'

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
alias dco="docker compose"
alias doc="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# alias dco="podman compose"
# alias dps="podman ps"
# alias dpa="podman ps -a"
# alias dl="podman ps -l -q"
# alias dx="podman exec -it"

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
alias ghist="git log --graph --decorate --all --pretty=format:'%C(auto)%h%d %C(#888888)(%an; %ar)%Creset %s'"
alias graph="git log --graph --decorate --all --pretty=format:'%C(auto)%h%d %C(#888888)(%an; %ar)%Creset %s'"
alias gls="git for-each-ref \
  --format='%(refname:short)	%(upstream:short)	%(upstream:track)	%(upstream:remotename)' \
  refs/heads | column -t -s $'\t'"

# ENV

export LANG=en_US.UTF-8
# podman - docker socket 
# Created by `pipx` on 2025-07-19 10:43:40
export PATH="$PATH:$HOME/.local/bin"

if [[ "$OSTYPE" == "darwin"* ]]; then
  export JAVA_HOME="$HOME/.jdks/openjdk-26.0.2"
  export PATH="$PATH:$HOME/Library/Python/3.14/bin"
else
  alias docker='podman'
  alias d='podman'
  export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock
  export JAVA_HOME="$HOME/.jdks/openjdk-24.0.1"
fi

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PATH:$PNPM_HOME/bin/"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


# load autosuggest 
if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
else
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
# Load Angular CLI autocompletion.
# source <(ng completion script)
# starship
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.starship.toml


