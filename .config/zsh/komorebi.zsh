# Lancer une session Komorebi AVEC un gap pour les fenêtres & Tmux
function kts() {
    # Vérifie si komorebi n'est pas déjà démarré
    if [[ -z $(pwsh.exe -Command 'Get-Process Komorebi' 2>/dev/null) ]]; then
        # La commande pour lancer komorebi avec un chemin dynamique
        pwsh.exe -Command 'komorebic start -c "$Env:KOMOREBI_CONFIG_HOME\komorebi.json" --whkd'
    else
        # La commande pour modifier la configuration de komorebi en live et mettre les fenêtres AVEC gap
        pwsh.exe -Command 'komorebic replace-configuration "$Env:KOMOREBI_CONFIG_HOME\komorebi.json"'
    fi

    if [[ -z "$TMUX" ]]; then
        # La on est en dehors de tmux → attacher si la session "Work" existe, sinon la crée
        tmux new-session -As Work
    else
        # Ici on est déjà dans Tmux donc on va tester si la session "Work" existe
        if tmux has-session -t Work 2>/dev/null; then
            # Si la session "Work" existe on va just switch dedan
            tmux switch-client -t Work
        else
            # Si la session "Work" n'existe pas on va crée la session et s'en détacher car pas nécessaire de rester dedans
            tmux new-session -d -s Work -c "$HOME"
        fi
    fi
}

# Lancer une session Komorebi SANS gap pour les fenêtres & Tmux
function kfts() {
    # Vérifie si komorebi n'est pas déjà démarré
    if [[ -z $(pwsh.exe -Command 'Get-Process Komorebi' 2>/dev/null) ]]; then
        # La commande pour lancer komorebi avec un chemin dynamique
        pwsh.exe -Command 'komorebic start -c "$Env:KOMOREBI_CONFIG_HOME\komorebi_full_windows.json" --whkd'
    else
        # La commande pour modifier la configuration de komorebi en live et mettre les fenêtres SANS gap
        pwsh.exe -Command 'komorebic replace-configuration "$Env:KOMOREBI_CONFIG_HOME\komorebi_full_windows.json"'
    fi

    if [[ -z "$TMUX" ]]; then
        # La on est en dehors de tmux → attacher si la session "Work" existe, sinon la crée
        tmux new-session -As Work
    else
        # Ici on est déjà dans Tmux donc on va tester si la session "Work" existe
        if tmux has-session -t Work 2>/dev/null; then
            # Si la session "Work" existe on va just switch dedan
            tmux switch-client -t Work
        else
            # Si la session "Work" n'existe pas on va crée la session et s'en détacher car pas nécessaire de rester dedans
            tmux new-session -d -s Work -c "$HOME"
        fi
    fi
}

# Lancer une session Komorebi AVEC gap & Tmux & YASB pour avoir une status bar
function ktys() {
    # Isole YASB dans une session Tmux à part du reste
    tmux new -d -s yasb pwsh.exe -Command 'cd $Env:USERPROFILE\.yasb && python src\main.py'
    kts
}

# Lancer une session Komorebi SANS gap & Tmux & YASB pour avoir une status bar
function kftys() {
    # Isole YASB dans une session Tmux à part du reste
    tmux new -d -s yasb pwsh.exe -Command 'cd $Env:USERPROFILE\.yasb && python src\main.py'
    kfts
}

# Permet de kill tout ce qui est en rapport avec Komorebi
function kte() {
    # Attente limitée à 1 seconde pour la terminaison de Komorebi et whkd tant que les processus sont actifs
    if [[ $(pwsh.exe -Command 'Get-Process Komorebi' 2>/dev/null) && $(pwsh.exe -Command 'Get-Process whkd' 2>/dev/null) ]]; then
        # Byebye Komorebi
        komorebic stop
        pwsh.exe -Command 'taskkill /f /im komorebi.exe'
        # Fermer aussi Whkd par précaution
        pwsh.exe -Command 'taskkill /f /im whkd.exe'
    fi

    # Ferme toutes les sessions Tmux sauf "Work"
    tmux kill-session -a -t Work

    # Se détache de la session Work comme c'est la seule restante
    tmux detach
}
