#!/bin/bash
#
# This is a combination of aliases I've needed to use/used over the years
#   and dot files from Paul Irish https://github.com/paulirish/dotfiles
#
# Easier navigation: .., ..., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
	colorflag="--color"
else # OS X `ls`
	colorflag="-G"
fi

# some more ls aliases
alias ls='ls -CFG'
alias ll="ls -lh ${colorflag}"
alias la="ls -A"
alias lla="ll -A"
alias lsd='ls -l |grep "^d"'

# `cat` with beautiful colors. requires Pygments installed.
# 							   sudo easy_install Pygments
alias c='pygmentize -O style=monokai -f console256 -g'

#GIT STUFF

# Undo a `git push`
alias undopush="git push -f origin HEAD^:master"
alias gfpo="git push -f origin"
alias gpo="git push -u origin $(parse_git_branch)"

# See a git tree
alias gltree="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue) <%an> %Creset' --abbrev-commit"

# git root
alias gr='[ ! -z `git rev-parse --show-cdup` ] && cd `git rev-parse --show-cdup || pwd`'
alias gs='git status -s -uno'
# git show stash diff
alias gss='git stash show -p'

# this will do 3 things
# first, get the latest master
# then delete all merged branches
# then delete all squash and merged branches (since they don't show up as merged)
# last part lovingly stolen from https://medium.com/opendoor-labs/cleaning-up-branches-with-githubs-squash-merge-43138cc7585e
alias rmMergedBranches='git checkout master && git pull && git branch --merged | egrep -v "(^\*|master)" | xargs git branch -d  && comm -12 <(git branch | sed "s/ *//g") <(git remote prune origin | sed "s/^.*origin\///g") | xargs -L1 -J % git branch -D %'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en1"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# Enhanced WHOIS lookups
alias whois="whois -h whois-servers.net"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Canonical hex dump; some systems have this symlinked
type -t hd > /dev/null || alias hd="hexdump -C"

# OS X has no `md5sum`, so use `md5` as a fallback
type -t md5sum > /dev/null || alias md5sum="md5"

# Trim new lines and copy to clipboard
alias trimcopy="tr -d '\n' | pbcopy"

# Recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"

# Shortcuts
alias g="git"
alias v="vim"

# File size
alias fs="stat -f \"%z bytes\""

# ROT13-encode text. Works for decoding, too! ;)
alias rot13='tr a-zA-Z n-za-mN-ZA-M'

# Empty the Trash on all mounted volumes and the main HDD
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; rm -rfv ~/.Trash"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"


# PlistBuddy alias, because sometimes `defaults` just doesn’t cut it
alias plistbuddy="/usr/libexec/PlistBuddy"

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
	alias "$method"="lwp-request -m '$method'"
done

# Stuff I never really use but cannot delete either because of http://xkcd.com/530/
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume 10'"
# TODO look how to do this in osascript
#alias hax="growlnotify -a 'Activity Monitor' 'System error' -m 'WTF R U DOIN'"
alias turnOnBluetooth="blueutil -p 1"

alias df="df -h"
alias cls='clear && ls'
alias scp='scp -2Cr'

# wget w/o letting the server know we are using wget
alias wget='wget --user-agent=""'

# docker-related fun
alias dc="docker compose"
alias dps="docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Ports}}\t{{.Status}}'"
alias dpn="docker ps --format '{{.Names}}'"

# regular fun
alias downloadFromYoutube='youtube-dl -x --audio-format mp3 --audio-quality 0 --output "%(title)s.%(ext)s" --metadata-from-title "(?P<title>.+)"'

# test stuff in go and show coverage
alias gotwc='go test -coverprofile=coverage.out && go tool cover -html=coverage.out && rm coverage.out'


# docker and k8s commands I'm not sure about yet
alias dexec="docker exec -it"
alias k='kubectl'
