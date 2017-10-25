# This Dockerfile provides a base level of OS packages with PHP-CLI and extensions

FROM registry.ng.bluemix.net/jjdojo/php-fpm:latest

RUN curl -sS https://getcomposer.org/installer | \
   php -- --install-dir=/usr/bin/ --filename=composer

COPY composer.json /root/composer.json
COPY tmp/composer.lock /root/composer.json

# RUN composer install --no-scripts --no-autoloader
RUN composer install

# Dump autoloader, without optimizations.
# Optimizations remove debugging capabilities.
RUN composer dump-autoload

# RUN composer dump-autoload --optimize && composer run-script post-install-cmd

WORKDIR /root

# Copy start script
COPY noop.php /root/

CMD [ "php", "/root/noop.php" ]
