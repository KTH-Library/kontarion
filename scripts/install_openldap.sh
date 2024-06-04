#!/bin/bash
set -e

apt-get update && apt-get install -y \
	ldap-utils

apt-get clean

# clean up
rm -rf /var/lib/apt/lists/*
