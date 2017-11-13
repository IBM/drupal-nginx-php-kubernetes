## Ongoing development
Now that the Kubernetes cluster is provisioned and you have a set of containers running, the ongoing DevOps workflow will be to write code locally, push that to GitHub into the `config` or `code` directories, and that in turn will start a job to rebuild the container images with the versioned code. These images are in turn pushed to the private Docker registry, and pulled to run on the pods.

## Updating the base image configuration
Push updates to the `config` directory. The pipeline will detect changes and initiate a base image rebuild, and then another build on top for the `code` files.

## Updating the Drupal and code version
Push updates to the `code` directory. The pipeline will detect changes and initiate a custom image rebuild.

## Addressing security issues with Vulnerability Advisor
As container images are built and pushed to the IBM Cloud Container Registry, they are automatically scanned by the Vulnerability Advisor.

You can see whether there are any vulnerabilities in your images by listing the images:
```bash
bx cr images
```

If any of them are listed as `Vulnerable` you can then see the specific issues with:

```bash
bx cr va $IMAGE_NAME
```
