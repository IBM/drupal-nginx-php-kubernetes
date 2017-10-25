#!/usr/bin/env bash

set +x

# Delete everything.
kubectl delete deployment,service,rs --all

# Recreate all services.
kubectl apply -f volumes -f pods-services

# Show system status.
kubectl get deployment,service,rs,pods

# Show nginx endpoint.
minikube service nginx --url

# Open default browser to Nginx
minikube service nginx
