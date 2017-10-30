#!/usr/bin/env bash

set +x

# Start minikube.
minikube start

# Connect Docker and kubectl to Minikube context.
eval $(minikube docker-env)

# Delete everything.
kubectl delete deployment,service,rs --all

# Recreate all services.
kubectl apply -f volumes -f pods-services

# Show system status.
kubectl get deployment,service,rs,pods

# Show nginx endpoint, automatically shows up when ready.
minikube service nginx --url

# Open default browser to Nginx
minikube service nginx

# Pop open the local dashboard.
minikube dashboard

# Double check docker status, should show minikube containers.
# docker ps

# Nginx is now ready, start tailing it.
# kubectl logs -f nginx
# kubectl logs -f nginx-3049359248-5hvt9
