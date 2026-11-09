#!/bin/bash
set -e

# install NVIDIA CUDA toolkit from NVIDIA's own apt repo, which now publishes
# packages natively for Ubuntu 26.04 "resolute" (kontarion's base OS) - so no
# separate rocker/cuda base image is needed, just layer this on top

cd /tmp
wget -q https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2604/x86_64/cuda-keyring_1.1-1_all.deb
dpkg -i cuda-keyring_1.1-1_all.deb
rm cuda-keyring_1.1-1_all.deb

apt-get update
apt-get install -y --no-install-recommends cuda-toolkit

rm -rf /var/lib/apt/lists/*
