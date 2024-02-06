set fish_greeting ""

# set -gx TERM xterm-256color
set -gx TERM screen-256color

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
    alias g git
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


set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH
# fish_add_path bin
# fish_add_path ~/bin
# fish_add_path ~/.local/bin

# NodeJS
set -gx PATH node_modules/.bin $PATH

# NVM
function __check_rvm --on-variable PWD --description 'Do nvm stuff'
    status --is-command-substitution; and return

    if test -f .nvmrc; and test -r .nvmrc
        nvm use
    else
    end
end

function kts
    # Vérifie si komorebi n'est pas déjà démarré
    if not pgrep -f komorebi >/dev/null
        # La commande pour lancer komorebi avec un chemin dynamique
        powershell.exe -Command 'komorebic start -c "$Env:USERPROFILE\komorebi.json" --whkd'
    end

    # Récupère la session "Em" si elle existe, sinon la crée
    tmux has-session -t Em >/dev/null; and tmux attach-session -t Em; or tmux new -s Em
end

function kte
    # Byebye Komorebi
    komorebic stop

    # Attente limitée à 1 seconde pour la terminaison de Komorebi tant que le processus est actif
    while pgrep -f komorebi >/dev/null
        sleep 1
    end

    # Ferme toutes les sessions Tmux sauf "Em"
    for session in (tmux list-sessions -F "#{session_name}" | grep -v "Em")
        tmux kill-session -t $session
    end

    # Se détache de la session "Em"
    tmux detach-client -s Em
end

# Zoxide
zoxide init fish | source

# Fzf
set -g FZF_PREVIEW_FILE_CMD "bat --style=numbers --color=always --line-range :500"
set -g FZF_LEGACY_KEYBINDINGS 0
