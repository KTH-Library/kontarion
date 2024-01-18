#!/bin/bash
set -e

# install quarto
curl -o quarto-linux-amd64.deb -L https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.545/quarto-1.4.545-linux-amd64.deb
gdebi --non-interactive quarto-linux-amd64.deb
