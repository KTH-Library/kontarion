#!/bin/bash
set -e

# install research_info app as default shiny server application

cd /srv/shiny-server
rm -rf *

mkdir -p /var/lib/shiny-server/bookmarks/shiny

mkdir -p /srv/shiny-server/app_cache/sass
#chown -R shiny:shiny /srv/shiny-server/app_cache

mkdir -p /home/shiny/.local/share/AzureR
chown -R shiny:shiny /home/shiny/.local/share/AzureR

chown -R shiny:shiny /var/log/shiny-server
chmod -R o+w /var/lib/shiny-server/ /var/log/shiny-server/
chmod -R o+r /srv/shiny-server/ /opt/shiny-server/ /etc/shiny-server/

chmod -R o+wr /usr/local/lib/R/site-library/bibliotools/shiny/research_info
cp -r /usr/local/lib/R/site-library/bibliotools/shiny/research_info/* /srv/shiny-server

chown -R shiny:shiny /srv/shiny-server
