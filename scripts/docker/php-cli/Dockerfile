FROM php:5.6-cli

# Set timezone
ENV CONTAINER_TIMEZONE="UTC" \
    WORKER_INDEX=""

# WORKER_NAME defines the worker script to run
# e.g. ENV WORKER_NAME PostSynergyTelemetry

RUN rm -f /etc/localtime \
 && ln -s /usr/share/zoneinfo/${CONTAINER_TIMEZONE} /etc/localtime

RUN apt-get update && apt-get -y install git

# Fetch extensions from PECL
RUN curl -L https://pecl.php.net/get/memcache-3.0.8.tgz >> /usr/src/php/ext/memcache.tgz \
	&& curl -L https://pecl.php.net/get/redis-2.2.7.tgz >> /usr/src/php/ext/redis.tgz \
    && tar xvzf /usr/src/php/ext/memcache.tgz -C /usr/src/php/ext/ \
    && tar xvzf /usr/src/php/ext/redis.tgz -C /usr/src/php/ext/ \
    && ln -s /usr/src/php/ext/memcache-3.0.8 /usr/src/php/ext/memcache \
    && ln -s /usr/src/php/ext/redis-2.2.7 /usr/src/php/ext/redis

# Build PHP with the extension source
RUN apt-get update \
 && apt-get install -y \
	zlib1g-dev \
	libicu-dev \
    # Cleanup package files
 && apt-get clean autoclean \
 && apt-get autoremove -y \
 && rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN docker-php-ext-configure memcache \
 && docker-php-ext-install memcache \
 && docker-php-ext-configure redis --with-zlib-dir=/usr \
 && docker-php-ext-install redis \
 && docker-php-ext-enable opcache \
 && docker-php-ext-install mysqli mbstring bcmath pcntl intl

# Setup container for EA cloudcell
RUN mkdir -p /MobileDevelopment \
 && mkdir -p /var/log/php-worker \
 && mkdir -p /var/run/php-worker

COPY php-worker.conf /usr/local/etc/
COPY cloudcell.so /usr/local/lib/php/extensions/no-debug-non-zts-20131226/

WORKDIR /root

# Copy start script
COPY start.sh /root/

#CMD php $WORKER_NAME/$WORKER_NAME.php WORKER_INDEX=$WORKER_INDEX
CMD ["./start.sh"]
