#!/bin/bash
set -e

# Update config file for the environment.
echo $ENV
sed -i "s/php-fpm/php-fpm-${ENV}/g" /etc/nginx/conf.d/fastcgi.conf

# Now that volume is usable by non-root user, start up PHP on port 9000
nginx -g "daemon off;"
