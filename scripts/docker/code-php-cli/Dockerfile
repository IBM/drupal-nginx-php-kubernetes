ARG PHP_CLI_VERSION=latest

FROM registry.ng.bluemix.net/jjdojo/config-php-7.1-cli:${PHP_CLI_VERSION}

ARG DRUPAL_VERSION

# Worker name and index (TODO: where to set this?)
ENV WORKER_NAME="send-emails" \
   WORKER_INDEX="1"

WORKDIR /root

ADD tmp/* .

CMD php $WORKER_NAME/$WORKER_NAME.php WORKER_INDEX=$WORKER_INDEX
