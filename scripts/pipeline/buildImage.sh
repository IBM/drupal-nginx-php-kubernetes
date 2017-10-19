#!/bin/bash

echo -e "Build environment variables:"
echo "REGISTRY_URL=${REGISTRY_URL}"
echo "REGISTRY_NAMESPACE=${REGISTRY_NAMESPACE}"
echo "IMAGE_NAME=${IMAGE_NAME}"
echo "BUILD_NUMBER=${BUILD_NUMBER}"

# Check for mentions of the /config directory in the last commit.
if [ git log -p -1 | grep "/config" ]; then

  echo "Changes found in /config directory"

  # Call the build-on-config-change.sh script
  . build-on-config-change.sh

  echo "CONFIG_DEPLOY=true" >> $ARCHIVE_DIR/build.properties

# Check for changes to the /code directory in the last commit.
elif [ git log -p -1 | grep "/code" ]; then

  echo "Changes found in /code directory"

  # Call the build-on-code-change.sh script
  . build-on-code-change.sh

  echo "CODE_DEPLOY=true" >> $ARCHIVE_DIR/build.properties

else
  echo "No changes detected in the /config or /code directories. No build necessary."
fi

# Save the registry url and namespace in the build artifacts to be used in deploy stage.
echo "REGISTRY_URL=${REGISTRY_URL}" >> $ARCHIVE_DIR/build.properties
echo "REGISTRY_NAMESPACE=${REGISTRY_NAMESPACE}" >> $ARCHIVE_DIR/build.properties
