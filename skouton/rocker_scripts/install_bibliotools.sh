#!/bin/bash
set -e

echo "GITHUB_PAT=$GITHUB_PAT" >> ~/.Renviron

R -e 'update.packages()'

R -e 'remotes::install_github("kth-library/bibliotools", dependencies=TRUE)'

# extra packages, can be removed once included in bibliotools DESCRIPTION
R -e 'install.packages(c("DT", "esquisse", "phonics", "future", "future.callr"))'
R -e 'remotes::install_github("kth-library/meili", dependencies=TRUE)'
