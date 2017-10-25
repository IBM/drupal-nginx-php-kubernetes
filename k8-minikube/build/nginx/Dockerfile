# This Dockerfile provides a base level of NGINX configured to delegate PHP requests to PHP-FPM

FROM nginx:latest

#FROM nginx:${NGINX_VERSION}
ARG NGINX_VERSION=latest

# Set consistent timezone
ENV CONTAINER_TIMEZONE="UTC"
RUN rm -f /etc/localtime \
 && ln -s /usr/share/zoneinfo/${CONTAINER_TIMEZONE} /etc/localtime

# Install prerequisite OS packages
RUN apt-get update && apt-get install -y curl iputils-ping libfcgi0ldbl vim

RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.bak

# Copy Nginx configs.
COPY nginx.conf /etc/nginx/nginx.conf
COPY fastcgi_params /etc/nginx/fastcgi_params
COPY fastcgi.conf /etc/nginx/conf.d/fastcgi.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
