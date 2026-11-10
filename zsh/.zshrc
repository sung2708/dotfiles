# ─────────────────────────────────────────────────────────────────────────────
# Powerlevel10k instant prompt — keep at the very top. Nothing above this line
# may print to the terminal.
# ─────────────────────────────────────────────────────────────────────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ─────────────────────────────────────────────────────────────────────────────
# Environment and PATH (set once, before any tool is initialised)
# ─────────────────────────────────────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"

# Go: the default GOPATH is ~/go. Hard-coding it avoids starting `go` on every
# shell. If you changed it with `go env -w GOPATH=...`, put that path here.
export GOPATH="${GOPATH:-$HOME/go}"
export BUN_INSTALL="$HOME/.bun"

typeset -U path PATH # never add the same directory twice
path=(
  $HOME/.local/bin
  $HOME/.antigravity-ide/antigravity-ide/bin
  /opt/local/bin /opt/local/sbin # MacPorts: tmux, nvim, fzf, ...
  $BUN_INSTALL/bin
  $path
  $GOPATH/bin
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
)
export PATH

# ─────────────────────────────────────────────────────────────────────────────
# History
# ─────────────────────────────────────────────────────────────────────────────
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_all_dups hist_ignore_space hist_reduce_blanks share_history

# ─────────────────────────────────────────────────────────────────────────────
# Oh My Zsh + Powerlevel10k
# ─────────────────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
zstyle ':omz:update' mode reminder # ask in the prompt instead of blocking startup
zstyle ':omz:update' frequency 14

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20 # skip suggestions for long pasted commands

# zsh-fzf-history-search was removed: `fzf --zsh` below already binds Ctrl-R
# to fuzzy history search, and both plugins fought over the same key.
# zsh-syntax-highlighting is loaded at the end of this file instead, after
# every other widget (fzf, zoxide) exists, as its README requires.
plugins=(
  git
  zsh-autosuggestions
)

source "$ZSH/oh-my-zsh.sh"
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ─────────────────────────────────────────────────────────────────────────────
# Tools
# ─────────────────────────────────────────────────────────────────────────────
# Zoxide replaces cd (cd foo jumps to the best "foo" you have visited).
eval "$(zoxide init zsh --cmd cd)"

# FZF: Ctrl-R history, Ctrl-T files, Alt-C directories.
eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Catppuccin Mocha (same palette as WezTerm, Neovim and bat). No `bg` so the
# translucent terminal background shows through.
export FZF_DEFAULT_OPTS=" \
  --height=60% --layout=reverse --border=rounded \
  --color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --color=border:#6c7086,label:#cdd6f4"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

export BAT_THEME="Catppuccin Mocha"

# TheFuck starts Python (~100–600 ms) just to define an alias. Load it the
# first time you actually type `fuck` (or `f`).
fuck() {
  unfunction fuck
  eval "$(thefuck --alias)"
  fuck "$@"
}

# Yazi: `y` opens yazi and cd's into the folder you were in when you quit.
y() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [[ -n "$cwd" && "$cwd" != "$PWD" ]] && cd "$cwd"
  rm -f -- "$tmp"
}

# Bun completions
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

# Optional (uncomment when needed):
# export NVM_DIR="$HOME/.nvm"; [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
# eval "$(direnv hook zsh)"
# eval "$(uv generate-shell-completion zsh)"

# ─────────────────────────────────────────────────────────────────────────────
# Aliases
# ─────────────────────────────────────────────────────────────────────────────
alias cls='clear'
alias s='exec zsh'                         # reload the shell cleanly
alias ez='nvim ~/.zshrc'                   # was `zsh`, which hid the zsh command
alias e='exit'

alias ls='eza --icons=always --group-directories-first'
alias ll='eza -lh --icons=always --git --group-directories-first'
alias la='ll -a'
alias lt='eza --tree --level=2 --icons=always'

alias nv='cd ~/.config/nvim && nvim'       # config is init.lua, not init.vim
alias nw='nvim ~/.config/wezterm/wezterm.lua'
alias nt='nvim ~/.tmux.conf'

alias f='fuck'
alias lzg='lazygit'
alias lzd='lazydocker'
# (alias y='yazi' removed: it overrode the y() function above)

# ─────────────────────────────────────────────────────────────────────────────
# Syntax highlighting — must be the last thing sourced.
# ─────────────────────────────────────────────────────────────────────────────
zsh_hl="${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -r "$zsh_hl" ]] && source "$zsh_hl"
unset zsh_hl

