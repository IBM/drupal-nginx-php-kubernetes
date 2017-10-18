#!/bin/bash
set -e

# Inspect all the files in config and extract into env variables
set -o allexport
for file in ../../config/*.txt
do
  source $file
done
set +o allexport

BUILD_NUMBER=$( date +%s )

echo $NGINX_VERSION
echo $PHP_FPM_VERSION
echo $PHP_CLI_VERSION

# Build each image and push
ROOT_DIR=`pwd`

# Log into the Bluemix Container Registry
bx cr login

# Build the NGINX image (configure Fast CGI)
cd ../docker/config-nginx
docker build \
  --tag registry.ng.bluemix.net/jjdojo/config-nginx-${NGINX_VERSION}:${BUILD_NUMBER} \
  --tag registry.ng.bluemix.net/jjdojo/config-nginx-${NGINX_VERSION}:latest \
  --build-arg NGINX_VERSION=${NGINX_VERSION} \
  .
# --no-cache \
docker push registry.ng.bluemix.net/jjdojo/config-nginx-${NGINX_VERSION}:latest

# Move back to ROOT_DIR
cd $ROOT_DIR

# Build the PHP-FPM image (base image, inject code, run composer)
cd ../docker/config-php-fpm
docker build \
  --tag registry.ng.bluemix.net/jjdojo/config-php-fpm-${PHP_FPM_VERSION}:${BUILD_NUMBER} \
  --tag registry.ng.bluemix.net/jjdojo/config-php-fpm-${PHP_FPM_VERSION}:latest \
  --build-arg PHP_FPM_VERSION=${PHP_FPM_VERSION} \
  .
docker push registry.ng.bluemix.net/jjdojo/config-php-fpm-${PHP_FPM_VERSION}:latest

# Move back to ROOT_DIR
cd $ROOT_DIR

# Build the PHP-FPM image (base image, inject code, run composer)
cd ../docker/config-php-cli
docker build \
  --tag registry.ng.bluemix.net/jjdojo/config-php-cli-${PHP_CLI_VERSION}:${BUILD_NUMBER} \
  --tag registry.ng.bluemix.net/jjdojo/config-php-cli-${PHP_CLI_VERSION}:latest \
  --build-arg PHP_CLI_VERSION=${PHP_CLI_VERSION} \
  .
docker push registry.ng.bluemix.net/jjdojo/config-php-cli-${PHP_CLI_VERSION}:latest
# Move back to ROOT_DIR
cd $ROOT_DIR

# TODO: invoke ./build-on-code-change.sh with env params
