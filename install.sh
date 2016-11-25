#!/usr/bin/env bash

set -x
set -e

# For vars like PACKAGE_NAME, PACKAGE_VERSION
source ./dkms.conf

# Delete old package
rm -rf /var/lib/dkms/"$PACKAGE_NAME" || :

# Add ourselves to /var/lib/dkms
dkms add .

# Build module
dkms build -m "$PACKAGE_NAME" -v "$PACKAGE_VERSION"

# Build module
dkms install -m "$PACKAGE_NAME" -v "$PACKAGE_VERSION"

# Make our module override default psmouse, see man depmod.d
cat > /lib/depmod.d/"$PACKAGE_NAME".conf <<EOF
override psmouse $(uname -r) updates
EOF

# Remove current module
rmmod psmouse || :

# Insert new modulo
modprobe -v psmouse