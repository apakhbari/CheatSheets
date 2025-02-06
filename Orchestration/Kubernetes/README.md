# Kubernetes
```
 ___   _   _____   _______ 
|   | | | |  _  | |       |
|   |_| | | |_| | |  _____|
|      _||   _   || |_____ 
|     |_ |  | |  ||_____  |
|    _  ||  |_|  | _____| |
|___| |_||_______||_______|
```

# Table of Contents
1. [Commands](#commands)
2. [Programs](#programs)
9. [Terminology](#terminology)
10. [Takeaways](#takeaways)
11. [Imperative vs Declarative Deployments](#imperative-vs-declarative-deployments)
12. [YAML File Line by Line](#yaml-file-line-by-line)
13. [Object Types](#object-types)
14. [Network Services](#network-services)
15. [Docker Compose vs K8s](#docker-compose-vs-k8s)
16. [Pod Object vs Deployment](#pod-object-vs-deployment)
17. [PersistentVolumeClaim Access Modes](#persistentvolumeclaim-access-modes)
18. [Ingress Nginx](#ingress-nginx)
19. [Kubernetes Objects](#kubernetes-objects)
20. [Commands](#commands-1)
21. [NameSpaces](#namespaces)
22. [ConfigMap](#configmap)
23. [Helm (v2.0)](#helm-v20)
24. [Acknowledgment](#acknowledgment)
25. [Links](#links)

---

# Commands:

- restart statefulset --> `$ kubectl --kubeconfig ./kubeconfig rollout restart statefulset <shopping-stage-back-pgha1-mbrq>`
- change namespace --> `$ kubectl config set-context --current --namespace=my-namespace`

- TIP: `-c` flag —> address a running container in a pod

## Configs:

- `kubectl apply -f [config file name]` —> feed a config file to k8s. Needs to be written for each file. Create a deployment out of a config file
- `kubectl delete -f [config file name]` —> remove an object
- `kubectl set image [object type] / [object name] [container name] = [new image to use]` —> Imperative command to update image

## Print Status:

- `kubectl get pods` —> print out information about all of the running pods
- `kubectl get services` —> print out information about all of the running services
- `kubectl get deployments` —> list all the running deployments
- `kubectl get pv` —> list all the persistent volumes
- `kubectl get pvc` —> list all the persistent volume claims
- `kubectl get secrets` —> get all of secrets
- `kubectl get namespaces` —> get all namespaces inside of our cluster

## LOG:

- `kubectl logs [pod_name]` —> print out logs from the given pod
- `kubectl describe [object type] [object name / can be none to get all of objects]` —> print out details about a specific object
- `kubectl describe pod [pod_name]` —> print out some information about the running pod

## Deployment Commands:

- `kubectl delete deployment [depl_name]` —> delete a deployment
- `kubectl rollout restart deployment [depl_name]` —> for updating new built container
- `skaffold dev` —> start


## Minikube:

- `minikube ip` —> show IP address of node to access on local machine
- `kubectl exec -it [pod_name] [cmd].` —> execute the given command in a running pod
- `kubectl delete pod [pod_name]` —> deletes the given pod
- `kubectl create secret generic jwt-secret --from-literal=JWT_KEY=asdf` —> create a secret environment variable of `JWT_KEY=asdf`
- `kubectl get services -n <NAMESPACE>` —> get all services that are inside of a namespace
- `kubectl config view` —> show all things that are running, different contexts and namespaces
- `kubectl config use-context <namespace>` —> change context

---

## Programs:

- **minikube** (just for development, local only) —> use for managing the VM itself. Creates k8s node.
- **kubectl** —> use for managing containers in the node
- **ingress-nginx** —> [github.com/kubernetes/ingress-nginx](http://github.com/kubernetes/ingress-nginx) and not kubernetes-ingress by nginx [github.com/nginxc/kubernetes-ingress](http://github.com/nginxc/kubernetes-ingress)

---

## Terminology:

- **masters**: are machines (or vm’s) with a set of programs to manage nodes. A series of 4 programs that control the entire cluster’s deployment, mostly using `kube-apiserver`, which is monitoring the status of all nodes inside the cluster and making sure they’re doing the correct thing. It reads the config file and interprets it. We are communicating with the master for changes, not nodes. The master decides inside which node to run a certain container. To deploy something, we update the desired state of the master with a config file, and the master works constantly to meet your desired state.
- **nodes**: individual machines (or vm’s) that run containers. They are inside a cluster. There is a docker running in each node. Pods are inside nodes. We developers never communicate directly to nodes. It’s being done by the master.
- **PODS**: the smallest thing that can be deployed on k8s. Exist inside a node. Inside a pod, one or more containers exist. Containers inside a pod are closely put together and need each other to work correctly, e.g., postgres container + logger container + backup manager container inside a single pod. Each container inside a pod is defined in `spec: containers:` section.
- **Load Balancer Service**: Tells K8s to reach out to its provider and provision a load balancer. Gets traffic into a single pod.
- **Ingress or Ingress Controller**: A pod with a set of routing rules to distribute traffic to other services.
- **Persistent Volume Claim (PVC)**

---

## Takeaways:

- K8s don’t build our images. It gets them from somewhere else.
- Deployment is a type of controller. Also, ingress makes a controller for routing.

  * Usually inside spec add `imagePullPolicy: IfNotPresent`
  * `apk` —> Alpine images package manager

- K8s has a limit of 150000 Pods.

---

## Imperative vs Declarative Deployments:

K8s can do both.

- **Imperative**: Do exactly these steps to arrive at this container setup.
- **Declarative**: Our container setup should look like this, make it happen.

---

## YAML File Line by Line:

1. `apiVersion: v1` or `apps/v1`
   - Defines objects we can use.
2. `kind: Pod`
   - Specifies the purpose of this object.

### Examples of Object Types:

3. `metadata`
   - `name` —> name of pod. Mostly used for logging purposes.
   - `labels: component: web` [label selector system]

4. `spec: containers:` [an array. Could be multiple containers]
   - Each container inside a pod is defined here.
   - `name: client`
   - `image: apakhbari/multi-client`
   - `ports: containerPorts: 3000`

5. **Service**
   - `spec: type: NodePort`
   - `ports:` [an array. Could be multiple ports]
   - `port: 3050`
   - `targetPort: 3000`
   - `nodePort: 31515` —> random 30000 - 32767
   - `selector: component: web` [label selector system]

6. **Deployment**
   - `apiVersion: apps/v1`
   - `kind: Deployment`
   - `metadata:`
     - `name: client-deployment`
   - `spec:`
     - `replicas: 1`
     - `selector:` [used for assigning some label, for monitoring pods by deployment]
       - `matchLabels:`
         - `component: web`
     - `template:` [configs that are used for every single pod made by this deployment]
       - `metadata:`
         - `labels:`
           - `component: web`
       - `spec:`
         - `containers:`
           - `name: client`
           - `image: apakhbari/multi-client`
           - `ports:`
             - `containerPort: 3000`

7. **PersistentVolumeClaim**
   - `apiVersion: v1`
   - `kind: PersistentVolumeClaim`
   - `metadata:`
     - `name: database-persistent-volume-claim`
   - `spec:`
     - `accessMode:`
       - `- ReadWriteOnce`
     - `resources:`
       - `requests:`
         - `storage: 2Gi`
     - `[StorageClassName can be assigned too. We stick to default]`

---

## Object Types:

- **statefulset**
- **ReplicaController**
- **Pod**: one or more closely related containers
- **deployment**: maintains a set of identical pods, ensuring that they have the correct config and that the right number exists
- **Services**: sets up networking in a k8s cluster
- **volume**: it is pod-level. If the container deletes/crashes, it exists, but if the pod gets deleted, it deletes too.
- **persistent volume**
- **persistent volume claim**
- **secrets**: securely store a piece of information in the cluster, such as a db password.

  Defined in `spec: type:`

---

## Network Services

1. **Cluster IP**: Sets up an easy-to-remember URL to access a pod. Only exposes pods in the cluster (DEFAULT)
2. **Node Port**: Makes a pod accessible from outside the cluster. Usually only used for dev purposes, because of funky random nodePort.
3. **Load Balancer**: Legacy way to make a pod accessible from outside the cluster. Getting network traffic into a cluster. Only exposes one set of pods to the outside world.
4. **External Name**: Redirects an in-cluster request to a CAME URL...

   *... don't worry about this one...*
5. **Ingress**: Exposes a set of services to the outside world.

---

## Docker Compose vs K8s:

- **docker**: Each entry can optionally get docker-compose to build an image. 
- **k8s**: Expects all images to already be built.

- **docker**: Each entry represents a container we want to create. 
- **k8s**: One config file per object we want to create.

- **docker**: Each entry defines the networking requirements (ports). 
- **k8s**: We have to manually set up all networking.

---

## Pod Object vs Deployment:

- **pod**: Runs a single set of containers. 
- **deployment**: Runs a set of identical pods (one or more).
  
- **deployment**: Monitors the state of each pod, updating as necessary. It has a template; when a change happens, update or kill + restart pod to make changes.
  
- **pod**: Good for one-off dev purposes. 
- **deployment**: Good for dev.

- **pod**: Rarely used directly in production. 
- **deployment**: Good for production.

---

## PersistentVolumeClaim Access Modes:

- **ReadWriteOnce** —> Can be used by a single node
- **ReadOnlyMany** —> Multiple nodes can read from this
- **ReadWriteMany** —> Can be read and written to by many nodes

---

## Ingress Nginx:

In ingress-nginx, something that accepts incoming traffic and ingress controller are in one module.

There is also a default-backend pod created by ingress-nginx which has health check purposes. It ideally could be implemented inside an express server.

---

- **k8s supports two kinds of containers**
  - docker
  - rocketd

- **components**
  - **Master node**
    - **API server**: Gatekeeper receives calls, creates, deletes, or modifies components.
    - **kube controller**
      - replication controller
      - node controller
      - endpoint controller
      - service account controller
    - **scheduler**: Decides which pod deploys on which node.
    - **etcd**: All cluster data is stored here.

  - **worker node**
    - **kubelet**: Makes sure that pods are working fine in nodes. If things are not going well, it informs the kube controller and then the scheduler will start a new pod.
    - **kubeproxy**: Pods use this to communicate within the cluster.
    - **pod**: A scheduling unit.
    - **containers**

  - **It is possible to have two containers in a pod**, for example for log purposes. This happens with sidecar containers / init containers, which are the same.

- **Kubernetes objects**
  - Creating a `yml` file for k8s objects we want to create:
    - `apiVersion`: Version number of k8s API
    - `kind`: What kind of object we want to create
    - `metadata`: Data to help uniquely identify object
    - `spec`: Desired state for the object

- **Commands**
  - `$ kubectl scale rc (replication controller) nginx --replica=5` —> For scaling up/down
  - `kubectl edit rc (replication controller) nginx` —> Another way to scale up/down
  - **RabbitMQ** and **ElasticSearch** use StatefulSet instead of deployment.
  - **DaemonSet deployment** is for when fluentd is being deployed as a part of **EFK** (Elastic, Fluentd, Kibana).
  - In deployment, these deploying methods are available:
    - **ReCreate**: Delete old ones & create new ones.
    - **RollingUpdate**: Delete old one, create a new one, delete old one, create a new one, … (one at a time).
    - **Blue/Green**: Route traffic to new ones, then delete old ones.
    - **Canary**

  - `$ kubectl rollout status deployment nginx-deployment`
  - **ClusterIP** service is used for inside-cluster cases, and you can access them via their names.
  - **NodePort** service is used for external access. The range is 30000 to 32767, not used in production environments.
  - **LoadBalancer** service is the default when you want access from outside and are using the cloud. The downside is each service gets an IP, so it's expensive. LB is accessible by outside via its port.

- **NameSpaces**
  - **Default**: All namespaces that don’t belong to public/system.
  - **kube-public**: Publicly available/readable by all.
  - **kube-system**: Objects/resources created by k8s systems.

- **ConfigMap**: An API object used to store non-confidential data in key-value pairs.
- **helm (v2.0)**:
  - Has a client-side component called **helm** and a cluster-side component called **tiller**.
  - `$ helm create` —> Dir
  - `/charts`: Dependencies.
  - `chart.yaml`: Metadata of charts.
  - **templates**:
    - **deployment.yaml**:
    - **values.yaml**: Values of template and our project in general.

---

## Acknowledgment
### Contributors

APA 🖖🏻

---

## Links

---

## APA, Live long & prosper
```
  aaaaaaaaaaaaa  ppppp   ppppppppp     aaaaaaaaaaaaa
  a::::::::::::a p::::ppp:::::::::p    a::::::::::::a
  aaaaaaaaa:::::ap:::::::::::::::::p   aaaaaaaaa:::::a
           a::::app::::::ppppp::::::p           a::::a
    aaaaaaa:::::a p:::::p     p:::::p    aaaaaaa:::::a
  aa::::::::::::a p:::::p     p:::::p  aa::::::::::::a
 a::::aaaa::::::a p:::::p     p:::::p a::::aaaa::::::a
a::::a    a:::::a p:::::p    p::::::pa::::a    a:::::a
a::::a    a:::::a p:::::ppppp:::::::pa::::a    a:::::a
a:::::aaaa::::::a p::::::::::::::::p a:::::aaaa::::::a
 a::::::::::aa:::ap::::::::::::::pp   a::::::::::aa:::a
  aaaaaaaaaa  aaaap::::::pppppppp      aaaaaaaaaa  aaaa
                  p:::::p
                  p:::::p
                 p:::::::p
                 p:::::::p
                 p:::::::p
                 ppppppppp
```