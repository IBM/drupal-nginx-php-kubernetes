## Building and deploying the initial set of containers
Now that the Kubernetes cluster and MySQL, Redis, and Memcached services have been provisioned, it's time to start a set of containers (pods) on the Kubernetes worker nodes. We do this through a set of declarative YAML files, which define not only the containers to start, but the storage and network configuration that they depend on.

## Review the Docker build files
There are 6 Docker images, 3 for base configuration and 3 custom code which build upon the base configuration.

The first set of three (NGINX, PHP-FPM, and PHP-CLI) provide the underlying web server and PHP environment needed by Drupal. These are rebuilt based on new version numbers provided in text files in the `config` directory, which in turn triggers a rebuild of the second set of three `code` images.

1. The [`scripts/docker/config-nginx/Dockerfile`](../scripts/docker/config-nginx/Dockerfile) provides a base level of NGINX configured to delegate PHP requests to PHP-FPM.

2. The [`scripts/docker/config-php-fpm/Dockerfile`](../scripts/docker/config-php-fpm/Dockerfile) provides a base level of operating system packages with PHP-FPM and extensions.

3. The [`scripts/docker/config-php-cli/Dockerfile`](../scripts/docker/config-php-cli/Dockerfile) provides a base level of OS packages with PHP-CLI and extensions.

The second set of three (NGINX, PHP-FPM, and PHP-CLI) provide image builds specific to Drupal, Drush, and custom code that is pushed to the `code` directory. They are rebuilt when anything in that directory changes.

1. The [`scripts/docker/code-nginx/Dockerfile`](../scripts/docker/code-nginx/Dockerfile) builds on the base image and adds static code to the `/var/www/html` directory.

2. The [`scripts/docker/code-php-fpm/Dockerfile`](../scripts/docker/code-php-fpm/Dockerfile) installs Drupal via Composer, then copies over custom code. It also mounts the volume needed at runtime through its `start.sh` script.

3. The [`scripts/docker/code-php-cli/Dockerfile`](../scripts/docker/code-php-cli/Dockerfile) installs Drush via Composer, then copies over custom code. It also mounts the volume needed at runtime through its `start.sh` script.

## Review the Kubernetes container deployment configuration files
The Kubernetes deployment files instantiate containers based on the `code` images (never just the `config` images).

We set up two container clusters, one for a "Staging" environment and one for a "Production" environment. They share the same base Docker images.

- The [`scripts/kubernetes/persistent-volumes.yaml`](../scripts/kubernetes/persistent-volumes.yaml) files defines two 10 GB storage volumes (one for staging, one for production) that can be mounted by many containers (`ReadWriteMany`). The containers then reference these volumes in their own configuration files.
- The [`scripts/kubernetes/php-fpm-stg.yaml`](../scripts/kubernetes/php-fpm-stg.yaml) and [`scripts/kubernetes/php-fpm-prd.yaml`](../scripts/kubernetes/php-fpm-prd.yaml) files describe the pod/deployment for the PHP-FPM containers in each environment. They specify how many containers from the given image and tag to start, what port to listen on, the environment variables that map to the service credentials, and where to mount the storage volume.
- Similarly, the [`scripts/kubernetes/nginx-stg.yaml`](../scripts/kubernetes/nginx-stg.yaml) and [`scripts/kubernetes/nginx-prd.yaml`](../scripts/kubernetes/nginx-prd.yaml) files describe the pod/deployment for the NGINX containers. They specify how many containers from the given image and tag to start (1, for now), what port to listen on, what IP address to bind to, the environment variables that map to the service credentials, and where to mount the storage volume.
- Finally, the [`scripts/kubernetes/php-cli.yaml`](../scripts/kubernetes/php-cli.yaml) configures the single shared CLI container that is used to manage files and data from both environments and synchronize data ([`code/drush/transfer-data.sh`](../code/drush/transfer-data.sh)) and files (([`code/drush/transfer-files.sh`](../code/drush/transfer-files.sh))) from production to staging.

## Build container images and push to the private registry
Log into Bluemix and the Container Registry. Make sure your target organization and space is set. If you haven't already installed the Container Registry plugin for the `bx` CLI:

```bash
# Configure the plugin if you haven't yet
bx plugin install container-service -r Bluemix
bx login -a https://api.ng.bluemix.net
bx cs init
```

Next, list the clusters already provisioned on Bluemix, and get the Kubernetes configuration information.
```bash
bx cs clusters # Find your cluster, and input into next command
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

# Run the visual dashboard which will be available on http://127.0.0.1:8001/ui
kubectl proxy
```

## Optional: Configure your namespace
Right now, this POC is hardcoded to the "orod" image registry namespace. To avoid overwriting other people's images, you may want create and configure your own namespace.

Install the Bluemix container registry CLI plugin:
```bash
bx plugin install container-registry -r Bluemix
bx login
```

Create a namespace:
```bash
bx cr namespace-add $MY_NAMESPACE
bx cr namespaces # List namespaces
bx cr login # To enable pushing images
```

Configure scripts with your namespace. You will need to replace "orod" in
- [build-containers.sh](../scripts/build-containers.sh)
- [php-cli.yaml](../scripts/kubernetes/php-cli.yaml)
- [nginx-stg.yaml](../scripts/kubernetes/nginx-stg.yaml)
- [php-fpm-stg.yaml](../scripts/kubernetes/php-fpm-stg.yaml)
- [nginx-prd.yaml](../scripts/kubernetes/nginx-prd.yaml)
- [php-fpm-prd.yaml](../scripts/kubernetes/php-fpm-prd.yaml)

Finally, you may have to [create an `imagePull` token](https://console.bluemix.net/docs/containers/cs_cluster.html#bx_registry_other).

## Build the container images
Run this script to build the containers and push them to your registry:
```bash
cd scripts/pipeline
./build-on-config-change.sh
```

## Deploy the container images to the Kubernetes cluster

```bash
# Create an image pull token for the given registry. The kubectl command may not like the wrapped lines, so change it all to one line if needed.
bx cr token-list
bx cr token-get $TOKEN_ID
kubectl --namespace default create secret docker-registry image-pull \
--docker-server="registry.ng.bluemix.net" \
--docker-username="token" \
--docker-password="${TOKEN}" \
--docker-email="${YOUR_EMAIL}"

./rolling-code-deploy.sh
```

The YAML files in this directory reference the same image names (including the name of our registry namespace) as in the `build-on-config-change.sh` script. These is the hand-off point between image build/push, and Kubernetes deploy.

## Specify a non-floating LoadBalancer IP
Obtain the available IPs assigned to your cluster (look for "is_public: true")
```bash
kubectl get cm ibm-cloud-provider-vlan-ip-config -n kube-system -o yaml
```

Set an IP address for Staging and Production in the `spec.loadBalancerIP` value inside [`scripts/kubernetes/nginx-prd.yaml`](../scripts/kubernetes/nginx-prd.yaml) and [`scripts/kubernetes/nginx-stg.yaml`](../scripts/kubernetes/nginx-stg.yaml).

For example:
```bash
apiVersion: v1
kind: Service
metadata:
  name: nginx-prd
spec:
  loadBalancerIP: $IP
  ...
---
```

## Setup Ingress (replaces LoadBalancer)
So far, we have configured LoadBalancer as the service type for the nginx-prd service. We can use the Ingress type instead to give us more flexibility with specifying routes from a single endpoint and also us to use a hostname instead of floating IPs to access our application. Detailed docs here: https://console.bluemix.net/docs/containers/cs_apps.html#cs_apps_public_ingress.

1) Remove the `type: LoadBalancer` line from [`scripts/kubernetes/nginx.yaml`](../scripts/kubernetes/nginx-prd.yaml)

2) Obtain your "Ingress subdomain".
```bash
bx cs cluster-get $CLUSTER_NAME
```

3) Edit [`scripts/kubernetes/ingress/ingress.yaml`](../scripts/kubernetes/ingress/ingress.yaml) to include your subdomain.

4) Redeploy your nginx-prd service
```bash
kubectl delete service nginx-prd
kubectl apply -f scripts/kubernetes/nginx-prd.yaml
```

5) Deploy the ingress service
```bash
kubectl apply -f scripts/kubernetes/ingress/ingress.yaml
```

6) Once ingress is up (may take a minute), access your application via your domain.

## Tear down the containers
If you want to cleanly install the environment, for example to push a new set of container versions, use the following script:

```bash
cd scripts/pipeline
./rolling-code-deploy.sh
```
