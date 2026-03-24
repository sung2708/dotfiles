# -------------------------------

# Powerlevel10k Instant Prompt

# -------------------------------

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -------------------------------

# Basic Environment

# -------------------------------

export EDITOR="nvim"
export ZSH="$HOME/.oh-my-zsh"

# PATH

export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/snap/bin"
# -------------------------------

# Oh My Zsh

# -------------------------------

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
git
zsh-autosuggestions
zsh-syntax-highlighting
zsh-fzf-history-search
)

source $ZSH/oh-my-zsh.sh

# -------------------------------

# Powerlevel10k

# -------------------------------

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# -------------------------------

# NVM (Node Version Manager)

# -------------------------------

export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

# -------------------------------

# Direnv

# -------------------------------

eval "$(direnv hook zsh)"

# -------------------------------

# Zoxide (better cd)

# -------------------------------

eval "$(zoxide init zsh --cmd cd)"

# -------------------------------

# FZF

# -------------------------------

eval "$(fzf --zsh)"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Preview

export FZF_DEFAULT_OPTS="
--color=fg:#D9E0EE,bg:-1,hl:#F5A97F
--color=fg+:#F5D0C5,bg+:-1,hl+:#F5A97F
--color=info:#A6D189,prompt:#F28FAD,pointer:#89B4FA
--color=marker:#F2D9B5,spinner:#A6ADC8,header:#D9E0EE
"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# -------------------------------

# Bat

# -------------------------------

export BAT_THEME="Catppuccin Mocha"

# -------------------------------

# TheFuck

# -------------------------------

eval "$(thefuck --alias)"

# -------------------------------

# Yazi file manager

# -------------------------------

function y() {
local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
yazi "$@" --cwd-file="$tmp"
IFS= read -r -d '' cwd < "$tmp"
[[ -n "$cwd" && "$cwd" != "$PWD" ]] && cd "$cwd"
rm -f "$tmp"
}

# -------------------------------

# Bun

# -------------------------------

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# -------------------------------

# UV (Python toolchain)

# -------------------------------

eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

# -------------------------------

# Aliases

# -------------------------------

alias cls='clear'
alias s='source ~/.zshrc'
alias zsh='nvim ~/.zshrc'
alias e='exit'

alias ls='eza --icons=always --group-directories-first'
alias ll='eza -lh --icons=always --git --group-directories-first'
alias la='ll -a'
alias lt='eza --tree --level=2 --icons=always'

alias nv='nvim ~/.config/nvim/init.vim'
alias nw='nvim ~/.config/wezterm/wezterm.lua'
alias nt='nvim ~/.tmux.conf'

alias f='fuck'
alias y='yazi'
alias lzg='lazygit'
alias lzd='lazydocker'

#Golang
# Golang
if command -v go &> /dev/null; then
    export GOPATH=$(go env GOPATH)
    export PATH=$PATH:$GOPATH/bin
fi
