#!/bin/bash

echo "Starting deploy stage"

cd scripts

#Pulling image details
IMAGE=$(grep "IMAGE=" pipeline/build.properties|cut -d'=' -f2)
REGISTRY_URL=$(grep "REGISTRY_URL" pipeline/build.properties|cut -d'=' -f2)
REGISTRY_NAMESPACE=$(grep "REGISTRY_NAMESPACE" pipeline/build.properties|cut -d'=' -f2)

echo "Current environment is: ${ENVIRONMENT}"

if kubectl get deployments | grep "${IMAGE}-${ENVIRONMENT}" ; then

  #Applying configs

  echo "Updating image in the deployment..."
  echo "Starting rolling update..."
  kubectl set image deployment/${IMAGE}-${ENVIRONMENT} ${IMAGE}-${ENVIRONMENT}="${REGISTRY_URL}/${REGISTRY_NAMESPACE}/code-${IMAGE}:latest"
  echo $?

  kubectl rollout status deployment/${IMAGE}-${ENVIRONMENT}
  echo $?

  kubectl get pods

else

  echo "No current deployment found. Creating a new deployment"
  kubectl apply -f kubernetes/${IMAGE}-${ENVIRONMENT}.yaml

  echo $?

  kubectl get pods

fi
