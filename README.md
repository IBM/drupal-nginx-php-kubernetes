# NGINX and PHP-FPM Container Cluster on IBM Bluemix
Simple demonstration of a set of NGINX and PHP containers deployed to the IBM Bluemix Container Service. These containers mounts persistent volumes and connect to MySQL, Redis, and Memcached services from the Bluemix catalog (not self-hosted containers inside the same cluster).

This shows several basic concepts for deploying a multi-container deployment of NGINX & PHP cluster to Kubernetes and exposing them as services. More complex approaches might use Helm or more sophisticated build and deploy approaches that deploy on commit to a GitHub repo.

The PHP-FPM containers also include a built in Drupal 8.3 package, and mount the three volumes for shared read/write access to `sites`, `modules`, and `themes` directories.

![](docs/img/architecture.png)

# One time Container Service and Bluemix services setup
See the Container Service Kubernetes and Bluemix services (MySQL, Redis, Memcached) [configuration instructions](docs/INITIAL-SETUP.md).

# Building and deploying the first set of containers
See the Docker container build and Kubernetes deployment [instructions](docs/DEPLOY-CONTAINERS.md).

# Ongoing development and operations with GitHub commits
See the ongoing development docs [instructions](docs/ONGOING-DEVELOPMENT.md).
