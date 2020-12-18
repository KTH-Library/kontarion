#!/bin/bash
set -e

# packages from github.com/kth-library
echo "GITHUB_PAT=$GITHUB_PAT" >> ~/.Renviron
R -e 'remotes::install_github("kth-library/dblp", dependencies=TRUE)'
R -e 'remotes::install_github("kth-library/XsearchLIBRIS", dependencies=TRUE)'
R -e 'remotes::install_github("kth-library/institutions", dependencies=TRUE)'
R -e 'remotes::install_url("https://cran.r-project.org/src/contrib/Archive/kableExtra/kableExtra_1.1.0.tar.gz", force = TRUE)'
R -e 'remotes::install_github("kth-library/bibliomatrix@poc_staffbased", dependencies=TRUE)'
R -e 'ktheme::install_fonts_linux("/usr/local/share/fonts")'


