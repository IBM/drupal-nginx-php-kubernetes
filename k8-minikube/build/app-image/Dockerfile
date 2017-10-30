# Example application container.
# Extends from the PHP-CLI image so that it can use tools such as Composer.
# Otherwise Busybox would be a candidate source image.

# Candidate pattern: sidecar container.
# https://github.com/kubernetes/git-sync

# Reference:
# - https://getcomposer.org/doc/03-cli.md#create-project

FROM registry.ng.bluemix.net/alexanderallen/php-cli:latest

# todo: find and check in composer.lock for application.

# Install Drupal app.
RUN \
  # Create app directory.
  mkdir /app \
  # Install Drupal to app directory.
  && composer create-project \
    drupal-composer/drupal-project:8.x-dev \
    /app/ \
    --stability dev \
    --no-interaction \
    --no-progress

# RUN composer dump-autoload --optimize && composer run-script post-install-cmd

COPY start.sh /root/
COPY app-sync.sh /root/app-sync.sh

# Assuming this is using the PV/PVC.
CMD /root/app-sync.sh
