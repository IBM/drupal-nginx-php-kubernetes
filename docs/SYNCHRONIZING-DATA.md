## Synchronizing data and drush scripts
From time to time you may want to bring production data and files into the staging environment so that you have comparable environments.

## Synchronizing files
Execute the [`transfer-files.sh`](../code/drush/transfer-files.sh) script.

This can be done by connecting to the PHP-CLI container.

`kubectl exec $CONTAINER_NAME /root/drush/transfer-files.sh`


## Synchronizing data
Execute the [`transfer-data.sh`](../code/drush/transfer-data.sh) script.

`kubectl exec $CONTAINER_NAME /root/drush/transfer-data.sh`

## Executing drush scripts
Execute the [`drush-status.sh`](../code/drush/drush-status.sh) script.

`kubectl exec $CONTAINER_NAME /var/www/drupal/drush/drush-status.sh`

## Running arbitrary commands
You can enter a running container and execute commands by passing the container name to the [`kube-exec.sh`](../scripts/pipeline/kube-exec.sh) script.
