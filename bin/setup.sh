#!/usr/bin/env bash

set -e  # Exit immediately if a command fails

sudo apt update && sudo apt upgrade -y
sudo apt install -y git

############################
# Dotfiles Import & Setup  #
############################

# Define the URL of your dotfiles repository
DOTFILES_REPO="https://github.com/Em-N-Emss/.dotfiles"
DOTFILES_DIR="$HOME/.dotfiles"

echo "Setting up dotfiles..."

# Define the 'config' alias for this script's duration

alias config='/usr/bin/git --git-dir=$DOTFILES_DIR/ --work-tree=$HOME'

# Ensure the .dotfiles directory is ignored to prevent recursion issues

echo ".dotfiles" >> "$HOME/.gitignore"

# Clone the dotfiles repository in bare mode if it doesn't already exist
if [ -d "$DOTFILES_DIR" ]; then
    echo "Dotfiles repository already exists. Skipping clone."
else
    echo "Cloning dotfiles repository in bare mode..."
    git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"
fi


# Attempt to check out the dotfiles
if config checkout; then
    echo "Dotfiles checked out successfully."
else
    echo "Conflicts detected during dotfiles checkout."
    echo "Backing up pre-existing dotfiles..."
    mkdir -p "$HOME/.config-backup"
    config checkout 2>&1 | egrep "\s+\." | awk '{print $1}' | while read -r file; do
        echo "Moving $file to backup folder."
        mv "$file" "$HOME/.config-backup/"
    done
    echo "Removing conflicting .gitignore..."
    rm -f "$HOME/.gitignore"
    echo "Retrying dotfiles checkout..."

    config checkout
fi

# Configure git to hide untracked files in the dotfiles repository

config config --local status.showUntrackedFiles no

# Source the .zshrc file to apply configurations
source ~/.zshrc

# Proceed to run.sh for package installations
echo "Initiating package installation script..."
bash run.sh
echo "Dotfiles setup complete! Please restart your shell or source your profile to apply changes."
