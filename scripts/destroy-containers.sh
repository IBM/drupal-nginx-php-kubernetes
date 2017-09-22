#!/bin/bash
set -x

kubectl delete deployment,service,pvc,rs --all
