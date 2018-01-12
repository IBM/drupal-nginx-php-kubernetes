#!/bin/bash

echo -e "Build environment variables:"
echo "REGISTRY_URL=${REGISTRY_URL}"
echo "REGISTRY_NAMESPACE=${REGISTRY_NAMESPACE}"
echo "IMAGE_NAME=${IMAGE_NAME}"

IMAGE=$IMAGE_NAME

echo $IMAGE

echo "Files changed in previous commit :"
echo `git log -m -1 --name-only` 

# Check for mentions of the config and docker directories in the last commit.
if [ `git log -m -1 --name-only | grep "config/"` ] || [ `git log -m -1 --name-only | grep "docker/"` ] ; then
  echo "Changes found in config/ or docker/ directory"
  # Call the build-on-config-change.sh script
  . ./pipeline-build-on-config-change.sh
  . ./pipeline-build-on-code-change.sh
# Check for changes to the /code directory in the last commit.
elif git log -m -1 --name-only | grep "code/" ; then
  echo "Changes found in code/ directory"
  # Call the build-on-code-change.sh script
  . ./pipeline-build-on-code-change.sh
fi

# Pass kubernetes files along with build artifacts
cp -r ../kubernetes/ $ARCHIVE_DIR

echo -e "Copying artifacts needed for deployment and testing"

# Save the registry url and namespace in the build artifacts to be used in deploy stage.
echo "REGISTRY_URL=${REGISTRY_URL}" >> $ARCHIVE_DIR/build.properties
echo "REGISTRY_NAMESPACE=${REGISTRY_NAMESPACE}" >> $ARCHIVE_DIR/build.properties
echo "IMAGE=${IMAGE}" >> $ARCHIVE_DIR/build.properties

# IMAGE_NAME from build.properties is used by Vulnerability Advisor job to reference the image qualified location in registry
echo "IMAGE_NAME=${REGISTRY_URL}/${REGISTRY_NAMESPACE}/${IMAGE}:latest" >> $ARCHIVE_DIR/build.properties
