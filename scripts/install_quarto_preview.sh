#!/bin/bash
set -e

# install quarto
curl -o quarto-linux-amd64.deb -L https://github.com/quarto-dev/quarto-cli/releases/download/v1.5.57/quarto-1.5.57-linux-amd64.deb
gdebi --non-interactive quarto-linux-amd64.deb
