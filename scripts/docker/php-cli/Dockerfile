FROM php:5.6-cli

# Set timezone, worker name, and index (TODO: where to set this?)
ENV CONTAINER_TIMEZONE="UTC" \
    WORKER_NAME="send-emails" \
    WORKER_INDEX="1"

RUN rm -f /etc/localtime \
 && ln -s /usr/share/zoneinfo/${CONTAINER_TIMEZONE} /etc/localtime

 # Install dependencies
 RUN apt-get update && \
     apt-get install curl nano git zlib1g-dev libicu-dev libmemcached-dev -y && \
     curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

 # Fetch extensions from PECL
 RUN  mkdir -p /usr/src/php/ext/ \
   && curl -L https://pecl.php.net/get/memcached-2.2.0.tgz >> /usr/src/php/ext/memcached.tgz \
   && curl -L https://pecl.php.net/get/redis-3.1.3.tgz >> /usr/src/php/ext/redis.tgz \
   && tar xvzf /usr/src/php/ext/memcached.tgz -C /usr/src/php/ext/ \
   && tar xvzf /usr/src/php/ext/redis.tgz -C /usr/src/php/ext/ \
   && ln -s /usr/src/php/ext/memcached-2.2.0 /usr/src/php/ext/memcached \
   && ln -s /usr/src/php/ext/redis-3.1.3 /usr/src/php/ext/redis

 # Build PHP with the extension source
 RUN docker-php-ext-configure memcached \
  && docker-php-ext-install memcached \
  && docker-php-ext-configure redis --with-zlib-dir=/usr \
  && docker-php-ext-install redis \
  && docker-php-ext-enable opcache \
  && docker-php-ext-install mysqli pdo pdo_mysql mbstring bcmath pcntl intl

 # Tidy up
 RUN  apt-get clean autoclean \
   && apt-get autoremove -y \
   && rm -rf /var/lib/{apt,dpkg,cache,log}/

WORKDIR /root

# Copy start script
COPY app/ /root/

CMD php $WORKER_NAME/$WORKER_NAME.php WORKER_INDEX=$WORKER_INDEX
