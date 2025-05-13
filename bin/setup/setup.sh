#!/usr/bin/env bash

# Detects package manager and sets up a development environment

set -e  # Exit immediately if a command exits with a non-zero status

# Function to detect package manager
detect_package_manager() {
    if command -v apt &> /dev/null; then
        echo "apt"
    elif command -v dnf &> /dev/null; then
        echo "dnf"
    elif command -v yum &> /dev/null; then
        echo "yum"
    elif command -v pacman &> /dev/null; then
        echo "pacman"
    elif command -v zypper &> /dev/null; then
        echo "zypper"
    elif command -v apk &> /dev/null; then
        echo "apk"
    else
        echo "unknown"
    fi
}


# Function to update system

update_system() {
    local pm=$1
    echo "Updating system using $pm..."

    case $pm in
        apt)
            sudo apt update -y
            ;;
        dnf)
            sudo dnf check-update
            ;;
        yum)
            sudo yum check-update
            ;;
        pacman)
            sudo pacman -Sy
            ;;
        zypper)
            sudo zypper refresh
            ;;
        apk)
            sudo apk update
            ;;
        *)
            echo "Unknown package manager. Skipping update."
            return 1
            ;;
    esac
}

# Function to install git
install_git() {
    local pm=$1

    if command -v git &> /dev/null; then
        echo "✓ Git is already installed."
        return 0
    fi

    echo "Installing git using $pm..."

    case $pm in
        apt)
            sudo apt install -y git
            ;;
        dnf)
            sudo dnf install -y git
            ;;
        yum)
            sudo yum install -y git
            ;;
        pacman)
            sudo pacman -S --noconfirm git
            ;;
        zypper)
            sudo zypper install -y git
            ;;
        apk)
            sudo apk add git
            ;;
        *)
            echo "Unknown package manager. Cannot install git."
            return 1
            ;;
    esac
}

# Main script execution
echo "Starting environment setup..."

# Detect package manager
PM=$(detect_package_manager)

if [ "$PM" = "unknown" ]; then
    echo "Could not detect a supported package manager. Aborting."
    exit 1
fi

echo "Detected package manager: $PM"

# Update system
update_system $PM

# Install git
install_git $PM

# Create personal directory if it doesn't exist
if [ ! -d "$HOME/personal" ]; then
    echo "Creating personal directory..."
    mkdir -p "$HOME/personal"
fi

# Clone repository
echo "Cloning repository..."
git clone https://github.com/Em-N-Emss/.dotfiles "$HOME/.dotfiles"
# if [ ! -d "$HOME/personal/dev" ]; then
#     git clone https://github.com/Em-N-Emss/.dotfiles "$HOME/personal/dev"
# else
#     echo "Repository already exists. Pulling latest changes..."
#     pushd "$HOME/personal/dev" > /dev/null
#     git pull
#     popd > /dev/null
# fi


# Run the setup script from the repository
# echo "Running the setup script..."
# pushd "$HOME/personal/dev" > /dev/null
# ./run
# popd > /dev/null
