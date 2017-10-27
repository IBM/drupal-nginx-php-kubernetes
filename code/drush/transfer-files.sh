#!/bin/bash

# Copy production user generated files back to staging
rsync -av /var/www/drupal/web/sites/default/files-prd/ /var/www/drupal/web/sites/default/files-stg
