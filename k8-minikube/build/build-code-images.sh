#!/bin/bash
set -e

# Inspect all the files in config and extract into env variables

BUILD_NUMBER=$( date +%s )

# Build each image and push
ROOT_DIR=`pwd`

# Build the NGINX image (configure Fast CGI)

# rallen: The nginx image should have no code whatsoever in it.
# Whatever user code nginx sees should be on a volume, not on the docker image.

cd code-nginx
docker build \
  --tag registry.ng.bluemix.net/jjdojo/code-nginx:${BUILD_NUMBER} \
  --tag registry.ng.bluemix.net/jjdojo/code-nginx:latest \
  --build-arg NGINX_VERSION=1.13.5 \
  .

# Move back to ROOT_DIR
cd $ROOT_DIR

# Build the PHP-FPM image (base image, inject code, run composer)
cd ../docker/code-php-fpm
if [ -d tmp ]; then
  rm -fr tmp
fi
mkdir tmp
cp -R ../../../code/ tmp/
docker build \
  --tag registry.ng.bluemix.net/jjdojo/code-php-fpm:${BUILD_NUMBER} \
  --tag registry.ng.bluemix.net/jjdojo/code-php-fpm:latest \
  --build-arg PHP_FPM_VERSION=${PHP_FPM_VERSION} \
  --build-arg DRUPAL_MD5=${DRUPAL_MD5} \
  --build-arg DRUPAL_VERSION=${DRUPAL_VERSION} \
  .
docker push registry.ng.bluemix.net/jjdojo/code-php-fpm:latest
rm -fr tmp

# Move back to ROOT_DIR
cd $ROOT_DIR

# Build the PHP-CLI image (base image, inject code, run composer)
cd ../docker/code-php-cli
if [ -d tmp ]; then
  rm -fr tmp
fi
mkdir tmp
cp -R ../../../code/ tmp/
docker build \
  --tag registry.ng.bluemix.net/jjdojo/code-php-cli:${BUILD_NUMBER} \
  --tag registry.ng.bluemix.net/jjdojo/code-php-cli:latest \
  --build-arg PHP_CLI_VERSION=${PHP_CLI_VERSION} \
  .
docker push registry.ng.bluemix.net/jjdojo/code-php-cli:latest
rm -fr tmp

# Move back to ROOT_DIR
cd $ROOT_DIR
