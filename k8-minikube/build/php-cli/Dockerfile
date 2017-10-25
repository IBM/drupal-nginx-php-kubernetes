# This Dockerfile provides a base level of OS packages with PHP-CLI and extensions

FROM registry.ng.bluemix.net/alexanderallen/php-fpm:latest

# Specify $COMPOSER_HOME.
ENV COMPOSER_HOME /.root

# Add global binary directory to PATH.
ENV PATH $COMPOSER_HOME/vendor/bin:$PATH

# Allow Composer to be run as root.
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN curl -sS https://getcomposer.org/installer | \
   php -- --install-dir=/usr/bin/ --filename=composer

WORKDIR $COMPOSER_HOME

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
