#!/usr/bin/env bash

# This is a little extreme: the pod name changes:
# kubectl delete pod $(kubectl get pod -l "app=nginx" -o jsonpath='{.items[0].metadata.name}')

# Recreate the pod without changing it's name.
kubectl replace --force -f pods-services/nginx.yaml

# Show nginx endpoint, automatically shows up when ready.
minikube service nginx --url
