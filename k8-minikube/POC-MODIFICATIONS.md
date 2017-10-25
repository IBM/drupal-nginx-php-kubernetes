POC MODIFICATIONS
=================

This document covers the modifications done by @rallen to the POC. Not all these
modifications are meant to be ported back to the main POC, rather it's a POC to
the POC.

The purpose of this exercise is to demonstrate alternate Docker build workflows
(mainly), as well as provide a working example of how to develop against
Kubernetes using a local, single-cluster Minikube environment for faster
prototyping and without impacting any cloud resources.

### Image PUSHes to IBM Container Registry

There is no image pushing happening at this moment for all the Dockerfiles in
built in the k8-minikube directory. All these builds are local-only.

The custom (dumbed-down) build script that I created for building my Dockerfiles
does not have docker push enable (i.e., not pushing to IBM Container Registry atm).


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
- NO "CUSTOM" POC code is being used atm, because the assumption is that this code
  will be coming from an external repo (per @chris comments).

Other modifications (cont.d')

- Image builds are being done on the alexanderallen namespace instead of jjdojo
  to avoid any conflicts with current POC images present on the cloud or locally.

### Things This Other POC Does Not Have

There are some extremely useful and important things present in the current IBM
POC that my own POC lacks, and does not try to emulate.

Some Kubernetes components are endemic to the cloud provider that they're
running on. Some examples of things the IBM POC provides that are IBM specific
and would never work on Minikube, or any other provider for that matter (Google
Container Environment, Amazon AWS, Azure, etc.):

- Volumes and Volume Claims: These are provider specific and neccesary.
- Storage volume initialization scripts (i.e., code-php-fpm/start.sh).
- Networking: LoadBalancer works on differently in each provider, and is not
  even supported by MiniKube, MiniKube has to restort to use NodePort instead of
  LoadBalancer, AWS requires different configuration, etc.
- Provider plugin configuration and usage: The IBM POC has done a really nice
  job of documenting how to setup and use the different `bx` components.
- Secrets: This POC is not using setting up any, and piggy-backing on any
  secrets configuration done in the IBM BlueMix POC (recycling them in the
  various container manifests).
- Decoupled configuration: This sub-POC a lot, if not most of IBM BlueMix's
  variables that are used in the Dockerfile build process for simplification,
  not soemthing you would really want to do in real life.
- Provider-specific scripts: The IBM BlueMix POC has plenty of awesome devops
  scripts to automate all the things build and deploy, this POC has 1/10 of that
  effort.

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

### Community Images Dockerfile Instructions

There are some instructions in the upstream Docker files we're using for PHP-FPM
and NGINX that we are duplicating (with the same exact values) in our downstream
images.

I've removed these duplicate instructions, such as `EXPOSE 9000`, because IMO
they create the sense that the upstream images are not setting those, when in
fact they are.

The same thing applies to launching the PHP-FPM process. The Docker community
image we're using for PHP-FPM already has the `CMD` and `ENTRYPOINT`
instructions that start the process with the values we need, therefore there's
no need to specify those in our Dockerfiles, unless we plan to modify those
upstream values, which we are not doing ATM (and there's no need to either, at
least for now).

I've successfully launched the PHP-FPM container and started that same process
using just the upstream `CMD` et al instructions.

### Community Image Configuration Files

I have tracked down the location of the PHP-FPM configuration files in the
community images, and copied them back to my POC.

When you launch the PHP-FPM container for the first time, you don't know what is
configuring what and where, unless you read the Dockerfile on http://docker.hub.

I think that copying those configuration files to the same repository that
builds our custom Dockerfiles gives more visibility of what's the current
configuration being used (for example, the community image won't even have vim
included). By having these conf files "locally", it's easier to read them.

I've also added the `COPY` instruction to copy those configuration files back
into PHP-FPM image. What this means is that using this pattern we can more
visibly fine-tune the PHP-FPM configuration, without populating the Dockerfile
with customization instructions (they can be done in the configuration files
directly). It's less error prone, easier to debug, and provides more control.
The downside is that you won't inherit any "hotfixes" done to those upstream
config files.

In my personal POC I used this approach to enable the /status and /ping pages on
the PHP-FPM container, for example, and successfully test connectivity between
the NGINX and PHP-FPM containers.

I've documented the workflow on how to do this on the HELPME.md document.

---

Updated 10/25, Wednesday, Oct. 2017 (rallen)
