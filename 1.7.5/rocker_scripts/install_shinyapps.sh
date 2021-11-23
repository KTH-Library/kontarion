#!/bin/bash
set -e

cd /srv/shiny-server
rm -rf * 
mkdir -p /var/lib/shiny-server/bookmarks/shiny
chown -R shiny.shiny /var/log/shiny-server
chmod -R o+w /var/lib/shiny-server/ /var/log/shiny-server/
chmod -R o+r /srv/shiny-server/ /opt/shiny-server/ /etc/shiny-server/

chmod -R o+wr /usr/local/lib/R/site-library/bibliomatrix/shiny-apps/abm/www/cache
ln -s /usr/local/lib/R/site-library/bibliomatrix/shiny-apps/abm/* /srv/shiny-server

apt-get update && apt-get install -y \
    xtail

rm -rf /var/lib/apt/lists/*

