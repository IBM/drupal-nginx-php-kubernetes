#!/bin/bash
set -e

# This is the mount point for the shared volume.
# By default the mount point is owned by the root user.
MOUNTPATH="/content/uploads"
WWW_USER=${WWW_USER:-"www"}

# This function creates a subdirectory that is owned by
# the non-root user under the shared volume mount path.
create_data_dir() {
  #Add the non-root user to primary group of root user.
  usermod -aG root $WWW_USER

  # Provide read-write-execute permission to the group for the shared volume mount path.
  mkdir -p $MOUNTPATH
  chmod 775 $MOUNTPATH

  # Create a directory under the shared path owned by non-root user www.
  su -c "mkdir -p ${MOUNTPATH}/data" -l $WWW_USER
  su -c "chmod 777 ${MOUNTPATH}/data" -l $WWW_USER
  ls -al ${MOUNTPATH}

  # For security, remove the non-root user from root user group.
  deluser $WWW_USER root

  # Change the shared volume mount path back to its original read-write-execute permission.
  chmod 755 $MOUNTPATH
  echo "Created Data directory..."
}

create_data_dir
