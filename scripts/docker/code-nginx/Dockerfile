# This Dockerfile builds on the base image and adds static code

ARG NGINX_VERSION=latest

FROM registry.ng.bluemix.net/jjdojo/config-nginx:${NGINX_VERSION}

ADD tmp/* /var/www/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
