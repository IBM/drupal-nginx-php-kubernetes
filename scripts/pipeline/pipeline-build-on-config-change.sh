#!/bin/bash
set -e

# Inspect all the files in config and extract into env variables
set -o allexport
source ../../config/$IMAGE-version.txt
set +o allexport

echo "IMAGE = ${IMAGE}"

case "$IMAGE" in
  "nginx")
    VERSION=$NGINX_VERSION
    ;;
  "php-cli")
    VERSION=$PHP_CLI_VERSION
    ;;
  "php-fpm")
    VERSION=$PHP_FPM_VERSION
    ;;
esac

echo "${IMAGE} version = ${VERSION}"

# Build each image and push
ROOT_DIR=`pwd`

UPCASE_IMAGE=${IMAGE^^}


# Build the NGINX image (configure Fast CGI)
cd ../docker/config-$IMAGE
bx cr build \
  --tag registry.ng.bluemix.net/${REGISTRY_NAMESPACE}/config-${IMAGE}:${VERSION} \
  --build-arg ${UPCASE_IMAGE//-/_}_VERSION=${VERSION} \
  .
# --no-cache \
#docker push registry.ng.bluemix.net/${REGISTRY_NAMESPACE}/config-${IMAGE}:latest

echo "Done with config build"

# Move back to ROOT_DIR
cd $ROOT_DIR
