POC MODIFICATIONS
=================

This document covers the modifications done by @rallen to the POC. Not all these
modifications are meant to be ported back to the main POC, rather it's a POC to
the POC.

The purpose of this exercise is to demonstrate alternate Docker build workflows
(mainly).

### Modifications

- Simplified build from config- and code- matrix to three base images: nginx,
  php-fpm, and php-cli.
- The PHP-CLI image is built on top (layered) of the PHP-FPM image.
- Instead of having three (3x) code images, there's only one.
- Tracked down the location of community image configuration files, and copied
  them back to the POC (to this sub-POC, the k8-minikube folder).
- Enabled the /status and /ping pages in the PHP-FPM process to test
  communication between containers. This is not something you would obviously
  have enabled in prod, but it is extremely useful here.
- Successfully tested communcation between NGINX and PHP-FPM using the /status
  and /ping PHP-FPM pages.
- Created two bash scripties, `bash-nginx.sh` and `bash-php-fpm.sh` that show
  how to automatically find the container name in the cluster and "exec" bash
  into it for quick debugging (it is a bash one-liner command).
- Updated the build scripts (simplified into `build-base-images.sh`).

### Code Image (sidecar, volume?)

The PHP-FPM, PHP-CLI, and Nginx images have no reason to constantly change, and
therefore there should be no reason to have a multi-tiered 6 image matrix for
these 3 applications. These 3 applications are fairly static and should not have
any (ideally) application code in them.

The application code should ideally live in it's own container, which gets
constantly rebuilt (automatically) as code pushes come into the a pre-configured
git repository.

This means that in this POC-of-POC's world, there would only be around 4 images
total: PHP-FPM, PHP-CLI, NGINX, and CODE image(s).

### Layered Workflow (for Docker images)

The layered workflow means that the PHP-CLI and PHP-FPM images are no longer
separate. This means that:

- There's no need to re-install PHP-FPM twice on two images with completely
  different purpose.
- It ensures that the PHP-FPM and PHP-CLI images have the exact same underlying
  components (PHP-FPM and all it's system dependencies).
- Any updates to the PHP-FPM image are made only ONCE, as opposed to have to
  update particular segments of both the PHP-FPM and PHP-CLI image anytime a fix
  is done to the (former) PHP-FPM-CONFIG image.
- The PHP-CLI image installs just what it needs, namely drush and composer.
- There is no need to have drush and composer in the PHP-FPM image, because the
  PHP-FPM container will never use drush and composer.

---

Updated 10/25, Wednesday, Oct. 2017 (rallen)
