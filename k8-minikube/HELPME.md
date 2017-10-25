
### Tail the logs for a container

Get the name:

    kubectl get deployment,service,rs,pods

Tail the container:

    kubectl logs -f <container-name>

### Connect to a container (exec bash/sh shell)

Get the nginx pod name:

    └─[$]> kubectl get pods
    NAME                       READY     STATUS    RESTARTS   AGE
    nginx-3049359248-5hvt9     1/1       Running   0          23m
    php-cli-290158884-sf92z    1/1       Running   0          23m
    php-fpm-3522852564-25ph5   1/1       Running   0          23m
    php-fpm-3522852564-2p379   1/1       Running   0          23m

Execute the sh shell on the nginx container:

    └─[$]> kubectl exec nginx-3049359248-5hvt9 -i -t sh
