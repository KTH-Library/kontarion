#!/bin/bash
set -e

apt-get -y update && apt-get install -y --no-install-recommends \
	apache2-utils  # for ab (apache benchmark tool)

# shinycannon, shinyloadtest, shinytest

export TMPDIR=/tmp/cannon

mkdir -p $TMPDIR

cd $TMPDIR && \
	wget -O shinycannon.deb "https://github.com/rstudio/shinycannon/releases/download/v1.1.3/shinycannon_1.1.3-dd43f6b_amd64.deb" && \
	dpkg -i shinycannon.deb && \
	rm shinycannon.deb && cd ..

#R -e "remotes::install_github('rstudio/shinyloadtest')"

install2.r --error --skipinstalled \
	shinyloadtest \
	RSelenium \
	shinytest

# clean up
rm -rf $TMPDIR
rm -rf /var/lib/apt/lists/*
