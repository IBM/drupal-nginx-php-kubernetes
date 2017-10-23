# This Dockerfile builds on the base image and adds static code

ARG NGINX_VERSION=latest
ARG REGISTRY_NAMESPACE=orod

FROM registry.ng.bluemix.net/${REGISTRY_NAMESPACE}/config-nginx:${NGINX_VERSION}

ADD tmp/* /var/www/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
