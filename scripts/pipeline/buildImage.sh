#!/bin/bash

echo -e "Build environment variables:"
echo "REGISTRY_URL=${REGISTRY_URL}"
echo "REGISTRY_NAMESPACE=${REGISTRY_NAMESPACE}"
echo "IMAGE_NAME=${IMAGE_NAME}"

IMAGE=$IMAGE_NAME

echo $IMAGE

# Check for mentions of the /config directory in the last commit.
if [ git log -p -1 | grep "/config" ] ; then

  echo "Changes found in /config directory"

  # Call the build-on-config-change.sh script
  . build-on-config-change-2.sh
  . build-on-code-change-2.sh

# Check for changes to the /code directory in the last commit.
elif [ git log -p -1 | grep "/code" ] ; then

  echo "Changes found in /code directory"

  # Call the build-on-code-change.sh script
  . build-on-code-change-2.sh

else
  echo "No changes detected in the /config or /code directories. No build necessary."
fi

# Save the registry url and namespace in the build artifacts to be used in deploy stage.
echo "REGISTRY_URL=${REGISTRY_URL}" >> $ARCHIVE_DIR/build.properties
echo "REGISTRY_NAMESPACE=${REGISTRY_NAMESPACE}" >> $ARCHIVE_DIR/build.properties
echo "IMAGE=${IMAGE}" >> $ARCHIVE_DIR/build.properties

echo -e "Copying artifacts needed for deployment and testing"

# IMAGE_NAME from build.properties is used by Vulnerability Advisor job to reference the image qualified location in registry
echo "IMAGE_NAME=${REGISTRY_URL}/${REGISTRY_NAMESPACE}/${IMAGE}:latest" >> $ARCHIVE_DIR/build.properties
