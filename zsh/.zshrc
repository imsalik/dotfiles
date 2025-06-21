# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"

# Plugins
plugins=(
    zsh-autosuggestions  
    git                  
)

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Aliases
alias docker-desktop="systemctl --user restart docker-desktop"

# Load additional bash aliases if they exist
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# PATH configuration
# Add user's local bin to PATH (for Poetry, pipx, etc.)
export PATH="$HOME/.local/bin:$PATH"

# Python environment management
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Node.js environment management
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Starship prompt
eval "$(starship init zsh)"

# FZF fuzzy finder key bindings and completion
source /usr/share/fzf/key-bindings.zsh

# Google Cloud configuration
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# Claude Code (Anthropic) configuration
# Configure Claude Code to use Google Cloud Vertex AI
export CLAUDE_CODE_USE_VERTEX=1
export CLOUD_ML_REGION=us-east5
export ANTHROPIC_VERTEX_PROJECT_ID=cherre-sandbox