#!/bin/bash
set -e

echo "GITHUB_PAT=$GITHUB_PAT" >> ~/.Renviron

R -e 'update.packages()'

# Downgrade shiny because RI will not work with 1.11.0
R -e 'remotes::install_version("shiny", "1.10.0")'
R -e 'remotes::install_github("kth-library/bibliotools", dependencies=TRUE)'

# extra packages, can be removed once included in bibliotools DESCRIPTION file
R -e 'install.packages(c("DT", "bcrypt", "esquisse", "phonics", "future", "future.callr"))'
R -e 'remotes::install_github("kth-library/meili", dependencies=TRUE)'
