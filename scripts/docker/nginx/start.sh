#!/bin/bash
set -e

# Move any files now that the volume is mounted.
# cp /root/html/index.html /var/www/html/

# Now that volume is usable, start up NGINX on port 80
nginx -g "daemon off;";
