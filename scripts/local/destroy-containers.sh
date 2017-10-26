#!/bin/bash
set -x

kubectl delete deployment,service,rs,pvc --all
