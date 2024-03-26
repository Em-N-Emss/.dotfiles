# source $HOME/.config/zsh/fzf_change_directory.zsh

# Define key bindings
function zsh_user_key_bindings {
    # fzf
    bindkey '^f' fzf_change_directory

    # vim-like
    bindkey '^l' forward-char

    # prevent iTerm2 from closing when typing Ctrl-D (EOF)
    bindkey '^d' delete-char
}

# Execute key bindings function
zsh_user_key_bindings

# fzf plugin configuration
# export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(cd {})+abort'"
