#!/usr/bin/env bash
set -x

ROOT_DIR=`pwd`

echo "Building base images... "

cd nginx
docker build --tag registry.ng.bluemix.net/jjdojo/nginx:latest .

cd $ROOT_DIR/php-fpm
docker build --tag registry.ng.bluemix.net/jjdojo/php-fpm:latest .

cd $ROOT_DIR/php-cli
docker build --tag registry.ng.bluemix.net/jjdojo/php-cli:latest .

echo "Build complete."
