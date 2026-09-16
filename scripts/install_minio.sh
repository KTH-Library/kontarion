#!/bin/bash
set -e

# install minio client
cd /usr/local/bin && \
  wget -q https://dl.min.io/aistor/mc/release/linux-amd64/mc && \
  chmod +x mc
