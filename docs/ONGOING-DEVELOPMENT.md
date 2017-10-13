## Ongoing development
Now that the Kubernetes cluster is provisioned and you have a set of containers running, the ongoing DevOps workflow will be to write code locally, push that to GitHub, and that in turn will start a job to rebuild the PHP container images with the versioned code. These images are in turn pushed to the private Docker registry, and pulled to run on the pods.

## Proposed workflow and lifecycle

### Build PHP and NGINX

### Build Drupal image

### Build global standard configuration image

### Build regional or site specific image

### Mount volume and runtime configuration


## Configuring a DevOps pipeline
TODO.
