#!/bin/sh
set -e

# Dependency scripts to run first
#. /rocker_scripts/install_s6init.sh

# MS ODBC v 17 installation, adapted from ...
# https://learn.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?

curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list > /etc/apt/sources.list.d/mssql-release.list

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
