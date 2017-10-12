#!/bin/bash

#Connect to a different container service API by uncommenting and specifying an API endpoint.
#bx cs init --host https://us-south.containers.bluemix.net

#Check cluster availability
ip_addr=$(bx cs workers $PIPELINE_KUBERNETES_CLUSTER_NAME | grep normal | awk '{ print $2 }')
if [ -z $ip_addr ]; then
  echo "$PIPELINE_KUBERNETES_CLUSTER_NAME not created or workers not ready"
  exit 1
fi

cd scripts/
kubectl apply -f $IMAGE_NAME.yml
