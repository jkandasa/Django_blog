# django blog

A blog application made on Django.<br>
Added container support.

* Dockerfiles are located in [docker dir](/docker)<br>
* Deployment helper files are in [deploy dir](/deploy)

## Deploy in a container environment
### docker
```bash
./deploy/docker/plain-docker.sh
```

### docker compose
```bash
docker-compose up -f ./deploy/docker/docker-compose.yaml
```

### Kubernetes / OpenShift
* creates a namespace `sample-app` and uses that namespace for all the resources
```bash
# update 'StorageClassName' in 'deploy.yaml' and run
kubectl create -f ./deploy/kubernetes/deploy.yaml
```
#### ingress creation
```bash
# update 'host' in ingress.yaml' and run
kubectl create -f ./deploy/kubernetes/ingress.yaml
```

#### route creation (only in OpenShift)
```bash
oc create -f ./deploy/kubernetes/openshift-route.yaml
```

## Access Frontend
* default django admin username and password are `admin` / `admin`
### docker / docker compose
* your host firewall should allow inbound access to the port `8080`
* user portal: http://<host-ip>:8080
* admin portal: http://<host-ip>:8080/admin

### Kubernetes / OpenShift
* user portal: http://frontend.<cluster-domain>
* admin portal: http://frontend.<cluster-domain>/admin