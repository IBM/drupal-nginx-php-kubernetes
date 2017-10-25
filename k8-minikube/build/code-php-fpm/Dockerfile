FROM registry.ng.bluemix.net/jjdojo/config-php-fpm:latest

RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/bin/ --filename=composer

COPY tmp/composer.json ./

# COPY tmp/composer.lock ./

RUN composer install --no-scripts --no-autoloader

COPY . ./


RUN rm -fr /var/www/html
RUN composer create-project drupal-composer/drupal-project:8.x-dev /var/www/html/ --stability dev --no-interaction

ADD tmp/* /var/www/html/


# RUN composer dump-autoload --optimize && composer run-script post-install-cmd

COPY start.sh /root/

EXPOSE 9000

ENTRYPOINT ["/root/start.sh"]
