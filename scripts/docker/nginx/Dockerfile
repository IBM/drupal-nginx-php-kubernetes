FROM nginx

# Set consistent timezone
ENV CONTAINER_TIMEZONE="UTC"
RUN rm -f /etc/localtime \
 && ln -s /usr/share/zoneinfo/${CONTAINER_TIMEZONE} /etc/localtime

 # Install prerequisite OS packages
 RUN apt-get update && apt-get install -y curl

RUN rm /etc/nginx/conf.d/default.conf

COPY fastcgi.conf /etc/nginx/conf.d/

EXPOSE 80

# TODO: This really shouldn't be on this image, but we need it for static files
# Download and verify Drupal
# https://www.drupal.org/node/3060/release
WORKDIR /var/www
ENV DRUPAL_VERSION 8.3.7
ENV DRUPAL_MD5 e7b1f382d6bd2b18d4b4aca01d335bc0
RUN curl -fSL "https://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
   && echo "${DRUPAL_MD5} *drupal.tar.gz" | md5sum -c - \
   && tar -xzf drupal.tar.gz \
   && rm drupal.tar.gz \
   && rm -fr html \
   && mv drupal* html

COPY start.sh /root/start.sh
RUN chmod 755 /root/start.sh

ENTRYPOINT ["/root/start.sh"]
