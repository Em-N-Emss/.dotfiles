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

