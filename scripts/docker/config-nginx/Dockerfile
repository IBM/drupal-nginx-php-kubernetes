# This Dockerfile provides a base level of NGINX configured to delegate PHP requests to PHP-FPM

ARG NGINX_VERSION=latest

FROM nginx:${NGINX_VERSION}

# Set consistent timezone
ENV CONTAINER_TIMEZONE="UTC"
RUN rm -f /etc/localtime \
 && ln -s /usr/share/zoneinfo/${CONTAINER_TIMEZONE} /etc/localtime

# Install prerequisite OS packages
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y curl

RUN rm /etc/nginx/conf.d/default.conf

COPY fastcgi.conf /etc/nginx/conf.d/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
