#!/bin/bash

# Clone repo to `.dotfiles/` if it doesn't exist
REPO="https://github.com/Wolfiej-k/dotfiles.git"
[ ! -d "$HOME/.dotfiles" ] && git clone --bare "$REPO" "$HOME/.dotfiles"

# Alias for non-root git directory
function dotfiles {
   /usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}

# Checkout files and move conflicts to `.dotfiles-backup/`
if ! dotfiles checkout 2>/dev/null; then
    mkdir -p "$HOME/.dotfiles-backup"
    dotfiles checkout 2>&1 | grep -E "^\s+" | awk '{print $1}' | while read -r file; do
        mkdir -p "$HOME/.dotfiles-backup/$(dirname "$file")"
        mv "$HOME/$file" "$HOME/.dotfiles-backup/$file"
    done
    dotfiles checkout
fi

# Hide untracked files in `dotfiles status`
dotfiles config --local status.showUntrackedFiles no
