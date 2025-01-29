# .dotfiles

Personal dotfiles managed with GNU Stow.

## Setup

1. Install stow:
```bash
sudo apt install stow
```
2. Clone and use:
```bash
git clone https://github.com/muhammad-salik-salam/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow */  # Install everything
# OR
stow tmux  # Install specific config
```
## How it works
Stow creates symlinks from dotfiles to your home directory:
- ```~/.dotfiles/tmux/.tmux.conf → ~/.tmux.conf```
- ```~/.dotfiles/zsh/.zshrc → ~/.zshrc```
The key is to organize files in the same structure as they would appear in your home directory.

## Remove Config
```bash
stow -D */     # Remove all
stow -D tmux   # Remove specific
```
