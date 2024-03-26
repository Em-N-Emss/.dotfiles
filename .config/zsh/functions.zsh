# source $HOME/.config/zsh/zsh_user_keybindings.zsh

function kts() {
    # Vérifie si komorebi n'est pas déjà démarré
    if ! pgrep -f komorebi >/dev/null; then
        # La commande pour lancer komorebi avec un chemin dynamique
        pwsh.exe -Command 'komorebic start -c "$Env:USERPROFILE\komorebi.json" --whkd'

        # Isole YASB dans une session Tmux à part du reste
        tmux new -d -s yasb pwsh.exe -Command 'cd $Env:USERPROFILE\.yasb && python src\main.py'
    fi

    # Récupère la session "Work" si elle existe, sinon la crée
    tmux new-session -A -s Work
}

function kte() {
    # Se détache de la session courante
    tmux detach

    # Ferme toutes les sessions Tmux sauf "Work"
    tmux kill-session -a -t Work

    # Byebye Komorebi
    komorebic stop

    # Fermer aussi Whkd par précaution
    pwsh.exe -Command 'taskkill /f /im whkd.exe'

    # Attente limitée à 1 seconde pour la terminaison de Komorebi et whkd tant que les processus sont actifs
    while pgrep -f komorebi >/dev/null && pgrep whkd >/dev/null; do
        sleep 1
    done
}

# Définit une fonction pour ouvrir le répertoire courant et sélectionner les fichiers avec fzf puis l'ouvir avec VIM
function fzf_open_current_directory() {
    local selected_file
    selected_file=$(fd . -H -I -d 6 -t f | fzf --multi --preview 'bat --style=numbers --color=always --line-range :500 {}' --bind "ctrl-u:preview-page-up,ctrl-d:preview-page-down")
    if [[ -n $selected_file ]]; then
        ${EDITOR:-vi} "$selected_file"
    fi
}

# Fonction pour ouvrir un répertoire et selectionner le dossier avec fzf
function fzf_cd_current_directory() {
    local selected_directory
    selected_directory=$(fd . $HOME/ '/mnt/c/Divers/' -H -I -d 6 -t d | grep -v '/\.git\|/node_modules' | fzf --walker-skip .git,node_modules,target)
    if [[ -n $selected_directory ]]; then
        cd $selected_directory
    fi
}

# Define key bindings
function zsh_user_key_bindings {
    # fzf avec tmux
    bindkey -s '^f' "tmux-sessionizer\n"
    bindkey -s '^[e' "fzf_cd_current_directory\n"

    # bindkey -s '^o' "fzf_open_current_directory\n"
    bindkey '^o' fzf-file-widget

    # vim-like
    bindkey '^l' forward-char
    bindkey '^n' kill-line

    # prevent iTerm2 from closing when typing Ctrl-D (EOF)
    bindkey '^d' delete-char
}

# Execute key bindings function
zsh_user_key_bindings

