#!/bin/bash

# TODO
# Need to find way to grab previous tags as ENV variables
# Add ability to rollback on failed deployment

echo "Starting deploy stage"

cd scripts

#Pulling image details
IMAGE=$(grep "IMAGE=" pipeline/build.properties|cut -d'=' -f2)
REGISTRY_URL=$(grep "REGISTRY_URL" pipeline/build.properties|cut -d'=' -f2)
REGISTRY_NAMESPACE=$(grep "REGISTRY_NAMESPACE" pipeline/build.properties|cut -d'=' -f2)

if kubectl get deployments | grep "${IMAGE}" ; then

  #Applying configs

  kubectl set image deployment/${IMAGE} ${IMAGE}="${REGISTRY_URL}/${REGISTRY_NAMESPACE}/code-${IMAGE}:latest"
  echo $?

  kubectl rollout status deployment/${IMAGE}
  echo $?

  kubectl get pods

else

  kubectl apply -f kubernetes/${IMAGE}.yaml

  echo $?

  kubectl get pods

fi
