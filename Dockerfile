# R 4.6 + python 3, Tensorflow (rocker-org/ml, Ubuntu 26.04); tidyverse, devtools,
# verse (tex and publishing related tools) layered on top below, since ml-verse
# is no longer maintained (see scripts/install_tidyverse.sh / install_verse.sh)
#
# Pinned by digest rather than a moving tag (rocker-org/ml has no per-R-version
# tags anymore, just `latest`/`py3.14`); to pick up a newer build, look up the
# current digest via: skopeo inspect docker://ghcr.io/rocker-org/ml:latest
FROM ghcr.io/rocker-org/ml@sha256:271af40d7db0f25c678d246b5096249b5f9d5c7a35d923cde9a98b4f164eca38

# rocker-org/ml defaults to USER jovyan (uid 1000, Jupyter convention); ml-verse
# built as root, and the install scripts below (apt-get, writes to /usr/local,
# /rocker_scripts etc.) all assume root, so restore that
USER root

# rocker-org/ml ships with pre-populated (and by now stale) /var/lib/apt/lists/,
# baked in at its own build time; every install_*.sh script here uses a helper
# that only runs `apt-get update` when that dir is empty (an optimization that
# assumed a base image without pre-baked lists), so the very first apt-touching
# script would otherwise silently use stale metadata - force a fresh one now
RUN apt-get update

# add GITHUB_PAT due to rate limiting kicking in when installing packages
ARG GITHUB_PAT=
ENV GITHUB_PAT=$GITHUB_PAT

# install S3 client (minio client)
COPY scripts/install_minio.sh /rocker_scripts/install_minio.sh
RUN /rocker_scripts/install_minio.sh

# PPM already serves binaries for 26.04 "resolute" (r2u's resolute support is
# still preview-only, so PPM stays the safer choice for now)
RUN echo 'options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/resolute/latest"))' >> ${R_HOME}/etc/Rprofile.site && \
	R -e 'source("https://docs.posit.co/rspm/admin/check-user-agent.R")'

# tidyverse, devtools, and verse (LaTeX/TinyTeX + rticles/bookdown/blogdown) —
# bundled by ml-verse but not by rocker-org/ml, so reinstated here
COPY scripts/install_tidyverse.sh /rocker_scripts/install_tidyverse.sh
RUN /rocker_scripts/install_tidyverse.sh
COPY scripts/install_texlive.sh /rocker_scripts/install_texlive.sh
COPY scripts/install_verse.sh /rocker_scripts/install_verse.sh
RUN /rocker_scripts/install_verse.sh

# Shiny server, for latest version either open https://posit.co/download/shiny-server/
# or find the latest version using "Rscript scripts/shiny_server_versions.R"
#
# install_shiny_server.sh calls install_s6init.sh and install_pandoc.sh, which
# ml-verse used to bake into /rocker_scripts/ already; rocker-org/ml ships no
# /rocker_scripts/ at all, so they're vendored here too
COPY scripts/install_s6init.sh /rocker_scripts/install_s6init.sh
COPY scripts/install_pandoc.sh /rocker_scripts/install_pandoc.sh
COPY scripts/init_set_env.sh /rocker_scripts/init_set_env.sh
COPY scripts/install_shiny_server.sh /rocker_scripts/install_shiny_server.sh
ENV SHINY_SERVER_VERSION 1.5.23.1030
# NB: this is the Shiny Server .deb's own build-path tag, unrelated to this
# image's actual Ubuntu version (26.04) — 1.5.23.1030 was published under
# ubuntu-20.04; check the actual published path before bumping either version
ENV UBUNTU_VERSION 20.04
# rocker-org/ml's interactive/login user is "jovyan" (Jupyter convention);
# "rstudio-server" here is only a uid-999 service account, not a login user
ENV DEFAULT_USER jovyan
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
