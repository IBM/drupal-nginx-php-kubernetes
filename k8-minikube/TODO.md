TODO
====

- [ ] The PHP-CLI image should be able to run drush commands against any site.
- [ ] NGINX image should have a sane default configuration (currently 504
      Gateway Time-out).
- [ ] Have a application side-cart pod/container or volume accessible by all
      base containers (PHP-FPM, Nginx, and PHP-CLI/Drush).
- [ ] Drush SQL-SYNC working on cli container

---

## Brainstorming

Reference:

- Pod patterns: http://blog.kubernetes.io/2015/06/the-distributed-system-toolkit-patterns.html

### thinking right now

a) shared volume

- run composer install on cli container
- save that code to a target volume shared by all containers
- the volume does not have inherent versioning

Empty dir pattern:
https://kubernetes.io/docs/tasks/access-application-cluster/communicate-containers-same-pod-shared-volume/
side car pattern: https://kubernetes.io/docs/user-guide/walkthrough/

Empty dir drawbacks:

- Good for sharing code between containers.
- The tmpfs/ramdisk is endemic to the pod, and it's contents cannot be seen by
  different pods.
- So the contents of the tmpdir on the PHP-FPM are not the same as the NGINX pod
  (tested, verified).

What good does it do ?

- Running a sidecar container with php-cli that does the app update ceremonies
  in each pod.
- Each pod would have to run the sidecar container to pull code via php-cli.

b) app image

- the code lives an image, that runs composer install drupal
- the image has versioning and tracking capabilities
- the app image can be deployed to a pod
- how does the nginx and php-fpm pods see the app image
- how do they access the app image's contents

### Job controller to share and update code

- Mount emptydir? Shared across all containers.
- Whenever there is a git push
- Run job
- Job runs cli container,
- CLI container runs required composer install or update commands.
- empty dir volume mounted to job spec with drush container
- New code is placed by drush container into empty dir volume
- empty dir volume is shared across all pod/containers
- nginx/php-fpm/php-cli are pointing to empty dir as web root
- they do not need to restart to see the new code, they can just serve it immediatly

### emptydir pull

- The main containers don't have any code when staring
- the empty dir is populated with code once the cluster is running

### Daemonset

- Ensures all nodes are running a particular pod.
- This runs at a higher level than we want probably, we probably want to run
  something at the pod level.

### Cron job

- Could be used to pull from git repos
- But I'd rather see automatic push than pull

### Init containers

- I don't need the code for the base image containers to be running, so this
  one's probably out.
