#!/bin/bash
set -e

# Run dependency scripts
#. /rocker_scripts/install_python.sh

# conda

apt-get update && apt-get install -y --no-install-recommends \
	apt-transport-https \
	apt-utils \
	mercurial \
	subversion

export PATH=/opt/conda/bin:$PATH

wget --quiet https://repo.anaconda.com/archive/Anaconda3-2022.10-Linux-aarch64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc
    
source ~/.bashrc

# Python packages for bibliometrics

pip install --upgrade pip
pip install pybliometrics
