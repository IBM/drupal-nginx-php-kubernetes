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

RUN composer create-project drupal-composer/drupal-project:8.x /var/www/drupal/ --stability dev --no-interaction

# The above uses the web subdirectory and default composer.json.
# To customize before install, you can take the following approach instead:
#   git clone https://github.com/drupal-composer/drupal-project.git my_site_name_dir
#   cd my_site_name_dir
#   vi composer.json to customize
#   composer install

ADD tmp/composer.json /var/www/drupal/
ADD tmp/composer.lock /var/www/drupal/

ADD tmp/drush/ /var/www/drupal/drush/

WORKDIR /var/www/drupal/drush/

CMD ls -Flat

CMD php $WORKER_NAME/$WORKER_NAME.php WORKER_INDEX=$WORKER_INDEX
