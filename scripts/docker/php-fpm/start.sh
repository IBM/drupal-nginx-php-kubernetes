#!/bin/bash
set -e

# Configure the read/write volume for a non-root user
groupadd --gid 1010 temp_user
useradd --uid 1010 --gid 1010 -m --shell /bin/bash temp_user
TEMP_USER=temp_user

# This is the mount point for the shared volume.
# By default the mount point is owned by the root user.
MOUNT_PATH="/var/www/html"
TEMP_USER=${TEMP_USER:-"temp_user"}

# Debug
echo "MOUNT_PATH is ${MOUNT_PATH}"
echo "TEMP_USER is ${TEMP_USER}"

echo "DRUPAL_VERSION is ${DRUPAL_VERSION}"
echo "DRUPAL_MD5 is ${DRUPAL_MD5}"

# This function creates a subdirectory that is owned by
# the non-root user under the shared volume mount path.
create_data_dir() {
  # Add the non-root user to primary group of root user.
  usermod -aG root $TEMP_USER

  # Provide read-write-execute permission to the group for the shared volume mount path.
  chmod 777 $MOUNT_PATH

  cd $MOUNT_PATH
  pwd

  echo "ls -al before"
  ls -al ${MOUNT_PATH}

  #echo "Installing Drupal"
  #cp -R /tmp/drupal*/* ${MOUNT_PATH}

  #echo "Deleting old files"
  #rm -rf /tmp/drupal*

  # Change permissions on the folders for the non-root user.
  echo "Changing directory permissions"
  chmod -R 777 ${MOUNT_PATH}/sites
  chmod -R 777 ${MOUNT_PATH}/modules
  chmod -R 777 ${MOUNT_PATH}/themes

  echo "Changing directory owners"
  echo $TEMP_USER
  echo ${MOUNT_PATH}/sites
  chown -R $TEMP_USER ${MOUNT_PATH}/sites
  chown -R $TEMP_USER ${MOUNT_PATH}/modules
  chown -R $TEMP_USER ${MOUNT_PATH}/themes

  echo "Copy back Drupal files to the mount point"
  cp -R /tmp/sites/* ${MOUNT_PATH}/sites/
  cp -R /tmp/modules/* ${MOUNT_PATH}/modules/
  cp -R /tmp/themes/* ${MOUNT_PATH}/themes/

  echo "ls -al after"
  ls -al ${MOUNT_PATH}

  echo "Update settings template with env variables"
  sed -i "s/MYSQL_NAME/${MYSQL_NAME}/g" /root/default.settings.php
  sed -i "s/MYSQL_USER/${MYSQL_USER}/g" /root/default.settings.php
  sed -i "s/MYSQL_PASS/${MYSQL_PASS}/g" /root/default.settings.php
  sed -i "s/MYSQL_HOST/${MYSQL_HOST}/g" /root/default.settings.php
  sed -i "s/MYSQL_PORT/${MYSQL_PORT}/g" /root/default.settings.php
  cp /root/default.settings.php ${MOUNT_PATH}/sites/default/settings.php

  # For security, remove the non-root user from root user group.
  echo "Removing user from group"
  deluser $TEMP_USER root

  # Change the shared volume mount path back to its original read-write-execute permission.
  echo "Resetting parent directory permissions"
  chmod 755 $MOUNT_PATH

  echo "Created Data directory..."
}

create_data_dir

# Now that volume is usable by non-root user, start up PHP on port 9000
php-fpm
