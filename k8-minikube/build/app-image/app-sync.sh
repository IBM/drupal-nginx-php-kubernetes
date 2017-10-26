#!/usr/bin/env bash

echo "App Image Sidecar Container"
echo ""
echo "Copying application into shared volume."

# Todo, move over to rsync.
# todo: check target dir exists or error out.
# toto: use env var for source and target paths.
cp -R /app /www-data
