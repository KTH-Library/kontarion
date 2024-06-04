#!/bin/bash
set -e

# install bibcap apps (excluding research_info) in default shiny server application dir

cd /srv/shiny-server
rm -rf *

mkdir -p /var/lib/shiny-server/bookmarks/shiny

mkdir -p /srv/shiny-server/app_cache/sass

mkdir -p /home/shiny/.local/share/AzureR
chown -R shiny:shiny /home/shiny/.local/share/AzureR

chown -R shiny:shiny /var/log/shiny-server
chmod -R o+w /var/lib/shiny-server/ /var/log/shiny-server/
chmod -R o+r /srv/shiny-server/ /opt/shiny-server/ /etc/shiny-server/

chmod -R o+wr /usr/local/lib/R/site-library/bibliotools/shiny
cp -r /usr/local/lib/R/site-library/bibliotools/shiny/* /srv/shiny-server
rm -rf /srv/shiny-server/research_info

chown -R shiny:shiny /srv/shiny-server

#NOTE: start with "/usr/bin/shiny-server.sh && /init" after these steps...
