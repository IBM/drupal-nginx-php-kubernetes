## Building and deploying the initial set of containers
Now that the Kubernetes cluster and MySQL, Redis, and Memcached services have been provisioned, it's time to start a set of containers (pods) on the worker nodes. We do this through a set of declarative YAML files, which define not only the containers to start, but the storage and network configuration.

## Review the Docker build files
- The [`scripts/docker/nginx/Dockerfile`](../scripts/docker/nginx/Dockerfile) provides the steps to build a custom NGINX image based on the latest public image. It adds a configuration file that delegates PHP file requests to the load balanced pool of PHP-FPM containers, adds a static HTML page that it will serve itself, and starts up on port 80.
- The [`scripts/docker/php-fpm/Dockerfile`](../scripts/docker/php-fpm/Dockerfile) provides the steps to build a custom PHP-FPM image based on the latest public image. It installs prerequisite packages, configures and builds the MySQL, Redis, and Memcached extensions, copies the custom application code over, runs Composer, sets up read/write access to the storage volume for the PHP-FPM process which does not run as root, and starts up on port 9000.
- The [`scripts/docker/php-cli/Dockerfile`](../scripts/docker/php-cli/Dockerfile) provides the steps to build a custom PHP CLI image based on the latest public image. It installs prerequisite packages, configures and builds the MySQL, Redis, and Memcached extensions, copies the custom application code over, runs Composer, and sets up read/write access to the storage volume for the PHP-FPM process which does not run as root.

## Review the Kubernetes container deployment configuration files
- The [`scripts/kubernetes/persistent-volumes.yaml`](../scripts/kubernetes/persistent-volumes.yaml) files defines three 10 GB storage volume that can be mounted by many containers (`ReadWriteMany`). The containers then reference these volumes in their own configuration files.
- The [`scripts/kubernetes/php-fpm.yaml`](../scripts/kubernetes/php-fpm.yaml) file describes the pod/deployment for the PHP-FPM containers. It specifies how many containers from the given image and tag to start (2, for now), what port to listen on, the environment variables that map to the service credentials, and where to mount the storage volume.
- Similarly The [`scripts/kubernetes/nginx.yaml`](../scripts/kubernetes/nginx.yaml) file describes the pod/deployment for the NGINX containers. It specifies how many containers from the given image and tag to start (1, for now), what port to listen on, the environment variables that map to the service credentials, and where to mount the storage volume.
- Finally, the [`scripts/kubernetes/php-cli.yaml`](../scripts/kubernetes/php-cli.yaml) configures the pool of CLI workers that may be polling a database or queue for messages. It also maps the environment variables and storage volume, but does not expose a service for inbound network access.

## Build container images and push to the private registry
Log into Bluemix and the Container Registry. Make sure your target organization and space is set. If you haven't already installed the Container Registry plugin for the `bx` CLI:

```bash
# Configure the plugin if you haven't yet
bx plugin install container-registry -r Bluemix
bx login -a https://api.ng.bluemix.net
bx cs init
```

Next, list the clusters already provisioned on Bluemix, and get the Kubenetes configuration information.
```bash
bx cs clusters #Find your cluster, and input into next command
bx cs cluster-config $CLUSTER_NAME
```

Copy the `export` line from the previous command to configure kubectl to point to your cluster.

```bash
# Configure kubectl
export KUBECONFIG=/Users/$USER_HOME_DIR/.bluemix/plugins/container-service/clusters/$CLUSTER_NAME/kube-config-$DATA_CENTER-$CLUSTER_NAME.yml
```

Finally, test your connection by interacting with your cluster.
```bash
# Confirm cluster is ready
kubectl get nodes

# Run the dashboard which will be available on http://127.0.0.1:8001/ui
kubectl proxy
```

## Build the container images
Run this script to build the containers and push them to your registry:
```bash
cd scripts

# Or use sed to replace "jjdojo" with your registry namespace.
vi build-containers.sh

./build-containers.sh
```

## Deploy the container images to the Kubernetes cluster
Next you'll deploy your images to the cluster. You may have to [create an `imagePull` token](https://console.bluemix.net/docs/containers/cs_cluster.html#bx_registry_other) if your registry is in a different namespace from the Kubernetes cluster.

```bash
# Or use sed to replace "jjdojo" with your registry namespace.
vi kubernetes/nginx.yaml
vi php-cli.yaml
vi php-fpm.yaml

# Create image pull token if needed one time. The kubectl command may not like the wrapped lines, so change it all to one line if needed.
bx cr token-list
bx cr token-get $TOKEN_ID
kubectl --namespace default create secret docker-registry image-pull \
--docker-server="registry.ng.bluemix.net" \
--docker-username="token" \
--docker-password="${TOKEN}" \
--docker-email="${YOUR_EMAIL}"

./deploy-containers.sh
```

The yaml files in this directory reference in same image names (including the name of our registry namespace) as in the `build-containers.sh` script. These is the hand-off point between image build/push, and kubernetes deploy.

## Tear down the containers
If you want to cleanly install the environment, for example to push a new set of container versions, use the following script:

```bash
./destroy-containers.sh
```
