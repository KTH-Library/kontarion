#!/bin/bash
set -e

apt-get -y update && apt-get install -y --no-install-recommends \
	apache2-utils  # for ab (apache benchmark tool)

# shinycannon, shinyloadtest, shinytest

export TMPDIR=/tmp/cannon 

mkdir -p $TMPDIR

cd $TMPDIR && \
	wget https://s3.amazonaws.com/rstudio-shinycannon-build/2019-11-22-20:24:21_1.0.0-9b22a92/deb/shinycannon_1.0.0-9b22a92_amd64.deb && \
	dpkg -i shinycannon_1.0.0-9b22a92_amd64.deb && \
	rm shinycannon_1.0.0-9b22a92_amd64.deb && cd ..

R -e "remotes::install_github('rstudio/shinyloadtest')"

install2.r --error --skipinstalled \
	RSelenium \
	shinytest

# clean up	
rm -rf $TMPDIR
rm -rf /var/lib/apt/lists/*


