#!/bin/bash
set -e

echo "Starting custom code container build"

# Inspect all the files in config and extract into env variables
set -o allexport
for file in ../../code/*.txt
do
  source $file
done

for file in ../../config/*.txt
do
  source $file
done
set +o allexport

BUILD_NUMBER=$( date +%s )

echo $DRUPAL_VERSION
echo $DRUPAL_MD5
echo $DRUSH_VERSION
echo $NGINX_VERSION     # Override from args
echo $PHP_FPM_VERSION   # Override from args
echo $PHP_CLI_VERSION   # Override from args

# Build each image and push
ROOT_DIR=`pwd`

case "$IMAGE" in

  "nginx")
    echo "nginx"
    # Build the NGINX image (configure Fast CGI)
    cd ../docker/code-nginx
    if [ -d tmp ]; then
      rm -fr tmp
    fi
    mkdir tmp
    cp -R ../../../code/* tmp/
    bx cr build \
      --tag registry.ng.bluemix.net/${REGISTRY_NAMESPACE}/code-nginx:${BUILD_NUMBER} \
      --tag registry.ng.bluemix.net/${REGISTRY_NAMESPACE}/code-nginx:latest \
      --build-arg REGISTRY_NAMESPACE=${REGISTRY_NAMESPACE} \
      .
    # --no-cache \
    #docker push registry.ng.bluemix.net/${REGISTRY_NAMESPACE}/code-nginx:latest
    rm -fr tmp

    # Move back to ROOT_DIR
    cd $ROOT_DIR
    ;;

  "php-fpm")
    echo "php-fpm"
    # Build the PHP-FPM image (base image, inject code, run composer)
    cd ../docker/code-php-fpm
    if [ -d tmp ]; then
      rm -fr tmp
    fi
    mkdir tmp
    cp -R ../../../code/* tmp/

    bx cr build \
      --tag registry.ng.bluemix.net/${REGISTRY_NAMESPACE}/code-php-fpm:${BUILD_NUMBER} \
      --tag registry.ng.bluemix.net/${REGISTRY_NAMESPACE}/code-php-fpm:latest \
      --build-arg DRUPAL_MD5=${DRUPAL_MD5} \
      --build-arg DRUPAL_VERSION=${DRUPAL_VERSION} \
      --build-arg REGISTRY_NAMESPACE=${REGISTRY_NAMESPACE} \
      .
    #docker push registry.ng.bluemix.net/${REGISTRY_NAMESPACE}/code-php-fpm:latest
    rm -fr tmp

    # Move back to ROOT_DIR
    cd $ROOT_DIR
    ;;

  "php-cli")
    echo "php-cli"
    # Build the PHP-CLI image (base image, inject code, run composer)
    cd ../docker/code-php-cli
    if [ -d tmp ]; then
      rm -fr tmp
    fi
    mkdir tmp
    cp -R ../../../code/* tmp/

    bx cr build \
      --tag registry.ng.bluemix.net/${REGISTRY_NAMESPACE}/code-php-cli:${BUILD_NUMBER} \
      --tag registry.ng.bluemix.net/${REGISTRY_NAMESPACE}/code-php-cli:latest \
      --build-arg DRUSH_VERSION=${DRUSH_VERSION} \
      --build-arg REGISTRY_NAMESPACE=${REGISTRY_NAMESPACE} \
      .
    #docker push registry.ng.bluemix.net/${REGISTRY_NAMESPACE}/code-php-cli:latest
    rm -fr tmp

    # Move back to ROOT_DIR
    cd $ROOT_DIR
    ;;
esac
