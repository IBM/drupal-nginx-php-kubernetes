#!/bin/bash
set -e

# Now that the volume is mounted, change owner and make it read/write
# TODO: Modify to only allow Drush and root to modify
chown www-data:www-data /var/www/drupal
chmod -R 777 /var/www/drupal
ls -Flat /var/www/drupal
echo "Drupal perms done"

# Now that the volume is mounted, change owner and make it read/write
chown www-data:www-data /var/www/drupal/web/sites/default/files
chmod -R 777 /var/www/drupal/web/sites/default/files
ls -Flat /var/www/drupal/web/sites/default/files
echo "Site perms done"

# Do this one too while we're at it (could be done in Dockerfile)
mkdir -p /var/www/drupal/config/sync
chown www-data:www-data /var/www/drupal/config/sync
chmod -R 777 /var/www/drupal/config/sync
ls -Flat /var/www/drupal/config/sync
echo "Config perms done"

# Install Composer
COMPOSER_ALLOW_SUPERUSER=1
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer
cp /tmp/var/www/drupal/composer.json .
composer install --no-scripts --no-autoloader
echo "Composer install done"

# Install Drupal if not already here
composer create-project drupal-composer/drupal-project:8.x /var/www/drupaltmp/ --stability dev --no-interaction
rsync -avz --ignore-existing /var/www/drupaltmp/ /var/www/drupal
echo "Drupal install done"

# Copy files over the Drupal install non-destructively
rsync -avz --ignore-existing /tmp/var/www/drupal/drush/composer.json /var/www/drupal/drush/composer.json
rsync -avz --ignore-existing /tmp/var/www/drupal/drush/composer.lock /var/www/drupal/drush/composer.lock
rsync -avz --ignore-existing /tmp/var/www/drupal/drush/ /var/www/drupal/drush
rsync -avz --ignore-existing /tmp/var/www/drupal/modules/ /var/www/drupal/modules
rsync -avz --ignore-existing /tmp/var/www/drupal/profiles/ /var/www/drupal/profiles
rsync -avz --ignore-existing /tmp/var/www/drupal/sites/ /var/www/drupal/sites
rsync -avz --ignore-existing /tmp/var/www/drupal/themes/ /var/www/drupal/themes

# The above uses the web subdirectory and default composer.json.
# To customize before install, you can take the following approach instead:
#   git clone https://github.com/drupal-composer/drupal-project.git my_site_name_dir
#   cd my_site_name_dir
#   vi composer.json to customize
#   composer install

# One way to do the initial setup.
# cd /var/www/drupal/web
# ../vendor/drush/drush/drush site-install standard \
#   --db-url=mysql://DBUSERNAME:DBPASSWORD@localhost/some_db \
#   --account-mail="admin@example.com" \
#   --account-name=admin \
#   --account-pass=some_admin_password \
#   --site-mail="admin@example.com" \
#   --site-name="Site-Install"

# Now that volume is usable by non-root user, start up PHP on port 9000
echo "Starting FPM"
php-fpm
