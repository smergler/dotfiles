#!/bin/bash -e
#
# Ian's dotfile installer. Usage:
#
#   curl https://raw.github.com/smergler/dotfiles/master/install.sh | sh
#
# or:
#
#   ~/.dotfiles/install.sh
#
# (It doesn't descend into directories.)

basedir=$HOME/.dotfiles
bindir=$HOME/bin
gitbase=git://github.com/smergler/dotfiles.git
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

function link() {
    src=$1
    dest=$2

    if [ -e $dest ]; then
        if [ -L $dest ]; then
            # Already symlinked -- I'll assume correctly.
            return
        else
            # Rename files with a ".old" extension.
            warn "$dest file already exists, renaming to $dest.old"
            backup=$dest.old
            if [ -e $backup ]; then
                die "$backup already exists. Aborting."
            fi
            mv -v $dest $backup
        fi
    fi

    # Update existing or create new symlinks.
    ln -vsf $src $dest
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
        git pull --rebase origin master
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
        git submodule init
        git submodule update
    else
        warn "Git not installed."
        unpack_tarball
    fi
fi

note "Installing dotfiles..."
for path in .* ; do
    case $path in
        .|..|.git)
            continue
            ;;
        *)
            link $basedir/$path $HOME/$path
            ;;
    esac
done

note "Installing bin/ directory..."
mkdir -v -p $bindir
for path in bin/* ; do
    relpath=$( basename $path )
    link $basedir/$path $bindir/$relpath
done

note "Symlinking Vim configurations..."
for rc in vim gvim; do
    link $basedir/.vim/${rc}rc $HOME/.${rc}rc
    if [ ! -e $HOME/.${rc}local ]; then
        touch $HOME/.${rc}local
    fi
done

link $basedir/.vim/editorconfig $HOME/.editorconfig


note "Initializing tools..."
#if has git; then
    # Post-install scripts might customize this further.
    # cp -v $basedir/.gitconfig.base $HOME/.gitconfig
#fi
if has vim; then
  cd $basedir
  ./.vim/update.sh all
fi

note "Running Scripts"
for script in scripts/*; do
	echo "Running $script";
	sh $script
done


note "Running post-install script, if any..."
postinstall=$HOME/.postinstall
if [ -e $postinstall ]; then
    # A post-install script can the use functions defined above.
    . $postinstall
fi

note "Done."
