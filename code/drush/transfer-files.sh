#!/bin/bash

PRD_PERSISTENT_VOLUME=/var/www/drupal/web/sites/default/files-prd
STG_PERSISTENT_VOLUME=/var/www/drupal/web/sites/default/files-stg

# Copy production user generated files back to staging
echo "Synchronizing data from production ${PRD_PERSISTENT_VOLUME} to ${STG_PERSISTENT_VOLUME}."
rsync -av ${PRD_PERSISTENT_VOLUME}/ ${STG_PERSISTENT_VOLUME}
