#!/bin/bash

# TODO
# Need to find way to grab previous tags as ENV variables
# Add ability to rollback on failed deployment


echo "Starting deploy stage"

CONFIG_DEPLOY=$(grep "CONFIG_DEPLOY" build.properties|cut -d'=' -f2)
CODE_DEPLOY=$(grep "CODE_DEPLOY" build.properties|cut -d'=' -f2)

echo "$CONFIG_DEPLOY"
echo "$CODE_DEPLOY"

#Applying configs
cd scripts/

if [ "$CONFIG_DEPLOY" = true ] ; then

  kubectl set image deployment/config-nginx config-nginx="${REGISTRY_URL}/${REGISTRY_NAMESPACE}/config-nginx:latest"
  kubectl rollout status deployment/nginx

  kubectl set image deployment/config-php-fpm config-php-fpm="${REGISTRY_URL}/${REGISTRY_NAMESPACE}/config-php-fpm:latest"
  kubectl rollout status deployment/nginx

  kubectl set image deployment/config-php-cli config-php-cli="${REGISTRY_URL}/${REGISTRY_NAMESPACE}/config-php-cli:latest"
  kubectl rollout status deployment/nginx

  kubectl set image deployment/code-nginx code-nginx="${REGISTRY_URL}/${REGISTRY_NAMESPACE}/code-nginx:latest"
  kubectl rollout status deployment/code-nginx

  kubectl set image deployment/code-php-fpm code-php-fpm="${REGISTRY_URL}/${REGISTRY_NAMESPACE}/code-php-fpm:latest"
  kubectl rollout status deployment/code-php-fpm

  kubectl set image deployment/code-php-cli code-php-cli="${REGISTRY_URL}/${REGISTRY_NAMESPACE}/code-php-cli:latest"
  kubectl rollout status deployment/code-php-cli

  kubectl get pods

elif [ "$CODE_DEPLOY" = true ] ; then

  kubectl set image deployment/code-nginx code-nginx="${REGISTRY_URL}/${REGISTRY_NAMESPACE}/code-nginx:latest"
  kubectl rollout status deployment/code-nginx

  kubectl set image deployment/code-php-fpm code-php-fpm="${REGISTRY_URL}/${REGISTRY_NAMESPACE}/code-php-fpm:latest"
  kubectl rollout status deployment/code-php-fpm

  kubectl set image deployment/code-php-cli code-php-cli="${REGISTRY_URL}/${REGISTRY_NAMESPACE}/code-php-cli:latest"
  kubectl rollout status deployment/code-php-cli

  kubectl get pods


else

  echo "No deployments needed"

fi
