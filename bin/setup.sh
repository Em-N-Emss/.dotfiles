#!/usr/bin/env bash

set -euo pipefail  # Exit immediately if a command fails, exit on error, exit unset var, pipe failure

echo "Updating package list and upgrading system (if applicable)..."
# Check if apt exists before running it
if command -v apt &> /dev/null; then
    sudo apt update && sudo apt upgrade -y
    echo "Installing git..."
    sudo apt install -y git
else
    echo "apt not found, skipping initial package update/upgrade and git install."
    echo "Assuming git is already installed or will be handled by another process (e.g., Homebrew on Mac)."
    # Ensure git is actually available before proceeding
    if ! command -v git &> /dev/null; then
        echo "ERROR: git command not found. Cannot proceed. Please install git manually."
        exit 1
    fi
fi

############################
# Dotfiles Import & Setup  #
############################

# Define the URL of your dotfiles repository
DOTFILES_REPO="https://github.com/Em-N-Emss/.dotfiles"
DOTFILES_DIR="$HOME/.dotfiles"

echo "Setting up dotfiles..."

# Define the 'config' alias for this script's duration

# alias config='/usr/bin/git --git-dir=$DOTFILES_DIR/ --work-tree=$HOME'
# --- Define the 'config' function ---
config() {
    # Use quotes around variables and "$@" to handle arguments correctly
    /usr/bin/git --git-dir="$DOTFILES_DIR/" --work-tree="$HOME" "$@"
}

# Ensure the .dotfiles directory is ignored to prevent recursion issues

GITIGNORE_PATH="$HOME/.gitignore"
if [ -f "$GITIGNORE_PATH" ] && grep -q "^\.dotfiles$" "$GITIGNORE_PATH"; then
    echo ".dotfiles already in $GITIGNORE_PATH"
else
    echo ".dotfiles" >> "$GITIGNORE_PATH"
    echo "Added .dotfiles to $GITIGNORE_PATH"
fi

# Clone the dotfiles repository in bare mode if it doesn't already exist
if [ -d "$DOTFILES_DIR" ]; then
    echo "Dotfiles repository already exists. Skipping clone."
    echo "Fetching latest changes for dotfiles..."
    config fetch origin || echo "Could not fetch dotfiles repo, maybe offline?"
else
    echo "Cloning dotfiles repository in bare mode..."
    git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# Attempt to check out the dotfiles
# Now uses the config function
if config checkout; then
    echo "Dotfiles checked out successfully."
else
    echo "Conflicts detected during dotfiles checkout."
    echo "Backing up pre-existing dotfiles..."
    # NOTE: Consider using a timestamped backup directory
    # BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d%H%M%S)"
    BACKUP_DIR="$HOME/.config-backup"
    mkdir -p "$BACKUP_DIR" # Ensure backup directory exists

    echo "Identifying conflicting files..."
    # Now uses the config function
    CONFLICTING_FILES=$(config checkout 2>&1 | grep -E '^\s+' | awk '{print $1}')

    if [[ -z "$CONFLICTING_FILES" ]]; then # <--- INNER IF 1 starts
        warn "Could not automatically identify conflicting files, though checkout failed."
        warn "Manual intervention might be required in $HOME."
    else
        echo "Moving conflicting files to backup directory: $BACKUP_DIR"
        echo "$CONFLICTING_FILES" | while read -r file; do
            if [[ -e "$HOME/$file" ]]; then
                echo "Backing up: $file"
                mkdir -p "$BACKUP_DIR/$(dirname "$file")" # Create parent dirs in backup
                mv "$HOME/$file" "$BACKUP_DIR/$file"
            else
                 echo "Skipping $file (listed as conflict but not found at $HOME/$file)"
            fi
        done
    fi

    # --- Removed the potentially problematic `rm -f "$HOME/.gitignore"` ---
    # The backup process should handle the original .gitignore if it conflicted.
    # Let's rely on the retry below. If .gitignore was the *only* conflict,
    # it should be in the backup dir now and checkout should succeed.

    echo "Retrying dotfiles checkout after backup..."
    # Now uses the config function
    if config checkout; then
        echo "Dotfiles checked out successfully after backup."
    else
        echo "ERROR: Checkout failed even after backing up conflicting files."
        echo "Please check the state manually in $HOME and $DOTFILES_DIR."
        # You could attempt `config status` here to show more info
        exit 1 # Hard fail if checkout doesn't work after backup
    fi
fi

# Attempt to check out the dotfiles
# if config checkout; then
#     echo "Dotfiles checked out successfully."
# else
#     echo "Conflicts detected during dotfiles checkout."
#     echo "Backing up pre-existing dotfiles..."
#     mkdir -p "$HOME/.config-backup-$(date +%Y%m%d%H%M%S)"
#     config checkout 2>&1 | egrep "\s+\." | awk '{print $1}' | while read -r file; do
#         echo "Moving $file to backup folder."
#         mv "$file" "$HOME/.config-backup/"
#     done
#     echo "Removing conflicting .gitignore..."
#     rm -f "$HOME/.gitignore"
#     echo "Retrying dotfiles checkout..."
#
#     # config checkout
#     echo "Retrying dotfiles checkout after backup..."
#     if config checkout; then
#         echo "Dotfiles checked out successfully after backup."
#     else
#         echo "ERROR: Checkout failed even after backing up conflicting files."
#         echo "Please check the state manually in $HOME and $DOTFILES_DIR."
#         # SUGGESTION: Maybe list the remaining conflicts here?
#         exit 1 # Hard fail if checkout doesn't work after backup
#     fi
# fi

# Configure git to hide untracked files in the dotfiles repository

config config --local status.showUntrackedFiles no

# Source the .zshrc file to apply configurations
# source ~/.zshrc

# Proceed to run.sh for package installations
# NOTE: Make sure run.sh is executable
echo "Initiating package installation script..."
# bash run.sh
# Check if run.sh exists and is executable
if [ -f "run.sh" ] && [ -x "run.sh" ]; then
    ./run.sh # Use ./ to run from the current directory
else
   echo "ERROR: run.sh not found or not executable in the current directory."
   exit 1
fi

echo "###########################################################"
echo "# Dotfiles setup complete!                                #"
echo "# IMPORTANT: Restart your shell or source your profile    #"
echo "# (e.g., 'source ~/.zshrc' or 'source ~/.bashrc')         #"
echo "# to apply all changes, especially PATH updates!          #"
echo "# run sudo chsh -s $(which zsh) for zsh as default shell  #"
echo "###########################################################"
