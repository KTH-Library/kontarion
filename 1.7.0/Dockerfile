# R v 4 + python 3, Tensorflow, tidyverse, devtools, verse (tex and publishing related tools)
FROM rocker/ml-verse:4.0.2 

# Shiny server
ENV SHINY_SERVER_VERSION 1.5.14.948
RUN /rocker_scripts/install_shiny_server.sh

# RStudio
RUN /rocker_scripts/install_rstudio.sh

#COPY rocker_scripts/ /rocker_scripts/
COPY rocker_scripts/install_msodbc17.sh /rocker_scripts/install_msodbc17.sh
COPY rocker_scripts/install_tini.sh /rocker_scripts/install_tini.sh
COPY rocker_scripts/install_shinytools.sh /rocker_scripts/install_shinytools.sh

# ODBC driver for MS SQL Server
RUN /rocker_scripts/install_msodbc17.sh

# "tini" zombie reaper for containers
RUN /rocker_scripts/install_tini.sh

# Shiny tools for load testing etc
RUN /rocker_scripts/install_shinytools.sh

# Shiny server customization
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY shiny-server.sh /usr/bin/shiny-server.sh
COPY rserver.conf /etc/rstudio/rserver.conf
COPY login.html /etc/rstudio/login.html

# R packages for bibliometrics
COPY rocker_scripts/install_bibliometrics.sh /rocker_scripts/install_bibliometrics.sh
RUN /rocker_scripts/install_bibliometrics.sh

# Python for bibliometrics
COPY rocker_scripts/install_conda.sh /rocker_scripts/install_conda.sh
RUN /rocker_scripts/install_conda.sh

EXPOSE 8888
EXPOSE 3838

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]

# NB: if running with the shiny server, launch using this command: /usr/bin/shiny-server.sh
# NB: if running loadtest, launch using this command: "init"
