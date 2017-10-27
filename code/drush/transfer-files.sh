#!/bin/bash

# rsync from source to destination
rsync -av /var/www/drupal/web/sites/default/files-prd/ /var/www/drupal/web/sites/default/files-stg
