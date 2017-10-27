#!/bin/bash
set -x

# If needed. Otherwise set up the cluster and the services in the UI.

# Based on https://ibm-blockchain.github.io/setup/

# 1. Prepare required CLIs and plugins
# 1.1. Download and install kubectl CLI
#   https://kubernetes.io/docs/tasks/kubectl/install/
# 1.2. Download and install the Bluemix CLI
#   http://clis.ng.bluemix.net/ui/home.html
#
# 1.3. Add the bluemix plugins repo
#   bx plugin repo-add bluemix https://plugins.ng.bluemix.net
#
# 1.4. Add the container service plugin
#   bx plugin install container-service -r bluemix

# 2. Setup a cluster
# 2.1. Point Bluemix CLI to production API
#   bx api api.ng.bluemix.net
#
# 2.2. Login to bluemix (use --sso if federated)
#   bx login
#
# 2.3. Wait for the cluster to be ready
#   $ bx cs clusters
#
# 2.4. Configure kubectl to use the cluster
#   $ bx cs cluster-config blockchain
#   export KUBECONFIG=...

# 3. Provision MySQL from Compose or ClearDB
# 3.1. TODO:

# 4. Provision Redis from Compose or Redis Labs
# 4.1. TODO:

# 5. Provision memcached from Redis Labs
# 5.1. TODO:
