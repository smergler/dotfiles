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
