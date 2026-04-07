export ZSH="$HOME/.oh-my-zsh"

plugins=(
zsh-autosuggestions
git ubuntu vscode)

source $ZSH/oh-my-zsh.sh

alias docker-desktop="systemctl --user restart docker-desktop" 
alias bat="batcat"
alias gs="git status"
alias gc="git commit -m"
alias ga="git add"
alias gp="git pull"
alias gP="git push"
alias ls='lsd'
alias lg="lazygit"

# Load bash aliases if present
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# Pyenv configuration
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Envman configuration
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.

export PATH="$PATH:/opt/mssql-tools18/bin"

eval "$(starship init zsh)"

# Set up fzf key bindings and fuzzy completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# calude code
export PATH="$HOME/.claude/local:$PATH"
alias cc="claude --dangerously-skip-permissions"
export CLAUDE_CODE_NEW_INIT=1

# homebrew
. "$HOME/.local/bin/env"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
