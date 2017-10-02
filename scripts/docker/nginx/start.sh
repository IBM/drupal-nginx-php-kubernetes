#!/bin/bash
set -e

# Couldn't add this file at build time because the volume wasn't mounted
cp /root/html/index.html /var/www/html/

# Now that volume is usable, start up NGINX on port 80
nginx -g "daemon off;";
