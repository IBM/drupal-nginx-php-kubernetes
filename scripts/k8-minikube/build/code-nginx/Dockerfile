# This Dockerfile builds on the base image and adds static code

FROM registry.ng.bluemix.net/jjdojo/config-nginx:latest

ARG NGINX_VERSION=latest

ADD tmp/* /var/www/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
