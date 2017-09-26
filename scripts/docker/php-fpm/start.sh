#!/bin/bash
set -e

# This is the mount point for the shared volume.
# By default the mount point is owned by the root user.
MOUNT_PATH="/content/uploads"
TEMP_USER=${TEMP_USER:-"temp_user"}

# This function creates a subdirectory that is owned by
# the non-root user under the shared volume mount path.
create_data_dir() {
  #Add the non-root user to primary group of root user.
  usermod -aG root $TEMP_USER

  # Provide read-write-execute permission to the group for the shared volume mount path.
  chmod 777 $MOUNT_PATH

  # Create a directory under the shared path owned by non-root user www.
  su -c "mkdir -p ${MOUNT_PATH}/data" -l $TEMP_USER
  su -c "chmod -R 777 ${MOUNT_PATH}/data" -l $TEMP_USER
  ls -al ${MOUNT_PATH}

  # For security, remove the non-root user from root user group.
  deluser $TEMP_USER root

  # Change the shared volume mount path back to its original read-write-execute permission.
  chmod 755 $MOUNT_PATH
  echo "Created Data directory..."
}

create_data_dir

php-fpm
