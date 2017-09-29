FROM php:7.1-fpm

# Set consistent timezone
ENV CONTAINER_TIMEZONE="UTC"
RUN rm -f /etc/localtime \
 && ln -s /usr/share/zoneinfo/${CONTAINER_TIMEZONE} /etc/localtime

# Install prerequisite OS packages
RUN apt-get update && apt-get install -y curl git rsync

# install the PHP extensions we need
RUN set -ex \
	&& buildDeps=' \
		libjpeg62-turbo-dev \
		libpng12-dev \
		libpq-dev \
	' \
	&& apt-get update && apt-get install -y --no-install-recommends $buildDeps && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd \
		--with-jpeg-dir=/usr \
		--with-png-dir=/usr \
	&& docker-php-ext-install -j "$(nproc)" gd mbstring opcache pdo pdo_mysql pdo_pgsql zip \
# PHP Warning:  PHP Startup: Unable to load dynamic library '/usr/local/lib/php/extensions/no-debug-non-zts-20151012/gd.so' - libjpeg.so.62: cannot open shared object file: No such file or directory in Unknown on line 0
# PHP Warning:  PHP Startup: Unable to load dynamic library '/usr/local/lib/php/extensions/no-debug-non-zts-20151012/pdo_pgsql.so' - libpq.so.5: cannot open shared object file: No such file or directory in Unknown on line 0
	&& apt-mark manual \
		libjpeg62-turbo \
		libpq5 \
	&& apt-get purge -y --auto-remove $buildDeps

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
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
WORKDIR /tmp/
ENV DRUPAL_VERSION 8.3.7
ENV DRUPAL_MD5 e7b1f382d6bd2b18d4b4aca01d335bc0
RUN curl -fSL "https://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
  && echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - \
  && tar -xzvf drupal.tar.gz \
  && rm drupal.tar.gz

COPY start.sh /root/start.sh
RUN chmod 755 /root/start.sh

EXPOSE 9000

ENTRYPOINT ["/root/start.sh"]
