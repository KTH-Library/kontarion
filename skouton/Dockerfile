FROM ghcr.io/kth-library/kontarion:latest

# add GITHUB_PAT due to rate limiting kicking in when installing packages
ARG GITHUB_PAT= 
ENV GITHUB_PAT=$GITHUB_PAT

COPY scripts/install_bibliotools.sh /rocker_scripts/install_bibliotools.sh
RUN /rocker_scripts/install_bibliotools.sh

# overwrite shiny server default app installation
COPY scripts/install_research_info.sh /rocker_scripts/install_research_info.sh
RUN /rocker_scripts/install_research_info.sh

# avoid cache hit if none of the above scripts have been altered
COPY scripts /rocker_scripts

USER shiny
