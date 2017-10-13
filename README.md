# NGINX and PHP-FPM Container Cluster on IBM Bluemix
Demonstration of a set of NGINX and PHP containers deployed to the IBM Bluemix Container Service to support multiple Drupal 8 sites. These containers mount a persistent volume for sites (which change after build time) and connect to MySQL, Redis, and Memcached services from the Bluemix catalog (not self-hosted containers inside the same cluster).

This shows several basic concepts for deploying a multi-container deployment of NGINX and PHP cluster to Kubernetes and exposing them as services. More complex approaches might use Helm or more sophisticated build and deploy approaches that deploy on commit to a GitHub repo.

The PHP-FPM containers also include a built in Drupal 8.3 package, and mount the volume for shared read/write access to the `/var/www/html/sites/default/files` directory.

![](docs/img/architecture.png)

# One time Container Service and Bluemix services setup
See the Container Service Kubernetes and Bluemix services (MySQL, Redis, Memcached) [configuration instructions](docs/INITIAL-SETUP.md).

# Building and deploying the first set of containers
See the Docker container build and Kubernetes deployment [instructions](docs/DEPLOY-CONTAINERS.md).

# Ongoing development and operations with GitHub commits
See the ongoing development [instructions](docs/ONGOING-DEVELOPMENT.md). And the work in progress DevOps [pipeline docs](docs/PIPELINE-SETUP.md).
