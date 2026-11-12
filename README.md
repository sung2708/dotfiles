# 🛠️ dotfiles

![macOS](https://img.shields.io/badge/macOS-000000?logo=apple&logoColor=white) ![Linux](https://img.shields.io/badge/Linux-FCC624?logo=linux&logoColor=black) ![WezTerm](https://img.shields.io/badge/WezTerm-4E49EE?logo=wezterm&logoColor=white) ![tmux](https://img.shields.io/badge/tmux-1BB91F?logo=tmux&logoColor=white) ![zsh](https://img.shields.io/badge/zsh-F15A24?logo=zsh&logoColor=white) ![Neovim](https://img.shields.io/badge/Neovim-57A143?logo=neovim&logoColor=white) ![Catppuccin](https://img.shields.io/badge/theme-Catppuccin%20Mocha-cba6f7)

My terminal setup: **WezTerm → tmux → zsh → Neovim**, with fzf, bat, eza,
delta and yazi wired together. bat, eza, fzf, delta and WezTerm share the
Catppuccin Mocha palette; the tmux status bar uses Tokyo Night (storm).

- [📦 What is in here](#-what-is-in-here)
- [📋 Requirements](#-requirements)
- [🍎 Install on macOS](#-install-on-macos)
- [🐧 Install on Linux](#-install-on-linux)
- [🐚 Shell, Oh My Zsh and plugins](#-shell-oh-my-zsh-and-plugins)
- [🔗 Link the configs](#-link-the-configs)
- [✅ After linking](#-after-linking)
- [🔍 Check what is installed](#-check-what-is-installed)
- [🚀 Usage](#-usage)
- [🔄 Keep updated](#-keep-updated)

## 📦 What is in here

| Folder       | What it configures                               | Link target           |
| ------------ | ------------------------------------------------ | --------------------- |
| 🖥️ `wezterm/`   | Main terminal; opens/attaches tmux session `sungp` | `~/.config/wezterm` |
| 👻 `ghostty/`   | Alternative terminal, same look/keys as WezTerm | `~/.config/ghostty`   |
| 🪟 `tmux/`      | `.tmux.conf` — prefix `C-a`, TPM plugins         | `~`                   |
| 🐚 `zsh/`       | `.zshrc` — Oh My Zsh, Powerlevel10k, fzf, aliases | `~`                  |
| 📝 `nvim/`      | Neovim config ([its own README](nvim/README.md)) | `~/.config/nvim`      |
| 🌿 `gitconfig/` | `.gitconfig` — delta, nvimdiff, gh login, LFS    | `~`                   |
| 🦇 `bat/`       | Catppuccin Mocha theme (used by bat **and** delta) | `~/.config/bat`     |
| 📂 `eza/`       | eza colour theme                                 | `~/.config/eza`       |
| ⚡ `fastfetch/` | fastfetch layout                                 | `~/.config/fastfetch` |

## 📋 Requirements

✅ **Required** — the configs call these directly and break without them:

| Tool | Used by |
| ---- | ------- |
| zsh, [Oh My Zsh](https://ohmyz.sh) | shell |
| tmux ≥ 3.3 | WezTerm starts it; `allow-passthrough`, `extended-keys` |
| neovim ≥ 0.12 | editor, `git mergetool` ([details](nvim/README.md#requirements)) |
| git ≥ 2.35 | `merge.conflictstyle = zdiff3` |
| GNU stow | linking the configs |
| fzf ≥ 0.48 | `fzf --zsh` key bindings |
| fd, ripgrep | fzf file lists, Neovim pickers / live grep |
| bat | fzf preview, delta syntax theme |
| eza | `ls` / `ll` / `lt`, fzf directory preview |
| zoxide | replaces `cd` |
| git-delta | git pager |
| gh | git HTTPS login (`gh auth git-credential`) |
| A [Nerd Font](https://www.nerdfonts.com) | icons (WezTerm already bundles the symbols) |

🔌 **Zsh plugins**: [Powerlevel10k](https://github.com/romkatv/powerlevel10k),
[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions),
[zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting).
Ctrl-R history search comes from `fzf --zsh`, no extra plugin.

🔌 **tmux plugins** (installed by [TPM](https://github.com/tmux-plugins/tpm)
automatically): tmux-sensible, tokyo-night-tmux.

➕ **Optional**: WezTerm or Ghostty, yazi, git-lfs, fastfetch, thefuck, lazygit,
lazydocker. Each one only backs an alias or command of its own.

## 🍎 Install on macOS

Pick **one** package manager — Homebrew or MacPorts — and install everything
with it, so each tool exists only once on `PATH`.

### 🍺 Homebrew

```bash
brew install --cask wezterm                      # terminal (or: --cask ghostty)
brew install zsh tmux neovim git stow gh
brew install fzf fd ripgrep bat eza zoxide git-delta
brew install yazi git-lfs fastfetch thefuck lazygit lazydocker   # optional
```

WezTerm and Ghostty look for tmux on `PATH` and in the usual MacPorts and
Homebrew locations. If tmux cannot start, they open zsh.

### ⚓ MacPorts

```bash
sudo port selfupdate
sudo port install zsh tmux neovim git stow gh
sudo port install fzf fd ripgrep bat eza zoxide git-delta
sudo port install yazi git-lfs fastfetch thefuck lazygit lazydocker   # optional
```

WezTerm is not a port: install it with `brew install --cask wezterm` or the
app from [wezterm.org](https://wezterm.org). `.zshrc` already puts
`/opt/local/bin` first on `PATH`. If a port is not found, install just that
tool with Homebrew.

## 🐧 Install on Linux

Two ways: **Homebrew on Linux** (same versions as macOS, no sudo after setup,
recommended when the distro packages are old) or the **distro packages**.

### 🍺 Homebrew on Linux

```bash
sudo apt install -y build-essential curl git zsh   # or dnf/pacman equivalents
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# brew is not on PATH yet; load it in every login shell
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

brew install tmux neovim stow gh
brew install fzf fd ripgrep bat eza zoxide git-delta
brew install yazi git-lfs fastfetch thefuck lazygit lazydocker   # optional
```

Keep `zsh` from the distro (it must be listed in `/etc/shells` for `chsh`).
`~/.zprofile` is not part of these dotfiles, so the line above stays
machine-specific. Install WezTerm or Ghostty from their websites or the
distro.

### 🟠 Ubuntu / Debian packages

```bash
sudo apt update
sudo apt install -y zsh tmux git stow curl unzip build-essential \
  fzf fd-find ripgrep bat eza zoxide git-delta gh git-lfs

# Debian/Ubuntu rename two binaries; give them their usual names
mkdir -p ~/.local/bin
ln -sf "$(command -v fdfind)" ~/.local/bin/fd
ln -sf "$(command -v batcat)" ~/.local/bin/bat
```

Older releases ship an fzf, eza or delta that is too old or missing, and the
packaged Neovim is too old for this config. Get those from Homebrew on Linux
(above) or the Neovim installer in [nvim/README.md](nvim/README.md#install).

### 🔵 Fedora packages

```bash
sudo dnf install -y zsh tmux git stow fzf fd-find ripgrep bat eza zoxide \
  git-delta gh git-lfs neovim fastfetch
```

### 🔷 Arch packages

```bash
sudo pacman -S --needed zsh tmux git stow fzf fd ripgrep bat eza zoxide \
  git-delta github-cli git-lfs neovim yazi fastfetch lazygit
```

### 📝 Linux notes

- tmux copy mode pipes to `pbcopy` (macOS). On Linux the copy still reaches
  the system clipboard through OSC 52 (`set-clipboard on`); or change
  `pbcopy` in `.tmux.conf` to `wl-copy` / `xclip -selection clipboard`.
- `.zshrc` sets `PNPM_HOME` to a macOS path; harmless elsewhere, edit it if
  you use pnpm on Linux.

## 🐚 Shell, Oh My Zsh and plugins

```bash
chsh -s "$(command -v zsh)"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
git clone --depth=1 https://github.com/romkatv/powerlevel10k "$ZSH_CUSTOM/themes/powerlevel10k"
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
```

## 🔗 Link the configs

The Oh My Zsh installer writes its own `~/.zshrc`. Move it and any other
existing file out of the way first, or stow will refuse to overwrite it:

```bash
backup_dir=$(mktemp -d "$HOME/.dotfiles-backup.XXXXXX") && (
  for f in ~/.zshrc ~/.tmux.conf ~/.gitconfig; do
    if [ -e "$f" ] && [ ! -L "$f" ]; then
      mv "$f" "$backup_dir/" || exit 1
    fi
  done
  printf 'Backup directory: %s\n' "$backup_dir"
)
```

```bash
git clone git@github.com:sung2708/dotfiles.git ~/dotfiles
cd ~/dotfiles

mkdir -p ~/.config/{wezterm,ghostty,nvim,bat,eza,fastfetch}

stow -t ~                      zsh tmux gitconfig
stow -t ~/.config/wezterm      wezterm
stow -t ~/.config/ghostty      ghostty
stow -t ~/.config/nvim         nvim
stow -t ~/.config/bat          bat
stow -t ~/.config/eza          eza
stow -t ~/.config/fastfetch    fastfetch
```

## ✅ After linking

```bash
bat cache --build      # register Catppuccin Mocha (bat + delta need it)
gh auth login          # git over HTTPS logs in through gh
git lfs install        # only if you installed git-lfs
exec zsh               # reload; Powerlevel10k runs its wizard the first time
```

- **tmux**: TPM clones itself on first start. If the plugins are missing,
  press `C-a I` inside tmux.
- **Neovim**: if you linked it with Stow, install the tools listed under
  [Neovim requirements](nvim/README.md#requirements), run
  `sh ~/.config/nvim/bin/check-environment.sh`, then open `nvim` to install
  plugins. The one-command installer in the Neovim README is a separate
  install method that can replace the Stow setup with a standalone checkout.
- **eza**: if `ls` is not in Catppuccin colours, add
  `export EZA_CONFIG_DIR="$HOME/.config/eza"` to your shell.
- **git**: `user.name` / `user.email` in `gitconfig/.gitconfig` are mine —
  change them on someone else's machine.

## 🔍 Check what is installed

```bash
for c in tmux zsh nvim git stow fzf fd rg bat eza zoxide delta gh \
         yazi git-lfs fastfetch thefuck lazygit lazydocker; do
  command -v "$c" >/dev/null && echo "ok      $c" || echo "MISSING $c"
done
Z=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
for d in "$Z/themes/powerlevel10k" "$Z/plugins/zsh-autosuggestions" \
         "$Z/plugins/zsh-syntax-highlighting" "$HOME/.tmux/plugins/tpm"; do
  [ -d "$d" ] && echo "ok      ${d##*/}" || echo "MISSING ${d##*/}"
done
bat --list-themes | grep -q 'Catppuccin Mocha' && echo "ok      bat theme" || echo "MISSING bat theme (bat cache --build)"
```

WezTerm and Ghostty are apps: on macOS check `/Applications` rather than
`PATH`.

## 🚀 Usage

### 🔎 fzf (in the shell)

| Keys | What it does |
| ---- | ------------ |
| `Ctrl-T` | Pick files (from `fd`, hidden included, `.git` excluded) with a **bat** preview; folders preview as an `eza` tree. Works mid-command: `nvim ` then `Ctrl-T`. |
| `Ctrl-R` | Fuzzy search shell history |
| `Alt-C` | Pick a folder and `cd` into it (eza tree preview) |
| `nvim **<Tab>` | fzf completion (no preview — prefer `Ctrl-T`) |

### 🪟 tmux (prefix `C-a`)

| Keys | What it does |
| ---- | ------------ |
| `Alt-h/j/k/l` | Move between panes; inside Neovim the keys go to Neovim |
| `C-a \` / `C-a -` | Split right / down (same folder) |
| `C-a c` | New window (same folder) |
| `C-a h/j/k/l` | Resize pane (repeatable) |
| `C-a m` | Zoom pane |
| `C-a [` then `v` … `y` | Copy mode: select and copy to the clipboard |
| `C-a r` | Reload `.tmux.conf` |
| `C-a I` | Install TPM plugins |

WezTerm opens straight into the tmux session `sungp` (created on first run,
re-attached afterwards). Closing the window keeps the session alive.

### 🌿 git + delta

- `git diff`, `git log -p`, `git show` open in delta: side-by-side, line
  numbers, Catppuccin syntax colours. `n` / `N` jump between files.
- `git add -p` shows delta colours inline.
- `git mergetool` / `git difftool` open `nvimdiff`; conflicts use `zdiff3`.

### ⚡ Shell aliases and functions

| Command | Does |
| ------- | ---- |
| `ls`, `ll`, `la`, `lt` | eza: list, long + git status, + hidden, tree (2 levels) |
| `cd foo` | zoxide: jump to the best match for `foo` |
| `y` | yazi file manager; quitting `cd`s into the folder you were in |
| `vi`, `vim` | nvim |
| `ez`, `nt`, `nw` / `ew`, `nv` | edit `.zshrc`, `.tmux.conf`, `wezterm.lua`, the Neovim config |
| `s` | reload zsh (`exec zsh`) |
| `f` / `fuck` | thefuck: fix the last command |
| `lzg`, `lzd` | lazygit, lazydocker |
| `cpp file.cpp` | build with sanitizers and run; `cppb` builds `-O2` |
| `gor`, `gob`, `got` | `go run .`, `go build`, `go test ./...` |

## 🔄 Keep updated

```bash
cd ~/dotfiles && git pull
bat cache --build      # only if the bat theme changed
```

Changes to already-linked files apply immediately. For a new folder, run its
`stow` line again.
