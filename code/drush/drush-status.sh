#!/bin/bash

# Connect to the local Drupal environment and run a Drush commands
echo "Running user login on the PHP-FPM container."
cd /root/drush/sites/default/
drush --version

echo "Dumping environment."
drush status

echo "Executing user login command."
drush user-login
