#!/bin/bash
set -e

# If needed first:
# kubectl delete deployment,service,rs,pvc --all
kubectl delete deployment,service,rs --all

# Create service credentials as a secret
kubectl delete secret service-credentials
kubectl create secret generic service-credentials --from-env-file=../kubernetes/secrets/service-credentials.txt

# Processes everything in the kubernetes folder:
# - Create the shared persistent volume
# - Create the deployment replication controllers for NGINX and PHP-FPM
# - Create the services for the NGINX and PHP-FPM deployment
kubectl apply -f ../kubernetes

# Confirm everything looks good

kubectl describe deployment php-fpm-stg
kubectl describe service php-fpm-stg
kubectl describe deployment nginx-stg
kubectl describe service nginx-stg

kubectl describe deployment php-fpm-prd
kubectl describe service php-fpm-prd
kubectl describe deployment nginx-prd
kubectl describe service nginx-prd
