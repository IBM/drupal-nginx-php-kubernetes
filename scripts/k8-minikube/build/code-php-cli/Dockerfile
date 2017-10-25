FROM registry.ng.bluemix.net/jjdojo/config-php-cli:latest

ARG PHP_CLI_VERSION=latest

ARG DRUSH_VERSION

# Worker name and index (TODO: where to set this?)
ENV WORKER_NAME="send-emails" \
   WORKER_INDEX="1"

RUN curl -sS https://getcomposer.org/installer | \
   php -- --install-dir=/usr/bin/ --filename=composer

COPY tmp/composer.json ./

# COPY tmp/composer.lock ./

RUN composer install --no-scripts --no-autoloader

COPY . ./

# RUN composer dump-autoload --optimize && composer run-script post-install-cmd

WORKDIR /root

ADD tmp/* ./

# TODO: Run composer install

CMD php $WORKER_NAME/$WORKER_NAME.php WORKER_INDEX=$WORKER_INDEX
