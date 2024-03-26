# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam1

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

# zstyle ':completion:*' auto-description 'specify: %d'
# zstyle ':completion:*' completer _expand _complete _correct _approximate
# zstyle ':completion:*' format 'Completing %d'
# zstyle ':completion:*' group-name ''
# zstyle ':completion:*' menu select=2
# eval "$(dircolors -b)"
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*' list-colors ''
# zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
# zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
# zstyle ':completion:*' menu select=long
# zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
# zstyle ':completion:*' use-compctl false
# zstyle ':completion:*' verbose true
#
# zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Utiliser Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Zoxide
eval "$(zoxide init zsh)"

# Fzf
eval "$(fzf --zsh)"
export FZF_PREVIEW_FILE_CMD="bat --style=numbers --color=always --line-range :500"
export FZF_LEGACY_KEYBINDINGS=0
# export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude target"
# export FZF_DEFAULT_COMMAND='fd --type f'
# export FZF_DEFAULT_OPTS="--layout=reverse --inline-info"
export FZF_CTRL_T_OPTS="
  --multi
  --walker-skip .git,node_modules,target
  --preview '${FZF_PREVIEW_FILE_CMD} {}'
  --bind 'ctrl-u:preview-page-up,ctrl-d:preview-page-down'"

# Alias pour .dotfiles sur git
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'


# Pour powerlevel10k grâce à Homebrew
source /home/linuxbrew/.linuxbrew/share/powerlevel10k/powerlevel10k.zsh-theme

# Toutes les fonctions pour zsh
source $HOME/.config/zsh/functions.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh


# Add ~/bin to the beginning of the PATH
export PATH="$HOME/bin:$PATH"

# Add ~/bin/scripts to the beginning of the PATH

export PATH="$HOME/bin/scripts:$PATH"

# Add ~/.local/bin to the beginning of the PATH
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

# Utilisation d'eza comme exa est plus entretenu
if command -v eza &>/dev/null; then
    alias ll="eza -l -g --icons"
    alias lla="ll -a"
fi
