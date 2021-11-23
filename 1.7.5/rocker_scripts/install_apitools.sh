#!/bin/bash
set -e

echo "GITHUB_PAT=$GITHUB_PAT" >> ~/.Renviron

R -e 'remotes::install_github("jandix/sealr", dependencies=TRUE)'


