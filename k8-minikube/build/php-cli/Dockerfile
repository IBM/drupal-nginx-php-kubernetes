# This Dockerfile provides a base level of OS packages with PHP-CLI and extensions

FROM registry.ng.bluemix.net/jjdojo/php-fpm:latest

WORKDIR /root

# Copy start script
COPY noop.php /root/

CMD [ "php", "/root/noop.php" ]
