#!/bin/bash
set -x

# Create the shared persistent volume
# Create the deployment replication controllers for NGINX and PHP-FPM
# Create the services for the NGINX and PHP-FPM deployment

# Processes everything in the kubernetes folder
kubectl apply -f kubernetes

kubectl describe deployment php-fpm
kubectl describe service php-fpm
kubectl describe deployment nginx
kubectl describe service nginx
