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
stow --no-folding herdr   # herdr must use --no-folding, see note below
stow */  # Install everything else
# OR
stow tmux  # Install specific config
```

### herdr needs `--no-folding`

`~/.config/herdr/` holds runtime state alongside the config: `herdr.log`,
`herdr-client.log`, `herdr-server.log`, `session.json`, `release-notes.json`,
and the `herdr.sock` / `herdr-client.sock` sockets. Only `config.toml` belongs
in this repo.

If that directory doesn't exist yet, plain `stow herdr` folds the whole tree and
symlinks `~/.config/herdr` into this repo, so herdr then writes its logs and
sockets here. `--no-folding` creates a real directory and symlinks only
`config.toml`.
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
