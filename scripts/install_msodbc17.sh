#!/bin/sh
set -e

# Dependency scripts to run first
#. /rocker_scripts/install_s6init.sh

# MS ODBC v 17 installation, adapted from ...
# https://learn.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?

# the microsoft.asc key alone no longer matches the signing key on newer Ubuntu
# releases' repos (key rotation) - the packages-microsoft-prod.deb bundles the
# current keyring + sources.list entry together, per MS's current install docs
curl -sSL "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" -o /tmp/packages-microsoft-prod.deb
dpkg -i /tmp/packages-microsoft-prod.deb
rm /tmp/packages-microsoft-prod.deb

# mssql odbc driver v 17 and tools (bcp, sqlcmd, unixODBC dev headers)
apt-get update

ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
	msodbcsql17 \
	mssql-tools \
	unixodbc-dev

echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

# R packages
install2.r --error --skipinstalled odbc

# clean up
rm -rf /var/lib/apt/lists/*
