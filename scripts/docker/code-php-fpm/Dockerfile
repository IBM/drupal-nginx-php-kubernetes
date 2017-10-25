ARG PHP_FPM_VERSION=latest
ARG REGISTRY_NAMESPACE=orod

FROM registry.ng.bluemix.net/${REGISTRY_NAMESPACE}/config-php-fpm:${PHP_FPM_VERSION}

ARG DRUPAL_VERSION
ARG DRUPAL_MD5

# Copy files into this Docker image, and recopy them to the mount at runtime in start.sh
RUN mkdir -p /tmp/var/www/drupal/
ADD tmp/composer.json /tmp/var/www/drupal/
ADD tmp/composer.lock /tmp/var/www/drupal/
ADD tmp/drush/ /tmp/var/www/drupal/drush/
ADD tmp/modules/ /tmp/var/www/drupal/web/modules/
ADD tmp/profiles/ /tmp/var/www/drupal/web/profiles/
ADD tmp/sites/ /tmp/var/www/drupal/web/sites/
ADD tmp/themes/ /tmp/var/www/drupal/web/themes/

RUN mkdir -p /var/www/drupal/web
WORKDIR /var/www/drupal/web

COPY start.sh /root/
RUN chmod +x /root/start.sh

EXPOSE 9000

ENTRYPOINT ["/root/start.sh"]
