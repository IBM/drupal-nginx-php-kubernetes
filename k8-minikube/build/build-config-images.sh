#!/usr/bin/env bash
set -x

ROOT_DIR=`pwd`

echo "Building config images... "
(
  cd config-nginx
  docker build --tag registry.ng.bluemix.net/jjdojo/nginx:latest .
)
(
  cd php-fpm
  docker build --tag registry.ng.bluemix.net/jjdojo/php-fpm:latest .
)
(
  cd config-php-cli
  docker build --tag registry.ng.bluemix.net/jjdojo/php-cli:latest .
)

echo "Build complete."
