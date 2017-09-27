## Building and deploying the initial set of containers
Now that the Kubernetes cluster and MySQL, Redis, and Memcached services have been provisioned, it's time to start a set of containers (pods) on the worker nodes. We do this through a set of declarative YAML files, which define not only the containers to start, but the storage and network configuration.

## Review the Docker build files
- The [`scripts/docker/nginx/Dockerfile`](/krook/nginx-php-container-cluster/blob/master/scripts/docker/nginx/Dockerfile) provides the steps to build a custom NGINX image based on the latest public image. It adds a configuration file that delegates PHP file requests to the load balanced pool of PHP-FPM containers, adds a static HTML page that it will serve itself, and starts up on port 80.
- The [`scripts/docker/php-fpm/Dockerfile`](/krook/nginx-php-container-cluster/blob/master/scripts/docker/php-fpm/Dockerfile) provides the steps to build a custom PHP-FPM image based on the latest public image. It installs prerequisite packages, configures and builds the MySQL, Redis, and Memcached extensions, copies the custom application code over, runs Composer, sets up read/write access to the storage volume for the PHP-FPM process which does not run as root, and starts up on port 9000.
- The [`scripts/docker/php-cli/Dockerfile`](/krook/nginx-php-container-cluster/blob/master/scripts/docker/php-cli/Dockerfile) provides the steps to build a custom PHP CLI image based on the latest public image. It installs prerequisite packages, configures and builds the MySQL, Redis, and Memcached extensions, copies the custom application code over, runs Composer, and sets up read/write access to the storage volume for the PHP-FPM process which does not run as root.

## Review the Kubernetes container deployment configuration files
- The [`scripts/kubernetes/persistent-volumes.yaml`](/krook/nginx-php-container-cluster/blob/master/scripts/kubernetes/persistent-volumes.yaml) files defines a 20 GB storage volume that can be mounted by many containers (`ReadWriteMany`). The containers then reference this file in their own configuration files.
- The [`scripts/kubernetes/php-fpm.yaml`](/krook/nginx-php-container-cluster/blob/master/scripts/kubernetes/php-fpm.yaml) file describes the pod/deployment for the PHP-FPM containers. It specifies how many containers from the given image and tag to start (2, for now), what port to listen on, the environment variables that map to the service credentials, and where to mount the storage volume.
- Similarly The [`scripts/kubernetes/nginx.yaml`](/krook/nginx-php-container-cluster/blob/master/scripts/kubernetes/nginx.yaml) file describes the pod/deployment for the NGINX containers. It specifies how many containers from the given image and tag to start (1, for now), what port to listen on, the environment variables that map to the service credentials, and where to mount the storage volume.
- Finally, the [`scripts/kubernetes/php-cli.yaml`](/krook/nginx-php-container-cluster/blob/master/scripts/kubernetes/php-cli.yaml) configures the pool of CLI workers that may be polling a database or queue for messages. It also maps the environment variables and storage volume, but does not expose a service for inbound network access.

## Build container images and push to the private registry
Log into Bluemix and the Container Registry. Make sure your target organization and space is set. If you haven't already installed the Container Registry plugin for the `bx` CLI:

```bash
bx plugin install container-registry -r Bluemix
```

Then run this script to build the containers and push them to your registry:
```bash
cd scripts
./build-containers.sh
```

## Deploy the container images to the Kubernetes cluster
Next you'll deploy your images to the cluster. You may have to [create an `imagePull` token](https://console.bluemix.net/docs/containers/cs_cluster.html#bx_registry_other) if your registry is in a different namespace from the Kubernetes cluster.

```bash
./deploy-containers.sh
```

## Tear down the containers
If you want to cleanly install the environment, for example to push a new set of container versions, use the following script:

```bash
./destroy-containers.sh
```
