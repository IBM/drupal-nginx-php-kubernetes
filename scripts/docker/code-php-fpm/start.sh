#!/bin/bash
set -e

# Now that the volume is mounted, change owner and make it read/write
chown www-data:www-data /var/www/drupal/web/sites/default/files
chmod -R 777 /var/www/drupal/web/sites/default/files

# Do this one too while we're at it (could be done in Dockerfile)
mkdir -p /var/www/drupal/config/sync
chown www-data:www-data /var/www/drupal/config/sync
chmod -R 777 /var/www/drupal/config/sync

# Now that volume is usable by non-root user, start up PHP on port 9000
php-fpm
