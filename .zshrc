# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
#plug "zap-zsh/supercharge"
#plug "zap-zsh/zap-prompt"
# plug "zsh-users/zsh-syntax-highlighting"

# Load and initialise completion system
autoload -Uz compinit
compinit

# Set up the prompt
autoload -Uz promptinit
promptinit
prompt adam1

setopt histignorealldups sharehistory

# Utilise les keybinds d'emacs car ce sont utilisé par défaut
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Utiliser Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Alias pour .dotfiles sur git grâce au git bare
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# Pour powerlevel10k grâce à Homebrew
source /home/linuxbrew/.linuxbrew/share/powerlevel10k/powerlevel10k.zsh-theme

# Toutes les fonctions pour zsh
source $HOME/.config/zsh/functions.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# Add ~/bin et script dans le PATH afin de pouvoir les utiliser
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/bin/scripts:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Navigation de fichiers
alias ls="ls -p"
alias la="ls -A"
alias g="git"
alias e="exit"
alias ..="cd .."


# Check si nvim command existe et crée un alias vim si c'est le cas
command -v nvim >/dev/null && alias vim="nvim"

export EDITOR=nvim

alias tmux="tmux -2"

# Obsidian
alias or="vim $HOME/Second-Brain/Inbox/*.md"

# Utilisation d'eza comme exa est plus entretenu
if command -v eza &>/dev/null; then
    alias ll="eza -l -g --icons"
    alias lla="ll -a"
fi

# Zoxide
eval "$(zoxide init zsh)"

# Fzf
eval "$(fzf --zsh)"
export FZF_PREVIEW_FILE_CMD="bat --style=numbers --color=always --line-range :500"
export FZF_LEGACY_KEYBINDINGS=0
export FZF_CTRL_T_OPTS="
--multi
--walker-skip .git,node_modules,target
--preview '${FZF_PREVIEW_FILE_CMD} {}'
--bind 'ctrl-u:preview-page-up,ctrl-d:preview-page-down,ctrl-y:accept'"

export FZF_DEFAULT_OPTS="
	--color=fg:#908caa,hl:#ebbcba
	--color=fg+:#e0def4,hl+:#ebbcba
	--color=border:#403d52,header:#31748f
	--color=spinner:#f6c177,info:#9ccfd8,separator:#403d52
	--color=pointer:#eb6f92,marker:#c4a7e7,prompt:#908caa
    --pointer '>'
    --marker '>'"
