#!/bin/sh

apt update
echo "Installing dependencies"
apt install git \
    wget \
    unzip \
    zsh \
    curl \
    build-essential \
    cmake \
    python3-pip -y \
    apt install snapd
# Install nvm
echo "Installing nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# Install node
echo "Installing node"
nvm install --lts
nvm use --lts
# Install yarn
echo "Installing yarn"
npm install -g yarn
yarn add neovim -g
# Install golang
echo "Installing golang"
curl -LO https://go.dev/dl/go1.24.3.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.24.3.linux-amd64.tar.gz
# Install zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/joshskidmore/zsh-fzf-history-search ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search

# Install jetbrains nerd fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip

unzip JetBrainsMono.zip -d JetBrainsMono

mkdir -p ~/.fonts

cp JetBrainsMono/*.ttf ~/.fonts

fc-cache -fv

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Install zsh theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

# Install stow
apt install stow -y

# Change .zshrc to bak
if [ -f ~/.zshrc ]; then
    mv ~/.zshrc ~/.zshrc.bak
fi
# Symlink .zshrc
stow --target="$HOME" zsh

# Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# fzf
echo "Installing fzf"
apt install fzf
git clone https://github.com/junegunn/fzf-git.sh
# ripgrep
echo "Installing ripgrep"
apt install ripgrep
# fd
echo "Installing fd"
apt install fd
#bat
echo "Installing bat"
apt install bat
#eza
echo "Installing eza"
apt install eza
#tmux
echo "Installing tmux"
apt install tmux
# nvim
echo "Installing nvim"
snap install nvim --classic

# create symlink
echo
mkdir -p "$HOME/.config/nvim"
stow --target="$HOME/.config/nvim" nvim
stow --target="$HOME" tmux
mkdir -p "$HOME/.config/wezterm"
stow --target="$HOME/.config/wezterm" wezterm

