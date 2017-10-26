# Example application container.
# Extends from the PHP-CLI image so that it can use tools such as Composer.
# Otherwise Busybox would be a candidate source image.

# Candidate pattern: sidecar container.
# https://github.com/kubernetes/git-sync

FROM registry.ng.bluemix.net/alexanderallen/php-cli:latest

# Install Drupal app.
RUN \
  # Create app directory.
  mkdir /app \
  # Install Drupal to app directory.
  && composer create-project \
    drupal-composer/drupal-project:8.x-dev \
    /app/ \
    --stability dev \
    --no-interaction

# RUN composer dump-autoload --optimize && composer run-script post-install-cmd

COPY start.sh /root/

# CMD [ rsync / copy /app into /www-data && exit 1 ]
