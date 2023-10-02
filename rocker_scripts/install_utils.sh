#!/bin/bash
set -e

#install2.r --error --skipinstalled \

# packages from github.com/kth-library
echo "GITHUB_PAT=$GITHUB_PAT" >> ~/.Renviron

R -e 'remotes::install_github("brentscott93/pagecryptr", dependencies=TRUE)'

