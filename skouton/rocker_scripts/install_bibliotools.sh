#!/bin/bash
set -e

echo "GITHUB_PAT=$GITHUB_PAT" >> ~/.Renviron
R -e 'update.packages()'
R -e 'remotes::install_github("kth-library/bibliotools", dependencies=TRUE)'
