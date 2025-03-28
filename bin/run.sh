#!/usr/bin/env bash

set -e  # Exit immediately if a command fails

################
# OS Detection #
################
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if grep -qi microsoft /proc/version; then
            echo "WSL"
        else
            echo "Linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Mac"
    else
        echo "Unsupported"
        exit 1
    fi
}

OS=$(detect_os)
echo "Detected OS: $OS"

##########################
#  Package Installation  #
##########################

# Define core packages (for all systems)
CORE_PACKAGES=(git neovim hub zsh gcc make tmux pass fzf fd-find jq ripgrep)
# Additional packages to be installed with Homebrew
BREW_PACKAGES=(ghq zoxide eza powerlevel10k)

install_homebrew() {
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Ensure brew is in PATH for the rest of the script
        if [[ "$OS" == "Mac" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            # For Linux/WSL, Homebrew is typically installed to /home/linuxbrew/.linuxbrew\n            test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)" || \
            test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
            test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
            echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
        fi
    else
        echo "Homebrew is already installed."
    fi
}

install_apt_packages() {
    echo "Updating apt and installing core packages..."
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y "${CORE_PACKAGES[@]}"
}

install_brew_packages() {
    echo "Installing packages via Homebrew..."
    brew install "${BREW_PACKAGES[@]}" "${CORE_PACKAGES[@]}"
}

if [[ "$OS" == "Linux" || "$OS" == "WSL" ]]; then
    install_apt_packages
    install_homebrew
    install_brew_packages
elif [[ "$OS" == "Mac" ]]; then
    install_homebrew
    install_brew_packages
else
    echo "Unsupported OS. Exiting."
    exit 1
fi

########################
#  Zsh Plugin Manager  #
########################
install_zap() {
    echo "Installing Zap for Zsh..."
    # Check if Zap is already installed
    if [ -d "${ZAP_DIR:-$HOME/.local/share}/zap" ]; then
        echo "Zap is already installed."
    else
        # Install Zap via its installer script
        zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
    fi
}

install_zap
echo "All dependencies have been installed successfully."
