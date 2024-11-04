function fzf_pass_completion() {
    # Locate password files, excluding those ending in .gpg
    local pass_entries=$(find "${PASSWORD_STORE_DIR:-$HOME/.password-store}" -type f -name '*.gpg' | \
                   sed "s|^${PASSWORD_STORE_DIR:-$HOME/.password-store}/||; s|\.gpg$||" | fzf)  # Adjust height as necessary

    # If a password is selected, show the password in the terminal
    if [ -n "$pass_entries" ]; then
        # Use zle to insert the selected entry into the command line
        LBUFFER+="$pass_entries"  # Append the selected path to the left buffer
        # The cursor moves to the end of the inserted text
        CURSOR=${#LBUFFER}  # Move the cursor to the end
    fi
}

function fzf_pass_completion-widget() {
    fzf_pass_completion
}

zle -N fzf_pass_completion-widget

