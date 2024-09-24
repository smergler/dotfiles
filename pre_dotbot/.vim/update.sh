#!/bin/bash -e
#
# Updates Vim plugins.
#
# Update everything (long):
#
#   ./update.sh
#
# Update just the things from Git:
#
#   ./update.sh repos
#
# Update just one plugin from the list of Git repos:
#
#   ./update.sh repos powerline
#

cd ~/.dotfiles

vimdir=$PWD/.vim
bundledir=$vimdir/bundle
tmp=/tmp/$LOGNAME-vim-update
me=.vim/update.sh

# I have an old server with outdated CA certs.
if [ -n "$INSECURE" ]; then
  curl='curl --insecure'
  export GIT_SSL_NO_VERIFY=true
else
  curl='curl'
fi

# URLS --------------------------------------------------------------------

# This is a list of all plugins which are available via Git repos. git:// URLs
# don't work.
#
# Commented out plugins are ones that either don't work, I don't need or I
# haven't quite gotten it figured out and configured yet. These came from the
# origin of this script
repos=(
  # https://github.com/Lokaltog/vim-powerline.git
  #https://github.com/Lokaltog/powerline.git

  #actual plugins
  # Functions and mappings to close open HTML/XML tags
  https://github.com/docunext/closetag.vim.git
  # file browser for vim
  https://github.com/scrooloose/nerdtree.git
  # syntax checking
  https://github.com/scrooloose/syntastic.git
  # a pretty awesome git wrapper
  https://github.com/tpope/vim-fugitive.git
  # allows your runtime path to be managed
  https://github.com/tpope/vim-pathogen.git
  # writing html tags for fun and profit
  # see: http://www.catonmat.net/blog/vim-plugins-ragtag-allml-vim/
  https://github.com/tpope/vim-ragtag.git
  # surround phrase with something (ex. \'  instead of \")
  https://github.com/tpope/vim-surround.git
  # auto find, like quicksilver for osx but for text files in the wd
  https://github.com/kien/ctrlp.vim.git
  # browser, but I think it requres a few things I don\'t have
  # https://github.com/majutsushi/tagbar.git
  # not quite sure about this one  TODO: re-read it
  #https://github.com/michaeljsmith/vim-indent-object.git
  # vim room, distraction free feature from WriteRoom
  # https://github.com/mikewest/vimroom.git
  # editor config for vim
  https://github.com/editorconfig/editorconfig-vim.git
  # shows a git diff in the gutter (sign column) and stages/reverts hunks.
  https://github.com/airblade/vim-gitgutter.git
  # let me see buffers
  https://github.com/bling/vim-airline.git
  # multiple cursors
  https://github.com/terryma/vim-multiple-cursors.git


  #syntax files
  # https://github.com/digitaltoad/vim-jade.git
  # https://github.com/kchmck/vim-coffee-script.git
  # https://github.com/nono/vim-handlebars.git
  https://github.com/pangloss/vim-javascript.git
  # https://github.com/timcharper/textile.vim
  # https://github.com/tpope/vim-haml.git
  # https://github.com/tpope/vim-markdown.git
  # https://github.com/wavded/vim-stylus.git
  # https://github.com/vim-scripts/Railscasts-Theme-GUIand256color.git
  # https://github.com/vim-scripts/lighttpd-syntax.git
  https://github.com/derekwyatt/vim-scala.git

  )

# Here's a list of everything else to download in the format
# <destination>;<url>[;<filename>]
other=(

  #'zenburn/colors;http://slinky.imukuppi.org/zenburn/zenburn.vim'
  'L9;https://bitbucket.org/ns9tks/vim-l9/get/tip.zip'
  'wombat/colors;http://files.werx.dk/wombat.vim'
  'actionscript/syntax;http://www.vim.org/scripts/download_script.php?src_id=10123;actionscript.vim'
  'navajo-night/colors;http://vim.sourceforge.net/scripts/download_script.php?src_id=805;navajo-night.vim'
  'glsl/syntax;http://www.vim.org/scripts/download_script.php?src_id=3194;glsl.vim'
  )

case "$1" in

  # GIT -----------------------------------------------------------------
  repos)
    mkdir -p $bundledir
    for url in ${repos[@]}; do
      if [ -n "$2" ]; then
        if ! (echo "$url" | grep "$2" &>/dev/null) ; then
          continue
        fi
      fi
      dest="$bundledir/$(basename $url | sed -e 's/\.git$//')"
      rm -rf $dest
      echo "Cloning $url into $dest"
      git clone $url $dest
      rm -rf $dest/.git
    done
    ;;

  # TARBALLS AND SINGLE FILES -------------------------------------------
  other)
    set -x
    mkdir -p $bundledir
    rm -rf $tmp
    mkdir $tmp
    pushd $tmp

    for pair in ${other[@]}; do
      parts=($(echo $pair | tr ';' '\n'))
      name=${parts[0]}
      url=${parts[1]}
      filename=${parts[2]}
      dest=$bundledir/$name

      rm -rf $dest

      if echo $url | egrep '.zip$'; then
        # Zip archives from VCS tend to have an annoying outer wrapper
        # directory, so unpacking them into their own directory first makes it
        # easy to remove the wrapper.
        f=download.zip
        $curl -L $url >$f
        unzip $f -d $name
        mkdir -p $dest
        mv $name/*/* $dest
        rm -rf $name $f

      else
        # Assume single files. Create the destination directory and download
        # the file there.
        mkdir -p $dest
        pushd $dest
        if [ -n "$filename" ]; then
          $curl -L $url >$filename
        else
          $curl -OL $url
        fi
        popd

      fi

    done

    popd
    rm -rf $tmp
    ;;

  # HELP ----------------------------------------------------------------

  all)
    $me repos
    $me other
    echo
    echo "Update OK"
    ;;

  *)
    set +x
    echo
    echo "Usage: $0 <section> [<filter>]"
    echo "...where section is one of:"
    grep -E '\w\)$' $me | sed -e 's/)//'
    echo
    echo "<filter> can be used with the 'repos' section."
    exit 1

esac
