FROM registry.ng.bluemix.net/jjdojo/config-php-fpm:latest

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/bin/ --filename=composer

ENV COMPOSER_HOME /root

# Copy composer manifest.
COPY composer.json $COMPOSER_HOME/composer.json
COPY composer.lock $COMPOSER_HOME/composer.lock

# Install composer.json contents.
RUN composer install --no-scripts --no-autoloader

COPY . ./


RUN rm -fr /var/www/html
RUN composer create-project drupal-composer/drupal-project:8.x-dev /var/www/html/ --stability dev --no-interaction

ADD tmp/* /var/www/html/


# RUN composer dump-autoload --optimize && composer run-script post-install-cmd

COPY start.sh /root/

EXPOSE 9000

ENTRYPOINT ["/root/start.sh"]
