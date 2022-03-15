# R v 4 + python 3, Tensorflow, tidyverse, devtools, verse (tex and publishing related tools)
FROM rocker/ml-verse:4.1.2

RUN echo 'options(repos = c(CRAN = "https://packagemanager.rstudio.com/cran/__linux__/focal/latest"))' >> ${R_HOME}/etc/Rprofile.site && \
	R -e 'source("https://docs.rstudio.com/rspm/1.1.4/admin/check-user-agent.R")'

# Shiny server
ENV SHINY_SERVER_VERSION 1.5.17.973
RUN /rocker_scripts/install_shiny_server.sh

# RStudio
#RUN /rocker_scripts/install_rstudio.sh

# ccache
COPY rocker_scripts/install_ccache.sh /rocker_scripts/install_ccache.sh

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

# Python for bibliometrics
COPY rocker_scripts/install_conda.sh /rocker_scripts/install_conda.sh
#RUN /rocker_scripts/install_conda.sh

# R packages for bibliometrics
COPY rocker_scripts/install_bibliometrics.sh /rocker_scripts/install_bibliometrics.sh
RUN /rocker_scripts/install_bibliometrics.sh

# Shiny server customization
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY shiny-server.sh /usr/bin/shiny-server.sh
COPY rserver.conf /etc/rstudio/rserver.conf
COPY login.html /etc/rstudio/login.html

# R packages for bibliomatrix@KTH
COPY rocker_scripts/install_bibliomatrix.sh /rocker_scripts/install_bibliomatrix.sh
RUN /rocker_scripts/install_bibliomatrix.sh

# add GITHUB_PAT due to rate limiting kicking in when installing packages
ARG GITHUB_PAT= 
ENV GITHUB_PAT=$GITHUB_PAT

# preinstall bibliomatrix@KTH shinyapps into shiny server
COPY rocker_scripts/install_shinyapps.sh /rocker_scripts/install_shinyapps.sh
RUN /rocker_scripts/install_shinyapps.sh

# preinstall plumberish libs
COPY rocker_scripts/install_apitools.sh /rocker_scripts/install_apitools.sh
RUN /rocker_scripts/install_apitools.sh

RUN rm ~/.Renviron

# update rstudio
#RUN RSTUDIO_VERSION="daily" /rocker_scripts/install_rstudio.sh

# install S3 client (minio client)
COPY rocker_scripts/install_minio.sh /rocker_scripts/install_minio.sh
RUN /rocker_scripts/install_minio.sh

EXPOSE 8888
EXPOSE 3838

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]

# NB: if running with the shiny server, launch using this command: /usr/bin/shiny-server.sh
# NB: if running loadtest, launch using this command: "init"
