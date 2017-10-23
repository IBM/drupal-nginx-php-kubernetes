ARG PHP_CLI_VERSION=latest
ARG REGISTRY_NAMESPACE=orod

FROM registry.ng.bluemix.net/${REGISTRY_NAMESPACE}/config-php-cli:${PHP_CLI_VERSION}

ARG DRUSH_VERSION

# Worker name and index (TODO: where to set this?)
ENV WORKER_NAME="send-emails" \
   WORKER_INDEX="1"

RUN curl -sS https://getcomposer.org/installer | \
   php -- --install-dir=/usr/bin/ --filename=composer

COPY tmp/composer.json ./

# COPY tmp/code/composer.lock ./

RUN composer install --no-scripts --no-autoloader

COPY . ./

# RUN composer dump-autoload --optimize && composer run-script post-install-cmd

WORKDIR /root

ADD tmp/* ./

# TODO: Run composer install

CMD php $WORKER_NAME/$WORKER_NAME.php WORKER_INDEX=$WORKER_INDEX
