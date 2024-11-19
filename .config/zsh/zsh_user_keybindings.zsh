source $HOME/.config/zsh/fzf_pass.zsh
# Utilisation des keybindings dans zsh
function zsh_user_key_bindings {
    # fzf avec tmux
    bindkey -s '^f' "tmux-sessionizer\n"
    bindkey -s '^[e' "fzf_cd_current_directory\n"
    bindkey '^l' fzf_pass_completion-widget


    bindkey '^o' fzf-file-widget

    # vim-like
    bindkey '^y' forward-char

    # Empêche iTerm2 de se fermer quand on fait un Ctrl-D (EOF)
    bindkey '^d' delete-char
}
