#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

info() {
    echo " "
    echo "INFO: $1"
    echo "===================="
}

#--------------------------------------------------------------------------------#
# STEP 1: SYSTEM UPDATE & ESSENTIALS
#--------------------------------------------------------------------------------#
info "Updating system and installing essential packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed base-devel git stow --noconfirm
info "Setting up Git authentication for GitHub..."

# Git configuration
read -p "Enter GitHub username: " git_username
read -p "Enter GitHub email: " git_email

git config --global user.name "$git_username"
git config --global user.email "$git_email"

# SSH key setup
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    info "Generating SSH key..."
    ssh-keygen -t ed25519 -C "$git_email" -f "$HOME/.ssh/id_ed25519" -N ""
    
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    
    echo ""
    echo "Add this SSH key to GitHub:"
    echo "https://github.com/settings/ssh/new"
    echo ""
    cat ~/.ssh/id_ed25519.pub
    echo ""
    read -p "Press Enter after adding the key to GitHub..."
    
    # Simple connection test
    ssh -T git@github.com 2>/dev/null && echo "✓ GitHub SSH connection successful!" || echo "⚠ Connection test failed - but this might be normal"
else
    echo "SSH key already exists."
fi
#--------------------------------------------------------------------------------#
# STEP 2: INSTALL YAY (AUR HELPER)
#--------------------------------------------------------------------------------#
info "Installing AUR helper 'yay'..."
if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
else
    echo "yay is already installed."
fi

#--------------------------------------------------------------------------------#
# STEP 3: SHELL SETUP (ZSH, OH-MY-ZSH, STARSHIP)
#--------------------------------------------------------------------------------#
info "Setting up Zsh, Oh My Zsh, and plugins..."

# Install zsh
sudo pacman -S zsh --noconfirm

# Install Oh My Zsh non-interactively
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh is already installed."
fi

# Install zsh-autosuggestions 
sudo pacman -S zsh-autosuggestions --noconfirm

# Install Starship prompt
sudo pacman -S starship --noconfirm

# Change default shell to Zsh for the current user
if [ "$SHELL" != "/bin/zsh" ]; then
    chsh -s $(which zsh)
    echo "Default shell changed to Zsh. Please log out and back in after the script finishes."
fi

#--------------------------------------------------------------------------------#
# STEP 4: CLONE AND STOW DOTFILES
#--------------------------------------------------------------------------------#
info "Cloning and stowing dotfiles (arch branch)..."
if [ ! -d "$HOME/.dotfiles" ]; then
    git clone -b arch git@github.com:muhammad-salik-salam/dotfiles.git ~/.dotfiles
else
    echo "Dotfiles directory already exists. Switching to arch branch and pulling latest changes."
    (cd ~/.dotfiles && git checkout arch && git pull)
fi

# Stow the configurations from dotfiles
info "Running 'stow' to link dotfiles..."
(cd ~/.dotfiles && stow -v --adopt */)

#--------------------------------------------------------------------------------#
# STEP 5: INSTALL CORE APPLICATIONS 
#--------------------------------------------------------------------------------#
info "Installing core applications..."
sudo pacman -S --noconfirm \
    tmux \
    kitty \
    fzf \
    neovim \
    timeshift \
    power-profiles-daemon \
    lazygit \
    k9s \
    kubectl \
    kubie \
    pyenv

# Enable the power profiles daemon (this for gnome) 
sudo systemctl enable --now power-profiles-daemon

#--------------------------------------------------------------------------------#
# STEP 6: TMUX & TPM (TMUX PLUGIN MANAGER)
#--------------------------------------------------------------------------------#
info "Setting up Tmux Plugin Manager (TPM)..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "TPM installed. Run 'prefix + I' inside Tmux to install plugins from your .tmux.conf."
else
    echo "TPM already installed."
fi

#--------------------------------------------------------------------------------#
# STEP 7: INSTALL AUR AND OTHER PACKAGES
#--------------------------------------------------------------------------------#
info "Installing packages using yay"
yay -S --noconfirm google-chrome \
	google-cloud-cli \
	slack-desktop \
	docker-desktop \
	visual-studio-code-bin

#--------------------------------------------------------------------------------#
# FINAL STEPS
#--------------------------------------------------------------------------------#
info "Script finished!"
