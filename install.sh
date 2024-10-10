#!/bin/bash -e
#
# Ian's dotfile installer. Usage:
#
#   curl https://raw.githubusercontent.com/smergler/dotfiles/master/install.sh |zsh
#
# or:
#
#   ~/.dotfiles/install.sh
#
# (It doesn't descend into directories.)

basedir=$HOME/.dotfiles
bindir=$HOME/bin
gitbase=git@github.com:smergler/dotfiles.git
tarball=http://github.com/smergler/dotfiles/tarball/master

function has() {
    return $( which $1 >/dev/null )
}

function note() {
    echo "[32;1m * [0m$*"
}

function warn() {
    echo "[31;1m * [0m$*"
}

function die() {
    warn $*
    exit 1
}

function unpack_tarball() {
    note "Downloading tarball..."
    mkdir -vp $basedir
    cd $basedir
    tempfile=TEMP.tar.gz
    if has curl; then
        curl -L $tarball >$tempfile
    elif has wget; then
        wget -O $tempfile $tarball
    else:
        die "Can't download tarball."
    fi
    tar --strip-components 1 -zxvf $tempfile
    rm -v $tempfile
}

if [ -e $basedir ]; then
    # Basedir exists. Update it.
    cd $basedir
    if [ -e .git ]; then
        note "Updating dotfiles from git..."
        git pull --rebase --autostash origin master
        note "Installing Submodules"
        git submodule update --init --recursive
    else
        unpack_tarball
    fi
else
    # .dotfiles directory needs to be installed. Try downloading first with
    # git, then use tarballs.
    if has git; then
        note "Cloning from git..."
        git clone $gitbase $basedir
        cd $basedir
        note "Installing Submodules"
        git submodule update --init --recursive
    else
        warn "Git not installed."
        unpack_tarball
    fi
fi

if [[ $(uname -m) != *"aarch"* ]]; then
    if ! has brew; then
        note "Installing homebrew, may ask for credentials"
        /bin/bash -c  ~/.dotfiles/libs/homebrew-install/install.sh
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

if [ -e ~/.oh-my-zsh ]; then
    note "OhMyZSH is already installed"
else
    note "Installing OhMyZSH"
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
fi

note "Running dotbot install"
$basedir/dotbot_install \
    --plugin-dir $basedir/libs/dotbot-if \
    --plugin-dir $basedir/libs/dotbot-multi-install \
    --plugin-dir $basedir/libs/dotbot-yum \
    -c dotbot_config.yaml

note "Done."
