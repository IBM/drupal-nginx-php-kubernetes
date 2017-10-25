# NGINX and PHP-FPM Container Cluster on IBM Bluemix
Demonstration of a set of NGINX and PHP containers deployed to the IBM Bluemix Container Service to support multiple web sites on a single Drupal 8 instance.

These containers mount a persistent volume for sites (which change after build time) and connect to MySQL, Redis, and Memcached services from the Bluemix catalog (not self-hosted containers inside the same cluster). They also mount a persistent volume to share an instance of Drupal and Drush.

This shows several basic concepts for deploying a multi-container deployment of NGINX and PHP cluster to Kubernetes and exposing them as services. Alternative approaches might use Helm or more sophisticated build and deploy approaches that deploy on commit to a GitHub repo.

This project also shows key features of the IBM Cloud platform:
- A secure, high-performance, IBM Container Service cluster (based on Kubernetes) with advanced network and storage configuration options.
- Integration with managed MySQL, Redis, and Memcached Databases-as-a-service provided through the Bluemix service catalog.
- Multiple levels of security for Docker images stored in the IBM Container Registry, including automatic scanning by the IBM Vulnerability Advisor.
- Automatic build and deploy workflows with IBM DevOps Services.


![](docs/img/architecture.png)

# One time Container Service and Bluemix services setup
See the Container Service Kubernetes and Bluemix services (MySQL, Redis, Memcached) [configuration instructions](docs/INITIAL-SETUP.md).

# Building and deploying the first set of containers
See the Docker container build and Kubernetes deployment [instructions](docs/DEPLOY-CONTAINERS.md).

# Ongoing development and operations with GitHub commits
See the ongoing development [instructions](docs/ONGOING-DEVELOPMENT.md). And the work in progress DevOps [pipeline docs](docs/PIPELINE-SETUP.md).
