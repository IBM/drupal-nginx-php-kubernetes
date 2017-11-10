## Feature list

It covers these baseline features and scenarios:
- [ ] Provides a script [`scripts/setup-infrastructure.sh`](scripts/setup-infrastructure.sh) that is a placeholder to deploy a Kubernetes cluster and provision the MySQL, Redis, and Memcached services from the IBM Cloud. As an alternative, see the [configuration page](docs/INITIAL-SETUP.md) for the UI instructions.
- [x] Provides a script [`scripts/build-containers.sh`](scripts/build-containers.sh) that starts with a supported base PHP 5.6 image, injects custom code, runs Composer, tags and pushes the image to an IBM Cloud Container Registry.
- [x] Provides a script [`scripts/deploy-containers.sh`](scripts/deploy-containers.sh) to deploy a set of 4 containers (1 NGINX container, 2 PHP-FPM containers, 1 PHP-CLI) from those images and mounts a shared volume to the 3 PHP containers.
- [x] Connects the 3 PHP containers to a MySQL-as-a-Service on startup.
- [x] Connects the 3 PHP containers to a Redis-as-a-Service on startup.
- [x] Connects the 3 PHP containers to a Memcached-as-a-Service on startup.
- [x] Exposes a load balanced endpoint that takes an HTTP POST request and routes it through NGINX to the PHP containers, which saves data in the MySQL and Redis databases, stores it in Memcached, and writes a file to the shared file system.
- [x] Exposes a load balanced endpoint [`app/read.php`](scripts/docker/php-fpm/app/read.php) that takes an HTTP GET request and routes it through NGINX to the PHP containers, which retrieves data in the MySQL and Redis databases, retrieves data from Memcached, and reads a file from the shared file system.
- [x] Exposes a load balanced endpoint [`app/create.php`](scripts/docker/php-fpm/app/create.php) that takes an HTTP POST request and routes it through NGINX to the PHP containers, which creates data in the MySQL and Redis databases, caches data from Memcached, and creates a file on the shared file system.
- [x] Exposes a load balanced endpoint [`app/delete.php`](scripts/docker/php-fpm/app/create.php) that takes an HTTP DELETE request and routes it through NGINX to the PHP containers, which deletes data in the MySQL and Redis databases, clears data from Memcached, and deletes a file from the shared file system.
- [ ] Builds and redeploys new containers with zero downtime on GitHub push.
- [x] Provides a script [`scripts/destroy-containers.sh`](scripts/destroy-containers.sh) to stop and remove the containers (but not the storage volume).
- [ ] Provides a script [`scripts/destroy-infrastructure.sh`](scripts/setup-infrastructure.sh) that is a placeholder to destroy a Kubernetes cluster and deprovision the MySQL, Redis, and Memcached services from the IBM Cloud.
