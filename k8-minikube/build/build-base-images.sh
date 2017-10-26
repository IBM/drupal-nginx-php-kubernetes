#!/usr/bin/env bash
set -x

ROOT_DIR=`pwd`

echo "Building base images... "

cd nginx
docker build --tag registry.ng.bluemix.net/alexanderallen/nginx:latest .

cd $ROOT_DIR/php-fpm
docker build --tag registry.ng.bluemix.net/alexanderallen/php-fpm:latest .

cd $ROOT_DIR/php-cli
docker build --tag registry.ng.bluemix.net/alexanderallen/php-cli:latest .

cd $ROOT_DIR/app-image
docker build --tag registry.ng.bluemix.net/alexanderallen/app-image:latest .

echo "Build complete."
