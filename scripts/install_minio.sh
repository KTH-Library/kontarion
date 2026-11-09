#!/bin/bash
set -e

# install minio client
#
# MinIO's own dl.min.io/{client,aistor}/mc download paths have both gone
# dead (410 Gone) since MinIO deprecated the mc client in favor of their
# AIStor product; pgsty/mc is a maintained fork (binary name "mcli"),
# installed here as "mc" to stay a drop-in replacement
cd /usr/local/bin && \
  wget -qO- https://github.com/pgsty/mc/releases/download/RELEASE.2026-11-09T00-00-00Z/mcli_20261109000000.0.0_linux_amd64.tar.gz | \
  tar xz mcli && \
  mv mcli mc && \
  chmod +x mc
