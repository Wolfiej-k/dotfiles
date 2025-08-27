alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

files() {
    fd --type f --hidden --exclude .git
}

strings() {
    rg --hidden --color=always --line-number --no-heading "$@"
}

search() {
    fzf --ansi --delimiter : \
        --preview '[[ -n {2} ]] && bat --style=numbers --color=always --highlight-line {2} {1} || bat --style=numbers --color=always {1}' \
        --bind 'enter:become:nvim {1} +{2}'
}

alias ff='files | search'
alias fg='strings "" | search'
