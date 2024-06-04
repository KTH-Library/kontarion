# R v 4.4 + python 3, Tensorflow, tidyverse, devtools, verse (tex and publishing related tools)
FROM ghcr.io/rocker-org/ml-verse:4.4

# add GITHUB_PAT due to rate limiting kicking in when installing packages
ARG GITHUB_PAT=
ENV GITHUB_PAT=$GITHUB_PAT

# install S3 client (minio client)
COPY scripts/install_minio.sh /rocker_scripts/install_minio.sh
RUN /rocker_scripts/install_minio.sh

RUN echo 'options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/jammy/latest"))' >> ${R_HOME}/etc/Rprofile.site && \
	R -e 'source("https://docs.posit.co/rspm/admin/check-user-agent.R")'

# Shiny server, for latest version either open https://posit.co/download/shiny-server/
# or find the latest version using "Rscript scripts/shiny_server_versions.R"
COPY install_shiny_server.sh /rocker_scripts/install_shiny_server.sh
ENV SHINY_SERVER_VERSION 1.5.23.1020
RUN /rocker_scripts/install_shiny_server.sh

# Shiny server customization
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY shiny-server.sh /usr/bin/shiny-server.sh
COPY rserver.conf /etc/rstudio/rserver.conf
COPY login.html /etc/rstudio/login.html

# ccache, MS SQL Server ODBC, "tini" zombie reaper, load testing tools, conda etc
COPY scripts/install_conda.sh /rocker_scripts/install_conda.sh
COPY scripts/install_ccache.sh /rocker_scripts/install_ccache.sh
COPY scripts/install_msodbc17.sh /rocker_scripts/install_msodbc17.sh
COPY scripts/install_msodbc18.sh /rocker_scripts/install_msodbc18.sh
COPY scripts/install_tini.sh /rocker_scripts/install_tini.sh
COPY scripts/install_shinytools.sh /rocker_scripts/install_shinytools.sh
COPY scripts/install_openldap.sh /rocker_scripts/install_openldap.sh

RUN /rocker_scripts/install_openldap.sh
RUN /rocker_scripts/install_msodbc17.sh
RUN /rocker_scripts/install_msodbc18.sh
RUN /rocker_scripts/install_tini.sh
RUN /rocker_scripts/install_shinytools.sh

# preinstall plumberish libs
COPY scripts/install_apitools.sh /rocker_scripts/install_apitools.sh
RUN /rocker_scripts/install_apitools.sh

# R packages for bibliometrics
COPY scripts/install_bibliometrics.sh /rocker_scripts/install_bibliometrics.sh
RUN /rocker_scripts/install_bibliometrics.sh

# R packages for bibliomatrix@KTH
COPY scripts/install_bibliomatrix.sh /rocker_scripts/install_bibliomatrix.sh
RUN /rocker_scripts/install_bibliomatrix.sh

COPY scripts/install_utils.sh /rocker_scripts/install_utils.sh
RUN /rocker_scripts/install_utils.sh

# preinstall bibliomatrix@KTH shinyapps into shiny server
COPY scripts/install_shinyapps.sh /rocker_scripts/install_shinyapps.sh
RUN /rocker_scripts/install_shinyapps.sh

COPY scripts/install_quarto_preview.sh /rocker_scripts/install_quarto_preview.sh
RUN /rocker_scripts/install_quarto_preview.sh

RUN rm ~/.Renviron

# preinstall CA cert in trust store

COPY scripts/install_ca_cert.sh /rocker_scripts/install_ca_cert.sh
RUN /rocker_scripts/install_ca_cert.sh

# avoid cache hit if none of the above scripts have been altered
COPY scripts /rocker_scripts

EXPOSE 8888
EXPOSE 3838

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]

# NB: if running with the shiny server, launch using this command: /usr/bin/shiny-server.sh
# NB: if running rstudio web IDE (for loadtest etc), launch using this command: "/init"
