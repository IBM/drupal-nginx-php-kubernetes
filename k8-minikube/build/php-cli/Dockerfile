# This Dockerfile provides a base level of OS packages with PHP-CLI and extensions

FROM registry.ng.bluemix.net/alexanderallen/php-fpm:latest

# Add global binary directory to PATH.
ENV PATH /composer/vendor/bin:$PATH

# Allow Composer to be run as root.
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN curl -sS https://getcomposer.org/installer | \
   php -- --install-dir=/usr/bin/ --filename=composer

WORKDIR /root

#COPY composer.json /root/composer.json
#COPY composer.lock /root/composer.json
#
## RUN composer install --no-scripts --no-autoloader
#RUN composer install

# Dump autoloader, without optimizations.
# Optimizations remove debugging capabilities.
#RUN composer dump-autoload

# RUN composer dump-autoload --optimize && composer run-script post-install-cmd

RUN composer require drush/drush:8.x

# Copy start script
COPY noop.php /root/

CMD [ "php", "/root/noop.php" ]
