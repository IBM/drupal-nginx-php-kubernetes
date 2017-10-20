#!/bin/bash

# TODO
# Need to find way to grab previous tags as ENV variables
# Add ability to rollback on failed deployment


echo "Starting deploy stage"

#Pulling image details
IMAGE=$(grep "IMAGE" build.properties|cut -d'=' -f2)
REGISTRY_URL=$(grep "REGISTRY_URL" build.properties|cut -d'=' -f2)
REGISTRY_NAMESPACE=$(grep "REGISTRY_NAMESPACE" build.properties|cut -d'=' -f2)


if [ kubectl get deployments | grep "${IMAGE}" ] ; then

  #Applying configs
  cd scripts/
  kubectl set image deployment/nginx nginx="${REGISTRY_URL}/${REGISTRY_NAMESPACE}/${IMAGE}:latest"
  echo $?

  kubectl rollout status deployment/nginx
  echo $?

  kubectl get pods

else

  cd scripts/
  kubectl apply -f kubernetes/$IMAGE.yml

  echo $?

  kubectl get pods

fi
