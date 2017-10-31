
### Installing MiniKube

TODO

### Using MiniKube

Start Minikube

    minikube start
    Starting local Kubernetes v1.7.5 cluster...
    Starting VM...
    Getting VM IP address...
    Moving files into cluster...
    Setting up certs...
    Connecting to cluster...
    Setting up kubeconfig...
    Starting cluster components...
    Kubectl is now configured to use the cluster.

Check status

    kubectl get nodes
    NAME       STATUS    ROLES     AGE       VERSION
    minikube   Ready     <none>    6m        v1.7.5

If opening another terminal windows, point Docker and Kubectl to
Minikube

    eval $(minikube docker-env)

### Accessing services in Minikube

Switching the nginx service from `LoadBalancer` to `NodePort`:

    └─[$]> kubectl get services
    NAME         TYPE           CLUSTER-IP   EXTERNAL-IP   PORT(S)        AGE
    kubernetes   ClusterIP      10.0.0.1     <none>        443/TCP        1d
    nginx        LoadBalancer   10.0.0.34    <pending>     80:32352/TCP   1d
    php-fpm      ClusterIP      10.0.0.93    <none>        9000/TCP       1d
    
    # Change spec.type to NodePort
    └─[$]> kubectl edit service nginx
    service "nginx" edited
    
    └─[$]> kubectl get services
    NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)        AGE
    kubernetes   ClusterIP   10.0.0.1     <none>        443/TCP        1d
    nginx        NodePort    10.0.0.34    <none>        80:32352/TCP   1d
    php-fpm      ClusterIP   10.0.0.93    <none>        9000/TCP       1d
    
    └─[$]> minikube service nginx
    Opening kubernetes service default/nginx in default browser...
    
    └─[$]> minikube service nginx --url
    http://192.168.99.100:32352

### MiniKube load balancer and nodeports


https://github.com/kubernetes/minikube/issues/950

> Currently minikube doesn't support LoadBalancer, it doesn't assign to
 it external IP. And services are supposed to access using minikube
 service service-name... is uses port mapping and it is quite cumbersome
 (esp if service exposes more then one port)

https://github.com/kubernetes/minikube/issues/38

Referenced by #950, #950 marked as a dupe of #38.

https://medium.com/@claudiopro/getting-started-with-kubernetes-via-minikube-ada8c7a29620

> Note we must use the type=NodePort because minikube doesn’t support the LoadBalancer service.

    $ kubectl expose deployment hello-node --type=NodePort
    $ kubectl get services
    $ curl $(minikube service hello-node --url)

https://github.com/kubernetes/minikube/issues/384

> LoadBalancer services run fine on minikube, just with no real external
 load balancer created. LoadBalancer services get a node port assigned
 too so you can access services via `minikube service <name>` to open
 browser or add `--url` flag to output service URL to terminal.
 Would that cover what you need or is there something more that you'd
 like to see?