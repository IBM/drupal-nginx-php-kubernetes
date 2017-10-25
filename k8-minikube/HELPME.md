
### Tail the logs for a container

Get the name:

    kubectl get deployment,service,rs,pods

Tail the container:

    kubectl logs -f <container-name>

### Connect to a container (exec bash/sh shell)

Get the nginx pod name:

    └─[$]> kubectl get pods
    NAME                       READY     STATUS    RESTARTS   AGE
    nginx-3049359248-5hvt9     1/1       Running   0          23m
    php-cli-290158884-sf92z    1/1       Running   0          23m
    php-fpm-3522852564-25ph5   1/1       Running   0          23m
    php-fpm-3522852564-2p379   1/1       Running   0          23m

Execute the sh shell on the nginx container:

    └─[$]> kubectl exec nginx-3049359248-5hvt9 -i -t sh

Execute the bash shell on the nginx container:

    └─[$]> kubectl exec nginx-3049359248-5hvt9 -i -t bash

### Help: Nginx can't reach PHP-FPM

The Docker Nginx image does not come with `ping` installed. Log in to the Nginx
container then install `iputils-ping`.

    kubectl exec nginx-3049359248-5hvt9 -i -t bash
    ...
    apt-get update
    apt-get install iputils-ping
    ping php-fpm
        
    root@nginx-3049359248-5hvt9:/# ping php-fpm
    PING php-fpm.default.svc.cluster.local (10.0.0.254) 56(84) bytes of data.
    ^C
    --- php-fpm.default.svc.cluster.local ping statistics ---
    11 packets transmitted, 0 received, 100% packet loss, time 10266ms

### Troubleshoot the PHP-FPM image

    root@php-fpm-3522852564-25ph5:/www# which php-fpm
    /usr/local/sbin/php-fpm

This confirms PHP-FPM is already running in the container

    root@php-fpm-3522852564-25ph5:/www# /usr/local/sbin/php-fpm --nodaemonize --force-stderr
    [25-Oct-2017 06:58:18] ERROR: unable to bind listening socket for address '[::]:9000': Address already in use (98)
    [25-Oct-2017 06:58:18] ERROR: FPM initialization failed

### PHP-FPM Docker Image Dockerfile Analysis

PHP Docker Image, search for the 7.1-fpm tag:

https://hub.docker.com/_/php/

Check the scripts available here:

    root@php-fpm-3522852564-25ph5:/www# ls /usr/local/bin/docker-php-*
    /usr/local/bin/docker-php-entrypoint  /usr/local/bin/docker-php-ext-configure  /usr/local/bin/docker-php-ext-enable  /usr/local/bin/docker-php-ext-install  /usr/local/bin/docker-php-source

The community Dockerfile drops php default configuration in:

    root@php-fpm-3522852564-25ph5:/www# ls /usr/local/etc
    pear.conf  php	php-fpm.conf  php-fpm.conf.default  php-fpm.d

According to the community image, the logs should be already forwarded to the
Docker log facilities (tail should work out of the box):

	&& { \
		echo '[global]'; \
		echo 'error_log = /proc/self/fd/2'; \
		echo; \
		echo '[www]'; \
		echo '; if we send this to /proc/self/fd/1, it never appears'; \
		echo 'access.log = /proc/self/fd/2'; \
		echo; \
		echo 'clear_env = no'; \
		echo; \
		echo '; Ensure worker stdout and stderr are sent to the main error log.'; \
		echo 'catch_workers_output = yes'; \
	} | tee php-fpm.d/docker.conf \

By default PHP-FPM is configured to be on port 9000:

	&& { \
		echo '[global]'; \
		echo 'daemonize = no'; \
		echo; \
		echo '[www]'; \
		echo 'listen = [::]:9000'; \
	} | tee php-fpm.d/zz-docker.conf

And there's no need to re-declare `EXPOSE 9000` because it is already on the
community Dockerfile:

    EXPOSE 9000
    CMD ["php-fpm"]

To read the default configuration files in the container:

    apt-get update && apt-get install vim

This line is important, in `/usr/local/etc/php-fpm.conf`:

    include=etc/php-fpm.d/*.conf

It will include the `/usr/local/etc/php-fpm.d` directory conf files.

There will be some default extension configuration in:

    root@php-fpm-3522852564-25ph5:/usr/local/etc/php/conf.d# ls
    docker-php-ext-gd.ini  docker-php-ext-memcached.ini  docker-php-ext-opcache.ini  docker-php-ext-pdo_mysql.ini  docker-php-ext-redis.ini  docker-php-ext-zip.ini  opcache-recommended.ini

And that about sums it up for a break down of all the configuration in the
PHP-FPM image.

---

TL;DR: In a Nutshell

PHP Configs are in

    /usr/local/etc/

Default Pool Config is in

    /usr/local/etc/php-fpm.d
