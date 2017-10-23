#!/bin/bash
set -e

# Inspect all the files in config and extract into env variables
set -o allexport
for file in ../../config/*.txt
do
  source $file
done
set +o allexport

echo $NGINX_VERSION
echo $PHP_FPM_VERSION
echo $PHP_CLI_VERSION

# Build each image and push
ROOT_DIR=`pwd`

# Log into the Bluemix Container Registry
bx cr login

# Purge all existing images
# bx cr image-rm $(bx cr images -q)

# Build the NGINX image (configure Fast CGI)
cd ../docker/config-nginx
docker build \
  --tag registry.ng.bluemix.net/orod/config-nginx:${NGINX_VERSION} \
  --tag registry.ng.bluemix.net/orod/config-nginx:latest \
  --build-arg NGINX_VERSION=${NGINX_VERSION} \
  .
# --no-cache \
docker push registry.ng.bluemix.net/orod/config-nginx:latest

# Move back to ROOT_DIR
cd $ROOT_DIR

# Build the PHP-FPM image (base image, inject code, run composer)
cd ../docker/config-php-fpm
docker build \
  --tag registry.ng.bluemix.net/orod/config-php-fpm:${PHP_FPM_VERSION} \
  --tag registry.ng.bluemix.net/orod/config-php-fpm:latest \
  --build-arg PHP_FPM_VERSION=${PHP_FPM_VERSION} \
  .
docker push registry.ng.bluemix.net/orod/config-php-fpm:latest

# Move back to ROOT_DIR
cd $ROOT_DIR

# Build the PHP-FPM image (base image, inject code, run composer)
cd ../docker/config-php-cli
docker build \
  --tag registry.ng.bluemix.net/orod/config-php-cli:${PHP_CLI_VERSION} \
  --tag registry.ng.bluemix.net/orod/config-php-cli:latest \
  --build-arg PHP_CLI_VERSION=${PHP_CLI_VERSION} \
  .
docker push registry.ng.bluemix.net/orod/config-php-cli:latest
# Move back to ROOT_DIR
cd $ROOT_DIR

# TODO: invoke ./build-on-code-change.sh with env params
./build-on-code-change.sh
