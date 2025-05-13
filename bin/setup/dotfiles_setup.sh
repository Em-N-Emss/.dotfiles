#!/usr/bin/env bash

set -e

# Colors
RED='\033[0;31m'

GREEN='\033[0;32m'

YELLOW='\033[0;33m'
BLUE='\033[0;34m'

NC='\033[0m' # No Color

function log() {
    echo -e "${GREEN}[DOTFILES]${NC} $1"
}

function warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

function error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

function setup_bare_repo() {
    log "Setting up bare repository structure..."

    # Define the alias for managing the dotfiles
    DOTFILES_DIR="$HOME/.dotfiles"
    DOTFILES_ALIAS="config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'"

    # Add .dotfiles to .gitignore to avoid recursion problems
    echo ".dotfiles" >> "$HOME/.gitignore" 2>/dev/null || true

    # Check if the bare repo already exists
    if [ -d "$DOTFILES_DIR" ]; then
        log "Dotfiles repository already exists at $DOTFILES_DIR"

    else
        log "Cloning your dotfiles repository..."
        git clone --bare https://github.com/Em-N-Emss/.dotfiles.git "$DOTFILES_DIR" || error "Failed to clone repository"
    fi

    # Define and export the config alias for current session
    alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

    # Add alias to shell configuration
    if [[ "$SHELL" == */zsh ]]; then
        if ! grep -q "alias config=" "$HOME/.zshrc" 2>/dev/null; then
            log "Adding 'config' alias to .zshrc..."
            echo "$DOTFILES_ALIAS" >> "$HOME/.zshrc"
        fi
    elif [[ "$SHELL" == */bash ]]; then
        if ! grep -q "alias config=" "$HOME/.bashrc" 2>/dev/null; then
            log "Adding 'config' alias to .bashrc..."
            echo "$DOTFILES_ALIAS" >> "$HOME/.bashrc"
        fi
    elif [[ "$SHELL" == */fish ]]; then

        # For fish, we need to create a function
        FISH_FUNCTIONS_DIR="$HOME/.config/fish/functions"
        mkdir -p "$FISH_FUNCTIONS_DIR"
        if [ ! -f "$FISH_FUNCTIONS_DIR/config.fish" ]; then
            log "Adding 'config' function to fish..."
            echo "function config
    /usr/bin/git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME \$argv
end" > "$FISH_FUNCTIONS_DIR/config.fish"
        fi
    else
        warn "Unknown shell: $SHELL. Please add the alias manually:"
        warn "$DOTFILES_ALIAS"
    fi

    # Check out the actual content
    log "Checking out dotfiles..."

    # First, try a direct checkout
    if config checkout 2>/dev/null; then
        log "Checked out dotfiles successfully"
    else
        # If direct checkout fails, handle conflicts
        warn "Checkout failed, handling conflicts..."

        # Create backup directory
        mkdir -p "$HOME/.config-backup"

        # Get list of conflicting files
        CONFLICTING_FILES=$(config checkout 2>&1 | egrep "\s+\." | awk {'print $1'})

        if [ -n "$CONFLICTING_FILES" ]; then
            log "Backing up pre-existing dotfiles to ~/.config-backup/"
            echo "$CONFLICTING_FILES" | xargs -I{} mv "$HOME/{}" "$HOME/.config-backup/{}" 2>/dev/null || true

            # Try checkout again
            config checkout || error "Failed to checkout dotfiles even after moving conflicts"
        fi
    fi

    # Set git config to hide untracked files
    log "Configuring the repository..."
    config config --local status.showUntrackedFiles no
    log "Dotfiles setup complete!"
}

function is_installed() {
    command -v "$1" >/dev/null 2>&1
}

function check_and_install_package_manager() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Detect the package manager
        if is_installed apt-get; then
            PM="apt-get"
            INSTALL_CMD="sudo apt-get install -y"
        elif is_installed dnf; then
            PM="dnf"
            INSTALL_CMD="sudo dnf install -y"
        elif is_installed pacman; then

            PM="pacman"
            INSTALL_CMD="sudo pacman -S --noconfirm"
        elif is_installed zypper; then
            PM="zypper"
            INSTALL_CMD="sudo zypper install -y"
        else
            error "No supported package manager found. Please install packages manually."
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if ! is_installed brew; then
            log "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        PM="brew"
        INSTALL_CMD="brew install"
    else
        error "Unsupported operating system: $OSTYPE"
    fi

    log "Using package manager: $PM"
}

function install_packages() {
    local packages=("$@")
    local to_install=()

    log "Checking packages..."

    for pkg in "${packages[@]}"; do
        if ! is_installed "$pkg"; then
            log "Will install: $pkg"
            to_install+=("$pkg")
        else
            log "Already installed: $pkg"
        fi
    done

    if [ ${#to_install[@]} -gt 0 ]; then

        log "Installing packages: ${to_install[*]}"
        $INSTALL_CMD "${to_install[@]}" || error "Failed to install packages"
    else
        log "All packages are already installed!"
    fi
}

function setup_zsh() {

    if [ "$SHELL" != "$(which zsh)" ]; then
        log "Changing default shell to zsh..."
        chsh -s "$(which zsh)" || warn "Could not change shell automatically. Please run: chsh -s $(which zsh)"
    else
        log "zsh is already the default shell"
    fi

    # Install Powerlevel10k if not already installed
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        log "Installing Powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    else
        log "Powerlevel10k theme is already installed"
    fi
}

function setup_post_installations() {
    log "Running post-installation tasks..."

    # Setup fzf
    if is_installed fzf; then
        log "Setting up fzf..."
        # Handle different installation paths
        if [ -f "/usr/share/fzf/key-bindings.zsh" ]; then
            # For Linux package managers
            FZF_DIR="/usr/share/fzf"
        elif [ -d "$HOME/.fzf" ]; then
            # For git installation
            FZF_DIR="$HOME/.fzf"
            if [ ! -f "$HOME/.fzf.zsh" ]; then
                "$FZF_DIR/install" --key-bindings --completion --no-update-rc
            fi
        elif command -v brew &>/dev/null && [ -d "$(brew --prefix)/opt/fzf" ]; then
            # For Homebrew on macOS
            FZF_DIR="$(brew --prefix)/opt/fzf"
            if [ ! -f "$HOME/.fzf.zsh" ]; then
                "$FZF_DIR/install" --key-bindings --completion --no-update-rc
            fi
        fi
    fi

    # Setup zoxide
    if is_installed zoxide; then
        log "Setting up zoxide..."
        # zoxide init is likely already in your dotfiles, but just in case
        if ! grep -q "zoxide init" "$HOME/.zshrc" 2>/dev/null; then
            log "Adding zoxide initialization to .zshrc..."
            echo '# zoxide - smarter cd command' >> "$HOME/.zshrc"
            echo 'eval "$(zoxide init zsh)"' >> "$HOME/.zshrc"
        fi
    fi
}

function show_help() {
    echo "Usage: ./dotfiles_setup.sh [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help      Show this help message"
    echo "  -p, --packages  Install packages only"
    echo "  -d, --dotfiles  Setup dotfiles only (no package installation)"
    echo "  -a, --all       Install packages and setup dotfiles (default)"
    echo ""
    exit 0
}

# Parse arguments
INSTALL_PACKAGES=0
SETUP_DOTFILES=0

# If no arguments, do everything
if [ $# -eq 0 ]; then
    INSTALL_PACKAGES=1
    SETUP_DOTFILES=1
else
    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            -h|--help)
                show_help
                ;;
            -p|--packages)
                INSTALL_PACKAGES=1
                shift
                ;;
            -d|--dotfiles)
                SETUP_DOTFILES=1
                shift
                ;;
            -a|--all)
                INSTALL_PACKAGES=1
                SETUP_DOTFILES=1
                shift
                ;;

            *)
                echo "Unknown option: $key"
                show_help
                ;;
        esac
    done
fi

# Main function
function main() {
    # Setup dotfiles if requested
    if [ $SETUP_DOTFILES -eq 1 ]; then
        setup_bare_repo
    fi

    # Install packages if requested
    if [ $INSTALL_PACKAGES -eq 1 ]; then
        check_and_install_package_manager

        # Define packages to install
        packages=(
            "git"
            "neovim"
            "hub"
            "zsh"
            "gcc"
            "make"
            "tmux"
            "pass"
            "fzf"
            "jq"
            "ripgrep"
            "ghq"
            "fd"
            "zoxide"
            "eza"
        )

        # Install packages
        install_packages "${packages[@]}"

        # Setup zsh and powerlevel10k
        setup_zsh

        # Run any post-installation tasks
        setup_post_installations
    fi

    log "Setup complete! Enjoy batard"
    echo ""
    log "You may need to restart your terminal or run 'source ~/.zshrc' to apply all changes."
}

# Run the main function
main
