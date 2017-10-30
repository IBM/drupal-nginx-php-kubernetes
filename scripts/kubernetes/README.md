# Kubernetes deployment files
This directory contains the manifests to create persistent volumes, persistent volume claims, pod deployments, and service definitions.

It also includes a properties file template for Bluemix services. By copying the file to `service-credentials.txt` Kubernetes can then create secrets from each value in that file as a key value dictionary.

These in turn are configured in the pod/service manifests as environment variables.
