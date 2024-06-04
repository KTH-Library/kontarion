# R v 4.4 + python 3, Tensorflow, tidyverse, devtools, verse (tex and publishing related tools)
FROM rocker/ml-verse:4.4.0

# add GITHUB_PAT due to rate limiting kicking in when installing packages
ARG GITHUB_PAT=
ENV GITHUB_PAT=$GITHUB_PAT

#COPY scripts /rocker_scripts

# install S3 client (minio client)
COPY rocker_scripts/install_minio.sh /rocker_scripts/install_minio.sh
RUN /rocker_scripts/install_minio.sh

RUN echo 'options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/jammy/latest"))' >> ${R_HOME}/etc/Rprofile.site && \
	R -e 'source("https://docs.posit.co/rspm/admin/check-user-agent.R")'

# Shiny server, for latest version either open https://posit.co/download/shiny-server/
# or find the latest version using "Rscript rocker_scripts/shiny_server_versions.R"
COPY rocker_scripts/install_shiny_server.sh /rocker_scripts/install_shiny_server.sh
ENV SHINY_SERVER_VERSION 1.5.23.1020
RUN /rocker_scripts/install_shiny_server.sh

# Shiny server customization
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY shiny-server.sh /usr/bin/shiny-server.sh
COPY rserver.conf /etc/rstudio/rserver.conf
COPY login.html /etc/rstudio/login.html

# ccache, MS SQL Server ODBC, "tini" zombie reaper, load testing tools, conda etc
COPY rocker_scripts/install_conda.sh /rocker_scripts/install_conda.sh
COPY rocker_scripts/install_ccache.sh /rocker_scripts/install_ccache.sh
COPY rocker_scripts/install_msodbc17.sh /rocker_scripts/install_msodbc17.sh
COPY rocker_scripts/install_msodbc18.sh /rocker_scripts/install_msodbc18.sh
COPY rocker_scripts/install_tini.sh /rocker_scripts/install_tini.sh
COPY rocker_scripts/install_shinytools.sh /rocker_scripts/install_shinytools.sh
COPY rocker_scripts/install_openldap.sh /rocker_scripts/install_openldap.sh

RUN /rocker_scripts/install_openldap.sh
RUN /rocker_scripts/install_msodbc17.sh
RUN /rocker_scripts/install_msodbc18.sh
RUN /rocker_scripts/install_tini.sh
RUN /rocker_scripts/install_shinytools.sh

# preinstall plumberish libs
COPY rocker_scripts/install_apitools.sh /rocker_scripts/install_apitools.sh
RUN /rocker_scripts/install_apitools.sh

# R packages for bibliometrics
COPY rocker_scripts/install_bibliometrics.sh /rocker_scripts/install_bibliometrics.sh
RUN /rocker_scripts/install_bibliometrics.sh

# R packages for bibliomatrix@KTH
COPY rocker_scripts/install_bibliomatrix.sh /rocker_scripts/install_bibliomatrix.sh
RUN /rocker_scripts/install_bibliomatrix.sh

COPY rocker_scripts/install_utils.sh /rocker_scripts/install_utils.sh
RUN /rocker_scripts/install_utils.sh

# preinstall bibliomatrix@KTH shinyapps into shiny server
COPY rocker_scripts/install_shinyapps.sh /rocker_scripts/install_shinyapps.sh
RUN /rocker_scripts/install_shinyapps.sh

COPY rocker_scripts/install_quarto_preview.sh /rocker_scripts/install_quarto_preview.sh
RUN /rocker_scripts/install_quarto_preview.sh

RUN rm ~/.Renviron

# preinstall CA cert in trust store

COPY rocker_scripts/install_ca_cert.sh /rocker_scripts/install_ca_cert.sh
RUN /rocker_scripts/install_ca_cert.sh

EXPOSE 8888
EXPOSE 3838

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]

# NB: if running with the shiny server, launch using this command: /usr/bin/shiny-server.sh
# NB: if running rstudio web IDE (for loadtest etc), launch using this command: "/init"
