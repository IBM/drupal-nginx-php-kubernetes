#!/bin/bash

#Connect to a different container service API by uncommenting and specifying an API endpoint.
#bx cs init --host https://us-south.containers.bluemix.net

echo "Starting deploy stage"

DEPLOY_REQUIRED=$(grep "DEPLOY_REQUIRED" build.properties|cut -d'=' -f2)

#Pulling image details
IMAGE_NAME=$(grep "IMAGE_NAME" build.properties|cut -d'=' -f2)
REGISTRY_URL=$(grep "REGISTRY_URL" build.properties|cut -d'=' -f2)
REGISTRY_NAMESPACE=$(grep "REGISTRY_NAMESPACE" build.properties|cut -d'=' -f2)

echo "$IMAGE_NAME"
echo "$DEPLOY_REQUIRED"

if [ "$DEPLOY_REQUIRED" = true ] ; then

  echo "Changs have been made to images. Updating deployment"



  #Applying configs
  cd scripts/
  #kubectl apply -f kubernetes/$IMAGE_NAME.yaml

  kubectl set image deployment/$IMAGE_NAME $IMAGE_NAME="${REGISTRY_URL}/${REGISTRY_NAMESPACE}/${IMAGE_NAME}:latest"

  kubectl rollout status deployment/$IMAGE_NAME

else
  echo "No change in ${IMAGE_NAME} container"
fi
