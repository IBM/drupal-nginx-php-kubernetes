## Managing Drupal clusters
You can use the PHP-CLI container to execute regular `bash` commands or `drush` commands against the deployed staging and production systems.

## Execute arbitrary commands
- Use `kubectl get pods` to find the name of the PHP-CLI container
- Use `scripts/pipeline/kube-exec.sh` and pass the name of the container instance
- You will be in the `/root/drush/` folder where you can run ad hoc commands or scripts added to the image from the `code/drush` directory.
- For example `./transfer-data.sh` or `./transfer-files.sh`
- You can also invoke those as a one liner with
  - `kubectl exec $PHP_CLI_CONTAINER_NAME /root/drush/transfer-data.sh`
  - `kubectl exec $PHP_CLI_CONTAINER_NAME /root/drush/transfer-files.sh`

## Execute Drush commands
- As above, you can exec into the PHP-CLI container and run `drush` commands as needed.
- For example
  - `drush sql-cli --db-url="mysql://${MYSQL_USER_STG}:${MYSQL_PASS_STG}@${MYSQL_HOST_STG}:${MYSQL_PORT_STG}/${MYSQL_NAME_STG}"`
  - `drush sql-cli --db-url="mysql://${MYSQL_USER_PRD}:${MYSQL_PASS_PRD}@${MYSQL_HOST_PRD}:${MYSQL_PORT_PRD}/${MYSQL_NAME_PRD}"`
