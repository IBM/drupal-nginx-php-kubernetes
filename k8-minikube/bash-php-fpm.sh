#!/usr/bin/env bash

kubectl exec -i -t $(kubectl get pod -l "app=php-fpm" -o jsonpath='{.items[0].metadata.name}') -- bash
