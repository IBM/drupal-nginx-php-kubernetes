# NGINX and PHP-FPM Container Cluster on IBM Bluemix
This project demonstrates how to deploy a Drupal 8 environment on a cluster of NGINX and PHP containers using the IBM Container Service and several Bluemix catalog services.

These containers mount a persistent volume for sites (which change after build time) and connect to MySQL, Redis, and Memcached services from the Bluemix catalog (not self-hosted containers inside the same cluster).

After deployment, Drupal site developers can manage the lifecycle of sites by delivering configuration or code changes to specific folders in this repository. Commits trigger fresh rebuild and deploys in an IBM DevOps Services continuous integration pipeline.

# Features of the IBM Cloud platform highlighted
- A secure, high-performance, IBM Container Service cluster (based on Kubernetes) with advanced network and storage configuration options.
- Integration with managed MySQL, Redis, and Memcached Databases-as-a-service provided through the Bluemix service catalog.
- Multiple levels of security for Docker images stored in the IBM Container Registry, including automatic scanning by the IBM Vulnerability Advisor.
- Automatic build and deploy workflows with IBM DevOps Services.

# Logical overview diagram
There are two separate Drupal installations that are deployed onto the container cluster. One to represent a "staging" environment and one to represent a "production" environment. Each has its own dedicated services and volume mounts. A CLI container can run `drush` or scripts such as `transfer-files.sh` and `transfer-data.sh` on those environments to synchronize them.


![](docs/img/architecture.png)

# Setup the proof of concept

## One time Container Service and Bluemix services setup
See the Container Service Kubernetes and Bluemix services (MySQL, Redis, Memcached) [configuration instructions](docs/INITIAL-SETUP.md).

## Building and deploying the first set of containers
See the Docker container build and Kubernetes deployment [instructions](docs/DEPLOY-CONTAINERS.md).

## Ongoing development and operations with GitHub commits
See the ongoing development [instructions](docs/ONGOING-DEVELOPMENT.md). And the work in progress DevOps [pipeline docs](docs/PIPELINE-SETUP.md).

## Synchronizing data from production back to staging
There are two synchronization scripts that can be invoked to bring user generated changes to files or data from production back into the staging environment.
