#!/bin/bash

echo -e "Build environment variables:"
echo "REGISTRY_URL=${REGISTRY_URL}"
echo "REGISTRY_NAMESPACE=${REGISTRY_NAMESPACE}"
echo "IMAGE_NAME=${IMAGE_NAME}"
echo "BUILD_NUMBER=${BUILD_NUMBER}"

# Learn more about the available environment variables at:
# https://console.bluemix.net/docs/services/ContinuousDelivery/pipeline_deploy_var.html#deliverypipeline_environment

# To review or change build options use:
# bx cr build --help


if git log -p -1 | grep "/config/${IMAGE_NAME}-version.txt"; then
  echo "Changes found in /config directory"
  echo -e "Checking for Dockerfile at the repository root"
  if [ -f scripts/docker/$IMAGE_NAME/Dockerfile ]; then
     echo "Dockerfile found"
  else
      echo "Dockerfile not found"
      exit 1
  fi

  echo -e "Building container image"
  set -x
  bx cr build -t $REGISTRY_URL/$REGISTRY_NAMESPACE/$IMAGE_NAME:latest scripts/docker/$IMAGE_NAME
  set +x

  echo -e "Copying artifacts needed for deployment and testing"
  # IMAGE_NAME from build.properties is used by Vulnerability Advisor job to reference the image qualified location in registry
  echo "DEPLOY_REQUIRED=true" >> $ARCHIVE_DIR/build.properties
  cp -r scripts/kubernetes/ $ARCHIVE_DIR

else

  echo "No build needed for ${IMAGE_NAME}"
  echo "DEPLOY_REQUIRED=false" >> $ARCHIVE_DIR/build.properties
fi

if git log -p -1 | grep "/code"; then
  # Do build stuff here for the custom code
  echo "Doing custom build step"
fi

echo "REGISTRY_URL=${REGISTRY_URL}" >> $ARCHIVE_DIR/build.properties
echo "REGISTRY_NAMESPACE=${REGISTRY_NAMESPACE}" >> $ARCHIVE_DIR/build.properties
echo "IMAGE_NAME=${IMAGE_NAME}" >> $ARCHIVE_DIR/build.properties
