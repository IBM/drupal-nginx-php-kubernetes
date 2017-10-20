#!/bin/bash
set -e

# Inspect all the files in config and extract into env variables
set -o allexport
source ../../config/$IMAGE-version.txt
set +o allexport

case "$IMAGE" in
  "nginx")
    VERSION = $NGINX_VERSION
    ;;
  "php-cli")
    VERSION = $PHP_CLI_VERSION
    ;;
  "php-fpm")
    VERSION = $PHP_FPM_VERSION
    ;;
esac

echo "${IMAGE} version = ${VERSION}"

# if [ $IMAGE == "nginx" ] ; then
#   VERSION = $NGINX_VERSION
# elif [ $IMAGE == "php-cli" ] ; then
#   VERSION = $PHP_CLI_VERSION
# elif [ $IMAGE == "php-fpm" ] ; then
#   VERSION = $PHP_FPM_VERSION
#   echo "${IMAGE} version = ${VERSION}"
# fi

# Build each image and push
ROOT_DIR=`pwd`

# Build the NGINX image (configure Fast CGI)
cd ../docker/config-$IMAGE
docker build \
  --tag registry.ng.bluemix.net/${REPOSITORY_NAMESPACE}/config-${IMAGE}:${VERSION} \
  --tag registry.ng.bluemix.net/${REPOSITORY_NAMESPACE}/config-${IMAGE}:latest \
  --build-arg ${IMAGE}_VERSION=${VERSION} \
  .
# --no-cache \
docker push registry.ng.bluemix.net/${REPOSITORY_NAMESPACE}/config-${IMAGE}:latest

# Move back to ROOT_DIR
cd $ROOT_DIR
