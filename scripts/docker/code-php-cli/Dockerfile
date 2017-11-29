ARG PHP_CLI_VERSION=latest
ARG REGISTRY_NAMESPACE=orod

FROM registry.ng.bluemix.net/${REGISTRY_NAMESPACE}/config-php-cli:${PHP_CLI_VERSION}

ARG DRUSH_VERSION

RUN apt-get update -y && apt-get upgrade -y

# Worker name and index (TODO: where to set this?)
ENV WORKER_NAME="send-emails" \
   WORKER_INDEX="1"

# Register the COMPOSER_HOME environment variable.
ENV COMPOSER_HOME=/root/.composer

# Add global binary directory to PATH.
ENV PATH /root/.composer/vendor/bin:$PATH

# Allow Composer to be run as root.
ENV COMPOSER_ALLOW_SUPERUSER=1

RUN curl -sS https://getcomposer.org/installer | \
   php -- --install-dir=/usr/bin/ --filename=composer

COPY tmp/composer.json ./

# COPY tmp/code/composer.lock ./

RUN composer install --no-scripts --no-autoloader

COPY . ./

RUN composer global require drush/drush:8.x

ADD tmp/composer.json /root/drush/
ADD tmp/composer.lock /root/drush/

# Add Drush specific scripts
ADD tmp/drush/ /root/drush/
RUN chmod +x /root/drush/*.sh

# Add database connection info
ADD tmp/sites/default/ /root/drush/sites/default/

# Prep a backup directory
RUN mkdir /root/backups/

WORKDIR /root/drush/

# Change this to be a Drush command?
# This container is more here to just exec into rather than run something headless
CMD php $WORKER_NAME/$WORKER_NAME.php WORKER_INDEX=$WORKER_INDEX
