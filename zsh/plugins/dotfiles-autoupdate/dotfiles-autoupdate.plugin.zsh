
check_update_label="LABEL_DOTFILE_AUTOUPDATE"
ZSH_CACHE_DIR=~/.oh-my-zsh/cache

do_updates() {
    if [[ $(grep $check_update_label "${ZSH_CACHE_DIR}/.zsh-update") ]]; then
        return 1
    fi
    return 0
}

save_updates() {
    echo "$check_update_label=1" > "${ZSH_CACHE_DIR}/.zsh-update"
}

main() {
    if ! do_updates; then
        return
    fi
    ~/.dotfiles/install.sh
    save_updates
}
main