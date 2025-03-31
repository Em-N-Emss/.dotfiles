#!/usr/bin/env bash

set -euo pipefail  # Exit immediately if a command fails, exit on error, exit unset var, pipe failure

##################
#  OS Detection  #
##################
# detect_os() {
#     OS_NAME="$(uname -s)"
#
#     if [[ "$OS_NAME" == "linux-gnu"* ]]; then
#         if grep -qi microsoft /proc/version; then
#             echo "WSL"
#         else
#             echo "Linux"
#         fi
#     elif [[ "$OS_NAME" == "darwin"* ]]; then
#         echo "Mac"
#     else
#         echo "Unsupported"
#         exit 1
#     fi
# }

detect_os() {
    local os_name kernel_name
    os_name=$(uname -s)
    kernel_name=$(uname -r) # For WSL detection

    if [[ "$os_name" == "Linux" ]]; then
        # Check for Microsoft signature in kernel release for WSL
        if [[ "$kernel_name" == *"Microsoft"* || "$kernel_name" == *"microsoft-standard-WSL2"* ]]; then
            echo "WSL"
        else
            echo "Linux"
        fi
    elif [[ "$os_name" == "Darwin" ]]; then
        echo "Mac"
    else
        echo "Unsupported ($os_name)"
        exit 1
    fi
}
OS=$(detect_os)
echo "Detected OS: $OS"

##########################
#  Package Installation  #
##########################

# Helper function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Define core packages (for all systems)
CORE_PACKAGES=(git neovim hub zsh gcc make tmux pass fzf fd-find jq ripgrep)
# Additional packages to be installed with Homebrew
BREW_PACKAGES=(ghq zoxide eza powerlevel10k)

install_homebrew() {
    if ! command_exists brew; then
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

        # Verify brew command is now available
         if ! command_exists brew; then
             echo "ERROR: Homebrew installed but 'brew' command not found in PATH."
             echo "Manual configuration might be needed. Check instructions in $HOME/.zprofile or $HOME/.bashrc or $HOME/.zshrc"
             exit 1
         fi
         echo "Homebrew should now be configured in your PATH for new shell sessions."
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
    if ! command_exists zsh; then
        echo "ERROR: zsh command not found. Cannot install Zap."
        echo "Please make sure zsh was installed correctly by apt or brew."
        exit 1
    fi

    echo "Installing Zap for Zsh..."
    # Check if Zap is already installed
    if [ -d "${ZAP_DIR:-$HOME/.local/share}/zap" ]; then
        echo "Zap is already installed."
    else
        # Install Zap via its installer script
        zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
    fi
}

# Install Zap if Zsh was installed
if command_exists zsh; then
    install_zap
else
    echo "Skipping Zap installation because Zsh is not available."
fi

echo "All dependencies have been installed successfully."
