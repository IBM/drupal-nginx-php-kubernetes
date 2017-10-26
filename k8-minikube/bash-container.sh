#!/usr/bin/env bash

kubectl exec -i -t $(kubectl get pod -l "app=$1" -o jsonpath='{.items[0].metadata.name}') -c "${2}" -- bash

# Dump the Json so that you can narrow it down using Json Path:
# kubectl get pod -l "app=php-fpm" -o=json

# Example: the json path
# .items[0].spec.containers[?(@.name=="php-cli-sidecar-phpfpm")].name

# Example: get container name.
# └─[$]> kubectl get pod -l "app=php-fpm" -o jsonpath='{.items[0].spec.containers[?(@.name=="php-cli-sidecar-phpfpm")].name}'
# php-cli-sidecar-phpfpm

# Connect to a particular container.
# kubectl exec -i -t $(kubectl get pod -l "app=php-fpm" -o jsonpath='{.items[0].metadata.name}') -c php-cli-sidecar-phpfpm -- bash
