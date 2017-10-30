#!/usr/bin/env bash

echo "App Image Sidecar Container"
echo ""
echo "Copying application into shared volume."
echo ""

echo "Rsync source is: ${RSYNC_SOURCE}/"
echo "Rsync destination is: ${RSYNC_DEST}/"

# Rsync to destination and preserve symlinks and file perms.
rsync -vah "${RSYNC_SOURCE}/" "${RSYNC_DEST}"

# Keep the container alive.
echo ""
echo "Finished sync job, keeping container alive..."
echo ""
php /root/noop.php
