#!/bin/bash
set -e

#install2.r --error --skipinstalled \

# packages from github.com/KTH-Library
echo "GITHUB_PAT=$GITHUB_PAT" >> ~/.Renviron

R -e 'remotes::install_github("kth-library/dblp", dependencies=TRUE)'
R -e 'remotes::install_github("kth-library/XsearchLIBRIS", dependencies=TRUE)'
R -e 'remotes::install_github("kth-library/institutions", dependencies=TRUE)'
R -e 'remotes::install_github("kth-library/cordis", dependencies=TRUE)'
R -e 'remotes::install_github("kth-library/kthapi", dependencies=TRUE)'
R -e 'remotes::install_url("https://cran.r-project.org/src/contrib/Archive/kableExtra/kableExtra_1.1.0.tar.gz", force = TRUE)'

R -e 'remotes::install_github("kth-library/bibliomatrix", dependencies=TRUE)'
R -e 'ktheme::install_fonts_linux("/usr/local/share/fonts")'
R -e 'remotes::install_github("kth-library/kthcorpus", dependencies=TRUE)'

