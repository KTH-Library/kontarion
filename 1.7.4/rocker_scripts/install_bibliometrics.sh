#!/bin/bash
set -e

# add GTK2+ system lib required for CITAN
# add libpoppler-cpp-dev needed by pdftools

apt-get update && apt-get install -y --no-install-recommends \
  libgtk2.0-dev \
  software-properties-common apt-file

#add-apt-repository -y ppa:cran/poppler
apt-get install -y --no-install-recommends \
  libpoppler-cpp-dev

install2.r --error --skipinstalled \
	oai \
	rentrez \
	fulltext \
	europepmc

# R packages on CRAN

# generic tooling/infra packages 
install2.r --error --skipinstalled \
	plumber \
	configr \
	shinydashboard \
	flexdashboard \
	auth0

# general visualization and analysis packages
install2.r --error --skipinstalled \
	tsibble \
	plotly \
	igraph \
	networkD3 \
	visNetwork \
	ggthemes

# specific bibliometrics packages
install2.r --error --skipinstalled \
	microdemic \
	scholar \
	CITAN \
	sas7bdat \
	SAScii \
	rscopus \
	roadoi \
	rAltmetric \
	wosr \
	bibliometrix \
	leiden

install2.r --error --skipinstalled \
	rcrossref \
	citecorp \
	rbibutils

# packages from GitHub
R -e 'remotes::install_github("ropensci/crevents", dependencies = TRUE)'
#R -e 'remotes::install_github("ropensci/refsplitr", dependencies = TRUE)'

# clean up
rm -rf /var/lib/apt/lists/*


