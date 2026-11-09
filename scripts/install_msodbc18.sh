#!/bin/sh
set -e

# Dependency scripts to run first
#. /rocker_scripts/install_s6init.sh

# MS ODBC installation, adapted from ...
# https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server

# the microsoft.asc key alone no longer matches the signing key on newer Ubuntu
# releases' repos (key rotation) - the packages-microsoft-prod.deb bundles the
# current keyring + sources.list entry together, per MS's current install docs
curl -sSL "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" -o /tmp/packages-microsoft-prod.deb
dpkg -i /tmp/packages-microsoft-prod.deb
rm /tmp/packages-microsoft-prod.deb

#echo msodbcsql18 msodbcsql/ACCEPT_EULA boolean true | debconf-set-selections

# mssql odbc driver and tools (bcp, sqlcmd, unixODBC dev headers)
apt-get update
ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
	msodbcsql18 \
	mssql-tools18 \
	unixodbc-dev

echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc

# R packages
install2.r --error --skipinstalled odbc

# clean up
rm -rf /var/lib/apt/lists/*
