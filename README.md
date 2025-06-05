# Table of contents
- [Table of contents](#table-of-contents)
- [1. Introduction](#1-introduction)
- [2. Installation](#2-installation)
  - [Automatic Installation](#automatic-installation)
  - [Manual Installation](#manual-installation)
    - [Dependencies](#dependencies)
    - [CLI tools](#cli-tools)
    - [ZSH plugins](#zsh-plugins)
    - [Synchronize configuration from repository](#synchronize-configuration-from-repository)
    - [Note](#note)
- [Keep updated :new\_moon\_with\_face:](#keep-updated-new_moon_with_face)


# 1. Introduction

My dotfile repository is a collection of configuration files that I use to customize my system. The repository is organized in a way that makes it easy to install and manage the configuration files. The repository is also designed to be easily portable, so that I can quickly set up my configuration on a new system.

# 2. Installation

I am using zsh to is my default shell, you can install zsh first.

```bash
sudo apt install zsh
```
or

```bash
brew install zsh

```
and set zsh as your default shell.

```bash
chsh -s $(which zsh)
```
After you log out and log back in, you will be using zsh as your default shell.

## Automatic Installation
You can run this script file to install the configuration files automatically. The script will create symbolic links to the configuration files in the home directory.


```bash
sudo ./install.sh
```
If you want to install the configuration files manually, you can follow the instructions below.
## Manual Installation

To install the configuration files, clone the repository. Use [Gnu stow](https://www.gnu.org/software/stow/manual/stow.html) to create symbolic links to the configuration files. The following commands will install the configuration files in the home directory.

### Dependencies

- [neovim](https://neovim.io/) (My text editor) ```brew install neovim``` or ```snap install neovim```
- [Nerd fonts](https://www.nerdfonts.com/font-downloads) (Recommended) Download and install a Nerd Font of your choice. I use [JetBrains Mono](https://www.nerdfonts.com/font-downloads#jetbrainsmono) for my terminal and Neovim.
- [Oh my zsh](https://ohmyz.sh/) ```sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"```
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) (Recommended)
- [git](https://git-scm.com/) ```brew install git``` or ```sudo apt install git```
- [wezterm](https://wezfurlong.org/wezterm/) I use it as terminal emulator ```brew install --cask wezterm``` or ```sudo apt install wezterm```

### CLI tools

- [fzf](https://junegunn.github.io/fzf) ```brew install fzf``` or ```sudo apt install fzf```
- [fzf-git](https://github.com/junegunn/fzf-git.sh) ```git clone https://github.com/junegunn/fzf-git.sh```
- [ripgrep](https://github.com/BurntSushi/ripgrep) ```brew install ripgrep``` or ```sudo apt install ripgrep```
- [fd](https://github.com/sharkdp/fd) ```brew install fd``` or ```sudo apt install fd```
- [bat](https://github.com/sharkdp/bat) Replaces `cat` for color, pairs well with fzf ```brew install bat``` or ```sudo apt install bat```
- [eza](https://github.com/eza-community/eza) Replaces `ls` ```brew install eza``` or ```sudo apt install eza```
- [the fuck](https://github.com/nvbn/thefuck) (Optional) ```brew install thefuck``` or
```
sudo apt update
sudo apt install python3-dev python3-pip python3-setuptools
pip3 install thefuck --user
```

- [tmux](https://github.com/tmux/tmux/wiki) (Optional) ```brew install tmux``` or ```sudo apt install tmux```
- [fastfetch](https://github.com/fastfetch-cli/fastfetch) ```brew install fastfetch``` or ```apt install fastfetch```

### ZSH plugins
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zsh-fzf-history-search](https://github.com/joshskidmore/zsh-fzf-history-search)

### Synchronize configuration from repository

You should create a backup of your `.zshrc` file, or delete `.zshrc`, and then create the `nvim` and `wezterm` directories inside your `.config` folder.

``` bash
# Clone the repository
git clone https://github.com/sung2708/dotfiles.git ~/dotfiles

# Navigate into the dotfiles directory
cd ~/dotfiles || { echo "Failed to cd into ~/dotfiles"; exit 1; }

# Create symbolic links using stow
stow --target="$HOME/.config/nvim" nvim
stow --target="$HOME" tmux
stow --target="$HOME" zsh
stow --target="$HOME/.config/wezterm" wezterm

# Verify that the symlinks were created correctly
echo "Checking created symlinks..."
ls -l "$HOME/.config/nvim"
ls -l "$HOME"
ls -l "$HOME/.config/wezterm"
```
**Note**: `eza`, `bat` and `fatfetch` conguration theme is not required, you can use the default configuration.

### Note
- If you open nvim in first time, it will be error maybe related `tree-sitter` or `lspconfig`, because plugins require programing language parsers example `python`, `lua`, `javascript`, `golang`, `cpp` etc...
You can change and check it in `mason.lua`, `tree-sitter.lua` and `lspconfig.lua` files in `~/.config/nvim/lua/sung2708/`.

- You can change `sungp.plugins.plugin-config` to your `username` in `dotfiles/nvim/lua/sungp/config/lazy.lua` file and change `dotfiles/nvim/lua/sungp` by your `username`.

    **Example**: If your username is `john`, you should change `sungp.plugins.plugin-config` to `john.plugins.plugin-config` in `lazy.lua` file.
# Keep updated :new_moon_with_face:
