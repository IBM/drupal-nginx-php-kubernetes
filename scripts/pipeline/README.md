# Pipeline scripts
This directory contains the legacy scripts for building and deploying from IBM DevOps Services to the IBM Container Service.

The goal is to have these replace the files in the `local` directory so they can be invoked by a pipeline or by the developer on his or her workstation.

### Note About the scripts

The buildImage.sh, deployScript.sh, and the scripts prefixed with "pipeline-" are used by the pipeline in IBM Cloud Platform to build and deploy to a cluster running in the cloud. These scripts require environment variables that are set as part of the pipeline process and will not work locally.
