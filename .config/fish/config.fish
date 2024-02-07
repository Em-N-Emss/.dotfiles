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
        pwsh.exe -Command 'komorebic start -c "$Env:USERPROFILE\komorebi.json" --whkd'

        # Isole YASB dans une session Tmux à part du reste
        tmux new -d -s yasb pwsh.exe -Command 'cd $Env:USERPROFILE\.yasb && python src\main.py'
    end

    # Récupère la session "Work" si elle existe, sinon la crée
    tmux new-session -A -s Work
end

function kte
    # Byebye Komorebi
    komorebic stop

    # Fermer aussi Whkd par précaution
    pwsh.exe -Command 'taskkill /f /im whkd.exe'

    # Attente limitée à 1 seconde pour la terminaison de Komorebi et whkd tant que les processus sont actifs
    while pgrep -f komorebi >/dev/null && whkd >/dev/null
        sleep 1
    end

    # Se détache de la session courante
    tmux detach

    # Ferme toutes les sessions Tmux sauf "Work"
    tmux kill-session -a -t Work

end

# Zoxide
zoxide init fish | source

# Fzf
set -g FZF_PREVIEW_FILE_CMD "bat --style=numbers --color=always --line-range :500"
set -g FZF_LEGACY_KEYBINDINGS 0
