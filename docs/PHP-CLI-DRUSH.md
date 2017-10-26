## Manging Drupal clusters
You can use the PHP-CLI container to execute regular `bash` commands or `drush` commands against the deployed system.

## Execute arbitrary commands
- Use `kubectl get pods` to find the name of the PHP-CLI container
- Use `scripts/pipeline/kube-exec` and pass the name of the container instance
- You will be in the `/root/drush/` folder where you can run ad hoc commands or scripts added to the image from the `code/drush` directory.
- For example `./backup-database.sh`

## Execute Drush commands
- As above, you can exec into the PHP-CLI container and run `drush` commands as needed.
- For example `drush sql-cli --db-url="mysql://${MYSQL_USER}:${MYSQL_PASS}@${MYSQL_HOST}/${MYSQL_NAME}"`
- For example `drush sql-dump --db-url="mysql://${MYSQL_USER}:${MYSQL_PASS}@${MYSQL_HOST}/${MYSQL_NAME}" > /root/backups/drush-backup.sql`
