ARG PHP_FPM_VERSION=latest
ARG REGISTRY_NAMESPACE=orod

FROM registry.ng.bluemix.net/${REGISTRY_NAMESPACE}/config-php-fpm:${PHP_FPM_VERSION}

ARG DRUPAL_VERSION
ARG DRUPAL_MD5

RUN apt-get update -y && apt-get upgrade -y

# Register the COMPOSER_HOME environment variable.
ENV COMPOSER_HOME=/root/.composer

# Add global binary directory to PATH.
ENV PATH /root/.composer/vendor/bin:$PATH

# Allow Composer to be run as root.
ENV COMPOSER_ALLOW_SUPERUSER=1

RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/bin/ --filename=composer

COPY tmp/composer.json ./

# COPY tmp/composer.lock ./

RUN composer install --no-scripts --no-autoloader

COPY . ./

RUN composer create-project drupal-composer/drupal-project:${DRUPAL_VERSION} /var/www/drupal/ --stability dev --no-interaction

# The above uses the web subdirectory and default composer.json.
# To customize before install, you can take the following approach instead:
#   git clone https://github.com/drupal-composer/drupal-project.git my_site_name_dir
#   cd my_site_name_dir
#   vi composer.json to customize
#   composer install

ADD tmp/composer.json /var/www/drupal/
ADD tmp/composer.lock /var/www/drupal/

ADD tmp/drush/ /var/www/drupal/drush/
RUN chmod +x /var/www/drupal/drush/*.sh

ADD tmp/modules/ /var/www/drupal/web/modules/
ADD tmp/profiles/ /var/www/drupal/web/profiles/
ADD tmp/sites/ /var/www/drupal/web/sites/
ADD tmp/themes/ /var/www/drupal/web/themes/
ADD tmp/config/ /var/www/drupal/config/

# One way to do the initial setup.
# cd /var/www/drupal/web
# ../vendor/drush/drush/drush site-install standard \
#   --db-url=mysql://DBUSERNAME:DBPASSWORD@localhost/some_db \
#   --account-mail="admin@example.com" \
#   --account-name=admin \
#   --account-pass=some_admin_password \
#   --site-mail="admin@example.com" \
#   --site-name="Site-Install"

# Install drush
RUN composer global require drush/drush:8.x

WORKDIR /var/www/drupal/web

COPY start.sh /root/
RUN chmod +x /root/start.sh

EXPOSE 9000

ENTRYPOINT ["/root/start.sh"]
