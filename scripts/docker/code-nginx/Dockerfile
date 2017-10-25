# This Dockerfile builds on the base image and adds static code

ARG NGINX_VERSION=latest
ARG REGISTRY_NAMESPACE=orod

FROM registry.ng.bluemix.net/${REGISTRY_NAMESPACE}/config-nginx:${NGINX_VERSION}

WORKDIR /var/www/drupal/web

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
