FROM ghcr.io/kth-library/kontarion:latest

# add GITHUB_PAT due to rate limiting kicking in when installing packages
ARG GITHUB_PAT= 
ENV GITHUB_PAT=$GITHUB_PAT

COPY rocker_scripts/install_bibliotools.sh /rocker_scripts/install_bibliotools.sh
RUN /rocker_scripts/install_bibliotools.sh
