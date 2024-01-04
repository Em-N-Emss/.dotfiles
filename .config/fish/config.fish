set fish_greeting ""

set -gx TERM xterm-256color

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

if status is-interactive
    # Commands to run in interactive sessions can go here
    # Active Brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)

    # Navigation de fichiers
    alias ls "ls -p -G"
    alias la "ls -A"

    command -qv nvim && alias vim nvim

    # Alias pour .dotfiles sur git
    alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

    set -gx EDITOR nvim

    # Utilisation d'eza comme exa est plus entretenu
    if type -q eza
        alias ll "eza -l -g --icons"
        alias lla "ll -a"
    end
end


# set -gx PATH bin $PATH
# set -gx PATH ~/bin $PATH
# set -gx PATH ~/.local/bin $PATH
fish_add_path bin
fish_add_path ~/bin
fish_add_path ~/.local/bin

function ktstart
    # Check si komorebi n'est pas déjà démarré
    if not pgrep -f komorebic >/dev/null
        komorebic start -c (wslpath -w "/mnt/c/Users/imran/komorebi.json") --whkd $argv
    end

    # Laisse le temps au terminal de respirer
    sleep 1

    # Lance Tmux avec le nom de la session Em
    tmux new -s Em
end

function ktend
    # Byebye Komorebi
    komorebic stop

    # Laisse le temps au terminal de respirer
    sleep 1

    # Ferme toutes les sessions Tmux
    tmux kill-server
end

# Zoxide
zoxide init fish | source

# Fzf
set -g FZF_PREVIEW_FILE_CMD "bat --style=numbers --color=always --line-range :500"
set -g FZF_LEGACY_KEYBINDINGS 0
