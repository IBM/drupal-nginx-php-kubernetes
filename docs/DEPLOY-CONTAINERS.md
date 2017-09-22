## Review the container deployment configuration file (storage mounts)
TODO

## Build container images and push to the private registry
Log into Bluemix and the Container Registry. Make sure your target organization and space is set.

bx plugin install container-registry -r Bluemix

## Deploy the container images to the Kubernetes cluster
bx cs cluster-config

Set up the imagePullSecret
bx cr token-add --description "description_here" --non-expiring
bx cr token-list
bx cr token-get <token_id_from_above>
kubectl --namespace default create secret docker-registry image-pull --docker-server="registry.ng.bluemix.net" --docker-username="token" --docker-password="xxx" --docker-email="email_here"

- kubectl get secrets --namespace default

https://console.bluemix.net/docs/containers/cs_cluster.html#bx_registry_other
