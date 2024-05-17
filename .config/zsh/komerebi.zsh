# Lancer une session Komorebi & Tmux
function kts() {
    # Vérifie si komorebi n'est pas déjà démarré
    if [[ -z $(pwsh.exe -Command 'Get-Process Komorebi' 2>/dev/null) ]]; then
        # La commande pour lancer komorebi avec un chemin dynamique
        pwsh.exe -Command 'komorebic start -c "$Env:USERPROFILE\komorebi.json" --whkd'
    fi

    # Récupère la session "Work" si elle existe, sinon la crée
    tmux new-session -A -s Work
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

    # Se détache de la session courante
    tmux detach

    # Ferme toutes les sessions Tmux sauf "Work"
    tmux kill-session -a -t Work
}
