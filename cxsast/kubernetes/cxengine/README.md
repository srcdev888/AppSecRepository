# Deploying CxSAST Engine on Kubernetes

- Author: Pedric Kng
- Updated: 21 Aug 2021

This repository describes the deployment of CxSAST linux engine container on Minikube(K8)

---

## Pre-requisites

- Installed CxSAST Manager
- Minikube with docker driver
- CxSAST Linux docker engine installation pack
- Network connectivity

  | Source   | Destination               | TCP/UDP | Port   | Direction | Description                 |
  | -------- | ------------------------- | ------- | ------ | --------- | --------------------------- |
  | CxEngine | CxSAST Access Control URL | HTTP/S  | 80/443 | ->        | service user authentication |
  | CxEngine | CxSAST Active MQ          | TCP     | 80/443 | ->        | Updating scan results       |
  | CxSAST   | CxEngine                  | HTTP/S  | 80/443 | ->        | Connect for engine service  |

## Deployment steps

We will use the below kubernetes object description file for the setup

- [cx-engine-server-deployment.yaml](cx-engine-server-deployment.yaml)
   
  \*Refer to the installer 'readme' for instructions to retrieve above configurable variables

  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    annotations:
      kompose.cmd: kompose convert
      kompose.version: 1.22.0 (955b78124)
    creationTimestamp: null
    labels:
      io.kompose.service: cx-engine-server
    name: cx-engine-server
    namespace: checkmarx-demo
  spec:
    replicas: 1
    selector:
      matchLabels:
        io.kompose.service: cx-engine-server
    strategy:
      type: Recreate
    template:
      metadata:
        annotations:
          kompose.cmd: kompose convert
          kompose.version: 1.22.0 (955b78124)
        creationTimestamp: null
        labels:
          io.kompose.service: cx-engine-server
      spec:
        containers:
          - env:
              # To enable TLS on CxEngine, default is false.
              - name: CX_ENGINE_TLS_ENABLE
                value: "false"
              # CxSAST access control url
              - name: CX_ES_ACCESS_CONTROL_URL
                value: http://192.168.137.50/CxRestAPI/auth
              # CxEngine endpoint
              - name: CX_ES_END_POINT
                value: http://127.0.0.1:8088
              # CxSAST activemq password
              - name: CX_ES_MESSAGE_QUEUE_PASSWORD
                value: "217070109180237009073095180245165094186241227214"
              # CxSAST activemq url
              - name: CX_ES_MESSAGE_QUEUE_URL
                value: tcp://192.168.137.50:61616
              # CxSAST activemq username
              - name: CX_ES_MESSAGE_QUEUE_USERNAME
                value: cxuser
            # CxEngine docker image
            image: cx-engine-server:latest
            name: cx-engine-server
            imagePullPolicy: Never
            ports:
              # CxEngine container port
              - containerPort: 8088
            resources: {}
            volumeMounts:
              - mountPath: /var/checkmarx
              name: cx-engine-server-claim0
      restartPolicy: Always
      volumes:
          - name: cx-engine-server-claim0
          persistentVolumeClaim:
              claimName: cx-engine-server-claim0
  status: {}
  ``` 

- [cx-engine-server-service.yaml](cx-engine-server-service.yaml)

  ```yaml
  apiVersion: v1
  kind: Service
  metadata:
    annotations:
      kompose.cmd: kompose convert
      kompose.version: 1.22.0 (955b78124)
    creationTimestamp: null
    labels:
      io.kompose.service: cx-engine-server
    name: cx-engine-server
    namespace: checkmarx-demo
  spec:
    ports:
      - name: "cx-engine-server"
        # Container port for mapping
        port: 8088
        # Cluster IP port for mapping
        targetPort: 8088
    selector:
      io.kompose.service: cx-engine-server
  status:
    loadBalancer: {}
  ```

- [cx-engine-server-claim0-persistentvolumeclaim.yaml](cx-engine-server-claim0-persistentvolumeclaim.yaml)

  ```yaml
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    creationTimestamp: null
    labels:
      io.kompose.service: cx-engine-server-claim0
    name: cx-engine-server-claim0
    namespace: checkmarx-demo
  spec:
    accessModes:
      - ReadWriteOnce
    resources:
      requests:
        storage: 100Mi
  status: {}
  ```

    ```bash
    # Create a separate namespace for the Checkmarx engine
    kubectl create namespace checkmarx-demo

    # Create the Cx Engine service, deployment and volume
    kubectl create -f cx-engine-server-claim0-persistentvolumeclaim.yaml,cx-engine-server-service.yaml,cx-engine-server-deployment.yaml

    # Check that the relevant cx-engine service, deployment, and volume is up
    kubectl get all --namespace checkmarx-demo

    # Get URL to access CxEngine http://<url>:8088/swagger
    kubectl get service cx-engine-server --namespace checkmarx-demo

    # The returned engine URL is a cluster IP address that cannot be reached externally. 
    # To be accessible, we can port forward host ip address from 8088 to cluster port 8088
    kubectl --namespace checkmarx-demo port-forward --address 0.0.0.0 service/cx-engine-server 8088:8088
    ```

## Miscellenous

- Install Minikube with docker driver

  ```bash
  # Execute minikube with kubernetes on local linux and docker
  minikube start --driver=docker
  ```

- Minikube by default only pulls from remote registry, therefore we can force CxSAST engine image to be loaded manually.

  ```bash
  # To point your terminal to use the docker daemon inside minikube run this:
  # Do a Docker PS, and you will see the containers inside Minikube
  eval $(minikube docker-env)

  # Loading CxEngine tar into Minikube
  docker image load < cx-engine-server.tar

  # List image cx-engine-server > docker.io/library/cx-engine-server:latest
  docker image ls
  ```

# References

Kompose [[1]]  
MiniKube load image [[2]]  
Running a local docker registry [[3]]  
Minikube external IP not matching host public IP [[4]]  

[1]: https://kubernetes.io/docs/tasks/configure-pod-container/translate-compose-kubernetes/ "Kompose"
[2]: https://minikube.sigs.k8s.io/docs/commands/image/#minikube-image-load "MiniKube load image"
[3]: https://docs.docker.com/registry/deploying/ "running a local docker registry"
[4]: https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/ "Kubernetes port forwardingP"
