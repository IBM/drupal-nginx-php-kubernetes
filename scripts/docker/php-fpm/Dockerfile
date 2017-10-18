ARG PHP_FPM_VERSION=php:7.1-fpm:latest

FROM ${PHP_FPM_VERSION}

ARG DRUPAL_VERSION
ARG DRUPAL_MD5

RUN env

# Set consistent timezone
ENV CONTAINER_TIMEZONE="UTC"
RUN rm -f /etc/localtime \
 && ln -s /usr/share/zoneinfo/${CONTAINER_TIMEZONE} /etc/localtime

# Install prerequisite OS packages
RUN apt-get update && apt-get install -y curl git

# Install the PHP extensions we need
RUN set -ex \
	&& buildDeps=' \
		libjpeg62-turbo-dev \
		libpng12-dev \
		libpq-dev \
    zlib1g-dev \
    libicu-dev \
    libmemcached-dev \
	' \
	&& apt-get install -y --no-install-recommends $buildDeps \
  && pecl install -o -f redis \
  && docker-php-ext-enable redis \
  && ls -la /usr/local/etc/php/conf.d/ \
	&& docker-php-ext-configure gd \
		--with-jpeg-dir=/usr \
		--with-png-dir=/usr \
	&& docker-php-ext-install -j "$(nproc)" gd mbstring opcache pdo pdo_mysql zip

RUN cd /tmp \
	&& git clone -b php7 https://github.com/php-memcached-dev/php-memcached \
	&& cd php-memcached \
	&& phpize \
	&& ./configure \
	&& make \
	&& cp /tmp/php-memcached/modules/memcached.so /usr/local/lib/php/extensions/no-debug-non-zts-20160303/memcached.so \
	&& docker-php-ext-enable memcached \
  && ls -la /usr/local/etc/php/conf.d/

# See https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Download and verify Drupal
# https://www.drupal.org/node/3060/release
WORKDIR /var/www
RUN curl -fSL "https://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
   && echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - \
   && tar -xzf drupal.tar.gz \
   && rm drupal.tar.gz \
   && rm -fr html \
   && mv drupal* html

COPY start.sh /root/
ADD tmp/* /var/www/html/

RUN chmod 755 /root/start.sh

EXPOSE 9000

ENTRYPOINT ["/root/start.sh"]
