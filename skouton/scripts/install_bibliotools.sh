#!/bin/bash
set -e

echo "GITHUB_PAT=$GITHUB_PAT" >> ~/.Renviron

R -e 'update.packages()'

# default download.file timeout (60s) is too short for some GitHub Remotes
# dependencies (e.g. reactablefmtr, ~37MB tarball), causing an intermittent
# download failure that remotes swallows without a nonzero exit; raise the
# timeout and verify the install actually succeeded
R -e 'options(timeout = 600); remotes::install_github("kth-library/bibliotools", dependencies=TRUE); stopifnot(requireNamespace("bibliotools", quietly = TRUE))'

# extra packages, can be removed once included in bibliotools DESCRIPTION file
R -e 'install.packages(c("bcrypt", "esquisse", "phonics", "future", "future.callr"))'
