#!/bin/bash

# Read the version from the VERSION file
version=$(<VERSION)

# Wrap up the package contents into a tarball
mkdir -p split-tunnel-ovpn-${version}
cp -r usr/ split-tunnel-ovpn-${version}
cp -r etc/ split-tunnel-ovpn-${version}
tar -czf split-tunnel-ovpn-${version}.tar.gz split-tunnel-ovpn-${version}
rm ./split-tunnel-ovpn-${version}/ -r