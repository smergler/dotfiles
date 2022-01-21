#!/bin/bash

dssh() {
    docker exec -it $1 bash
}
dstop() {
    docker kill $(docker ps -q)
}
drm() {
    docker rm $(docker ps -a -q)
}
drmi() {
    docker rmi $(docker images -q)
}

gcpb() {
    git cherry-pick $(git log --oneline --reverse --format="%h" $1 --not master)
}

checkoutAndPull(){
    git checkout "$1";
    git pull --rebase "$1";
}
