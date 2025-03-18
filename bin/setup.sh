#!/usr/bin/env bash

set -e

echo "Starting dotfiles dependency installation..."

###########################################
# OS Detection & Dependency Installation  #
###########################################

OS=$(uname -s)

if [[ "$OS" == "Darwin" ]]; then
    echo "Detected macOS."
    # Install Homebrew if not installed
    if ! command -v brew &>/dev/null; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    echo "Installing dependencies with Homebrew..."
    brew update
    brew install \
        git \
        ghq \
        neovim \
        hub \
        zsh \
        powerlevel10k \
        zoxide \
        eza \
        fzf \
        fd \
        gcc \
        make \
        tmux \
        pass \
        jq \
        ripgrep

elif [[ "$OS" == "Linux" ]]; then
    # Vérifier si l'environnement est WSL
    if grep -qEi "(microsoft|wsl)" /proc/version &>/dev/null; then
        echo "Detected WSL environment."
        # Pour WSL, supposons un système Ubuntu/Debian donc pas de problème
        sudo apt-get update
        sudo apt-get install -y \
            git \
            neovim \
            hub \
            zsh \
            gcc \
            make \
            tmux \
            pass \
            fzf \
            fd-find \
            jq \
            ripgrep
    else
        echo "Detected native Linux."
        if command -v apt-get &>/dev/null; then
            sudo apt-get update
            sudo apt-get install -y \
                git \
                neovim \
                hub \
                zsh \
                gcc \
                make \
                tmux \
                pass \
                fzf \
                fd-find \
                jq \
                ripgrep
        else
            echo "apt-get not found. Please install required packages manually."
            exit 1
        fi
    fi


    # Install Linuxbrew if not already installed (works for both native Linux and WSL)

    if ! command -v brew &>/dev/null; then
        echo "Installing Linuxbrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [ -d "$HOME/.linuxbrew" ]; then
            eval "$($HOME/.linuxbrew/bin/brew shellenv)"
        elif [ -d "/home/linuxbrew/.linuxbrew" ]; then
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi
    fi

    echo "Installing additional dependencies with Linuxbrew..."
    brew update
    brew install \
        ghq \
        zoxide \
        eza \
        powerlevel10k

else
    echo "Unsupported OS: $OS"
    exit 1
fi

###########################################
# Default Shell & Zsh Plugin Manager      #
###########################################

# Définir zsh comme shell par défaut
echo "Setting zsh as the default shell..."
if command -v zsh &>/dev/null; then
    chsh -s "$(command -v zsh)"
    echo "zsh has been set as your default shell. You may need to log out and log back in for the change to take effect."
else
    echo "zsh not found, cannot set as default shell."
fi

# Installer Zap (gestionnaire de plugins pour Zsh)
echo "Installing Zap for Zsh..."
# if [ -d "${ZDOTDIR:-$HOME}/.znap" ]; then
if [ -d "${ZAP_DIR:-$HOME/.local/share}/zap" ]; then
    echo "Zap is already installed."
else
    # zsh -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/zap-zsh/zap/master/install.sh)"'
    # zsh -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/zap-zsh/zap/master/install.sh) -- branch release-v1"'
    zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
fi


###########################################
# Dotfiles Import                         #

###########################################
echo "Setting up dotfiles..."

# IMPORTANT : Ces commandes supposent que vous souhaitez importer les dotfiles depuis :
# https://github.com/Em-N-Emss/.dotfiles
#
# Les étapes suivantes vont :
# 1. Définir un alias 'config' pour utiliser git avec votre dépôt de dotfiles.
# 2. Ajouter ".dotfiles" à .gitignore afin d'éviter les problèmes de récursivité.
# 3. Cloner le dépôt en mode BARE (très important).
# 4. Effectuer le checkout des dotfiles, en sauvegardant les fichiers en conflit si nécessaire.
# 5. Configurer git pour ne pas afficher les fichiers non suivis.

# Définir l'alias pour la durée de ce script (pour fish, l'ajuster si nécessaire)
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Éviter les problèmes de récursivité en ignorant le dossier .dotfiles
echo ".dotfiles" >> "$HOME/.gitignore"

# Cloner le dépôt de dotfiles en mode BARE (seulement s'il n'existe pas déjà)
if [ -d "$HOME/.dotfiles" ]; then
    echo "Dotfiles repository already exists. Skipping clone."
else
    echo "Cloning dotfiles repository in bare mode..."
    git clone --bare https://github.com/Em-N-Emss/.dotfiles "$HOME/.dotfiles"
fi

# Essayer de faire le checkout des dotfiles
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

# Configurer git pour ne pas afficher les fichiers non suivis dans le dépôt des dotfiles
config config --local status.showUntrackedFiles no

echo "Dotfiles setup completed successfully!"
echo "Setup finished. Enjoy batard"
