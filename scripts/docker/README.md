# Docker manifests
This directory contains the Dockerfiles to build base PHP and NGINX (`config`) images as well as the Drupal and custom site (`code`) images that are based on those.

If anything changes in the top level `config` directory, that should trigger both a `config` and `code` image rebuild and redeploy.

If anything changes in the top level `code` directory, that should trigger only a `code` image rebuild and redeploy.
