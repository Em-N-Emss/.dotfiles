function _fzf_change_directory() {
    local foo
    foo=$(fzf)
    if [[ -n "$foo" ]]; then
        cd "$foo"
        zle reset-prompt
        zle -R
        if [[ -f "$foo" ]]; then
            vim "$foo"
        fi
    else
        zle reset-prompt
    fi
}

function fzf_change_directory() {
    {
        echo "$HOME/.config"
        # find $(ghq root) -maxdepth 4 -type d -name .git | sed 's/\/\.git//'
        # WSL
        # ls -ad /mnt/c/Users/*/.*
        ls -ad /mnt/c/Divers/*
        ls -ad $HOME/.config/**/*
        ls -adr $HOME/Second-Brain/**/* | grep -v '\.git'
        ls -ad */ | sed -e "s#^#$PWD/#" | grep -v '\.git'
        ls -ad $HOME/Developments/*/* | grep -v '\.git'
    } | sed -e 's/\/$//' | awk '!a[$0]++' | _fzf_change_directory "$@"
}
