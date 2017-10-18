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

echo $DRUPAL_VERSION
echo $DRUPAL_MD5
echo $NGINX_VERSION
echo $PHP_FPM_VERSION
echo $PHP_CLI_VERSION

# Build each image and push
ROOT_DIR=`pwd`

# Log into the Bluemix Container Registry
bx cr login

# Build the NGINX image (configure Fast CGI)
cd ../docker/code-nginx
mkdir tmp
cp -R ../../../code/ tmp/
docker build \
  --tag registry.ng.bluemix.net/jjdojo/code-${DRUPAL_VERSION}-${NGINX_VERSION}:${BUILD_NUMBER} \
  --build-arg NGINX_VERSION=${NGINX_VERSION} \
  --build-arg DRUPAL_VERSION=${DRUPAL_VERSION} \
  --build-arg DRUPAL_MD5=${DRUPAL_MD5} \
  .
# --no-cache \
docker push registry.ng.bluemix.net/jjdojo/code-${DRUPAL_VERSION}-${NGINX_VERSION}:${BUILD_NUMBER}
rm -fr tmp

# Move back to ROOT_DIR
cd $ROOT_DIR

# Build the PHP-FPM image (base image, inject code, run composer)
cd ../docker/code-php-fpm
mkdir tmp
cp -R ../../../code/ tmp/
docker build \
  --tag registry.ng.bluemix.net/jjdojo/code-${DRUPAL_VERSION}-${PHP_FPM_VERSION}:${BUILD_NUMBER} \
  --build-arg PHP_FPM_VERSION=${PHP_FPM_VERSION} \
  --build-arg DRUPAL_MD5=${DRUPAL_MD5} \
  --build-arg DRUPAL_VERSION=${DRUPAL_VERSION} \
  .
docker push registry.ng.bluemix.net/jjdojo/code-${DRUPAL_VERSION}-${PHP_FPM_VERSION}:${BUILD_NUMBER}
rm -fr tmp

# Move back to ROOT_DIR
cd $ROOT_DIR

# Build the PHP-FPM image (base image, inject code, run composer)
cd ../docker/code-php-cli
mkdir tmp
cp -R ../../../code/ tmp/
docker build \
  --tag registry.ng.bluemix.net/jjdojo/code-${DRUPAL_VERSION}-${PHP_CLI_VERSION}:${BUILD_NUMBER} \
  --build-arg PHP_CLI_VERSION=${PHP_CLI_VERSION} \
  --build-arg DRUPAL_MD5=${DRUPAL_MD5} \
  --build-arg DRUPAL_VERSION=${DRUPAL_VERSION} \
  .
docker push registry.ng.bluemix.net/jjdojo/code-${DRUPAL_VERSION}-${PHP_CLI_VERSION}:${BUILD_NUMBER}
rm -fr tmp

# Move back to ROOT_DIR
cd $ROOT_DIR
