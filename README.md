# 1. Introduction

My dotfile repository is a collection of configuration files that I use to customize my system. The repository is organized in a way that makes it easy to install and manage the configuration files. The repository is also designed to be easily portable, so that I can quickly set up my configuration on a new system.

# 2. Installation

To install the configuration files, clone the repository. Use [Gnu stow](https://www.gnu.org/software/stow/manual/stow.html) to create symbolic links to the configuration files. The following commands will install the configuration files in the home directory.

### Require packages

- [neovim](https://neovim.io/) (Optional) ```brew install neovim``` or ```sudo apt-get install neovim```
- [Nerd fonts](https://www.nerdfonts.com/font-downloads)
- [Oh my zsh](https://ohmyz.sh/) ```sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"```
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [zsh](https://www.zsh.org/) Recomment to use zsh as shell ```brew install zsh``` or ```sudo apt-get install zsh```
- [git](https://git-scm.com/) ```brew install git``` or ```sudo apt-get install git```
- [stow](https://www.gnu.org/software/stow/manual/stow.html) ```brew install stow``` or ```sudo apt-get install stow```
- [wezterm](https://wezfurlong.org/wezterm/) I use it as terminal emulator ```brew install wezterm``` or ```sudo apt-get install wezterm```

### CLI tools

- [fzf](https://junegunn.github.io/fzf) ```brew install fzf``` or ```sudo apt-get install fzf```
- [fzf-git](https://github.com/junegunn/fzf-git.sh) ```git clone https://github.com/junegunn/fzf-git.sh```
- [ripgrep](https://github.com/BurntSushi/ripgrep) ```brew install ripgrep``` or ```sudo apt-get install ripgrep```
- [fd](https://github.com/sharkdp/fd) ```brew install fd``` or ```sudo apt-get install fd```
- [bat](https://github.com/sharkdp/bat) Replaces `cat` for color, pairs well with fzf ```brew install bat``` or ```sudo apt-get install bat```
- [eza](https://github.com/eza-community/eza) Replaces `ls` ```brew install eza``` or ```sudo apt-get install eza```
- [the fuck](https://github.com/nvbn/thefuck) (Optional) ```brew install thefuck``` or
```
sudo apt update
sudo apt install python3-dev python3-pip python3-setuptools
pip3 install thefuck --user
```

- [tmux](https://github.com/tmux/tmux/wiki) (Optional) ```brew install tmux``` or ```sudo apt-get install tmux```

### ZSH plugins
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zsh-fzf-history-search](https://github.com/joshskidmore/zsh-fzf-history-search)

#### Synchronize configuration from repository

``` bash
# Clone the repository
git clone https://github.com/sung2708/dotfiles.git ~/dotfiles

# Navigate into the dotfiles directory
cd ~/dotfiles || exit

# Create symbolic links using stow
stow -t ~/.config/nvim nvim
stow -t ~ tmux
stow -t ~ zsh
stow -t ~/.config/wezterm wezterm

# Verify that the symlinks were created correctly
echo "Checking created symlinks..."
ls -l ~/.config/nvim
ls -l ~
ls -l ~/.config/wezterm
```

# Keep updated :new_moon_with_face:
