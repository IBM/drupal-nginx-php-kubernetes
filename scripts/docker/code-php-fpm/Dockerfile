ARG PHP_FPM_VERSION=latest

FROM registry.ng.bluemix.net/jjdojo/config-php-fpm:${PHP_FPM_VERSION}

ARG DRUPAL_VERSION
ARG DRUPAL_MD5

RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/bin/ --filename=composer

COPY tmp/composer.json ./

# COPY tmp/composer.lock ./

RUN composer install --no-scripts --no-autoloader

COPY . ./

# RUN composer dump-autoload --optimize && composer run-script post-install-cmd

COPY start.sh /root/
RUN chmod +x /root/start.sh
ADD tmp/* /var/www/html/

EXPOSE 9000

ENTRYPOINT ["/root/start.sh"]
