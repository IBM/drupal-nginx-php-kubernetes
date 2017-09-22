FROM nginx

# Set timezone
ENV CONTAINER_TIMEZONE="UTC"

RUN rm -f /etc/localtime \
 && ln -s /usr/share/zoneinfo/${CONTAINER_TIMEZONE} /etc/localtime

RUN rm /etc/nginx/conf.d/default.conf

COPY fastcgi.conf /etc/nginx/conf.d/

COPY index.html /var/www/html/

# Debug
RUN file="$(ls -Flat /var/www/html)" && echo $file

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
