# Lancer une session Komorebi & Tmux
function kts() {
    # Vérifie si komorebi n'est pas déjà démarré
    if [[ -z $(pwsh.exe -Command 'Get-Process Komorebi' 2>/dev/null) ]]; then
        # La commande pour lancer komorebi avec un chemin dynamique
        pwsh.exe -Command 'komorebic start -c "$Env:USERPROFILE\komorebi.json" --whkd'
    fi

    # Au cas où on est déja dans Tmux on est obligé de quitter sinon on fera un Tmux dans un Tmux
    if [[ ! -z "$TMUX" ]]; then
        # Evite d'avoir le problème de Tmux nested
        tmux new -s Work -d
        tmux switch-client -t Work
    else
        # Récupère la session "Work" si elle existe, sinon la crée
        tmux new-session -A -s Work
    fi
}

# Lancer une session Komorebi & Tmux & YASB pour avoir une status bar
function ktys() {
    kts

    # Isole YASB dans une session Tmux à part du reste
    tmux new -d -s yasb pwsh.exe -Command 'cd $Env:USERPROFILE\.yasb && python src\main.py'
}

# Permet de kill tout ce qui est en rapport avec Komorebi
function kte() {
    # Attente limitée à 1 seconde pour la terminaison de Komorebi et whkd tant que les processus sont actifs
    if [[ $(pwsh.exe -Command 'Get-Process Komorebi' 2>/dev/null) && $(pwsh.exe -Command 'Get-Process whkd' 2>/dev/null) ]]; then
        # Byebye Komorebi
        komorebic stop
        # Fermer aussi Whkd par précaution
        pwsh.exe -Command 'taskkill /f /im whkd.exe'
    fi

    # Ferme toutes les sessions Tmux sauf "Work"
    tmux kill-session -a -t Work

    # Se détache de la session Work comme c'est la seule restante
    tmux detach

}
