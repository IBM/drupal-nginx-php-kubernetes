ARG PHP_FPM_VERSION=latest

FROM registry.ng.bluemix.net/jjdojo/config-php-7.1-fpm:${PHP_FPM_VERSION}

ARG DRUPAL_VERSION

RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/bin/ --filename=composer

COPY composer.json ./

COPY composer.lock ./

RUN composer install --no-scripts --no-autoloader

COPY . ./

RUN composer dump-autoload --optimize && \
	composer run-scripts post-install-cmd

COPY start.sh /root/
ADD tmp/* /var/www/html/

EXPOSE 9000

ENTRYPOINT ["/root/start.sh"]
