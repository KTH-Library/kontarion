#!/bin/bash
set -e

# install minio client
cd /usr/local/bin && \
  wget -q --show-progress https://dl.min.io/client/mc/release/linux-amd64/mc && \
  chmod +x mc
