# Kubernetes Course
```
 ___   _   _____   _______ 
|   | | | |  _  | |       |
|   |_| | | |_| | |  _____|
|      _||   _   || |_____ 
|     |_ |  | |  ||_____  |
|    _  ||  |_|  | _____| |
|___| |_||_______||_______|
```

# Table of contents
- [Architecture](#architecture)
- [Tips & Tricks](#tips--tricks)
- [Directories](#directories)
- [Ports](#ports)
- [Commands](#commands)
- [Resources](#resources)
- [Errors](Errors)
- [Concepts](#concepts)

- [Kubernetes Course](#kubernetes-course)
- [Advanced Kubernetes Course](#advanced-kubernetes-course)

## Architecture
### Master Node
- Kubelet
- Kube Proxy
- CRD
- Kube APIServer
- ETCD Cluster
- Kube Contreoller Manager
- Kube Scheduler

### Worker Node
- Kubelet
- Kube Proxy
- CRD

## Tips & Tricks
- It is possible to have a k8s cluster using linux services not containers, but it is very difficult & unconvenient.
- k8s policy for deprecating some feature is after 3 versions, for example if it has deprecated some thing in 1.19, it will stop working in 1.23
- Kubelet has purpose of managing RAM & CPU on node, when swap is enabled, it is not able to manage resources properly. Must turn it off in order to work properly
- runc is creating namespaces and Cgroups
- Kubeadm, Kubelet & kubectl are versioned together
- There is nothing as a pod. You can't see any procss mamed pod, but containers actually exesits
- If any problems hapened during creation of a pod, you can ` $ service kubelet restart`
- Mostly API-Server is aimed for attacks
- If we change any manifests in /etc/kubernetes/manifests/ then after editting, there is no need to restart anything. Changes are going to be made.
- Always have a backup from /etc/kubernetes/manifests/
- What is a ` /pause ` container that all of containers have it when you ` $ nerdctl -n k8s.io ps ` ? It is a sandbox container that executes before actual container is up. sandbox asks for IP for actual container network from kube-proxy
- In K8s restart policy is always
- For LoadBalancing Network Traffic, We use HAPRoxy + keepalived in Masters and Nginx reverse proxy in workers. On Workers you can also use terafic because it has a good UI
- You can't ping a k8s service. Because it is actually some forwarding firewall rules, unless you don't specify port number of service, There is nothing to actually see
- You can increase probability of packets sending to a specific node by changing its related IPTables rule

## Directories
### Kube Config
- ` $HOME/.kube `
- ` /etc/kubernetes/admin.conf `

### Drivers
- ` /opt/cni/bin ` --> Network Driver
#### Kubelet drivers
- ` /var/lib/kubelet/device-plugins/kubelet.sock ` --> Driver for containerd
- ` /var/lib/kubelet/plugins_registry/csi.tigera.io-reg.sock ` --> Setting IPs using Calico
- ` /var/lib/kubelet/plugins/csi.sock ` --> storage and PVs drivers

### Core components of k8s (Static Pod Path)
- Kubelet watch this path and make changes as soon as you make them in this directory
- ` /etc/kubernetes/manifests/etcd.yaml `
- ` /etc/kubernetes/manifests/kube-apiserver.yaml `
- ` /etc/kubernetes/manifests/kube-controller.yaml `
- ` /etc/kubernetes/manifests/kube-scheduler.yaml `

#### ETCD stores data
- ` /var/lib/etcd



## Ports
| **Port**          |     **Utility**     |
|:-----------------:|:-------------------:|
|   6443            |      API SERVER     |
|   2379            | API SERVER --> ETCD |
|   2380            |    ETCD <--> ETCD   |
|   2381            |   Monitoring ETCD   |
|   30000 - 32767   |   NodePort Range    |


#### Control plane
| **Protocol** | **Direction** | **Port Range** |       **Purpose**       |      **Used By**     |
|:------------:|:-------------:|:--------------:|:-----------------------:|:--------------------:|
|      TCP     |    Inbound    |      6443      |      K8s API Server     |          All         |
|      TCP     |    Inbound    |    2379-2380   |  ETCD server client API | kube-apiserver, etcd |
|      TCP     |    Inbound    |      10250     |       Kubelet API       |  self, Control Plane |
|      TCP     |    Inbound    |      10259     |      Kube-Scheduler     |         self         |
|      TCP     |    Inbound    |      10257     | Kube-Controller-Manager |         self         |

- 2379 --> is a port that API-SERVER commuicate with ETCD 
- 2380 --> is a port that ETCDs commuicate with ETCD

#### Worker node
| **Protocol** | **Direction** | **Port Range** |    **Purpose**    |     **Used By**     |
|:------------:|:-------------:|:--------------:|:-----------------:|:-------------------:|
|      TCP     |    Inbound    |      10250     |    Kubelet API    | self, Control Plane |
|      TCP     |    Inbound    |   30000-32767  | NodePort Services |         ALL         |


## Commands

### Information
- ` $ kubectl version `
- ` $ kubeadm version `
- ` $ kubectl cluster-info `

<br>

- ` $ kubectl describe pod nginx-pod `
- ` $ kubectl edit pod <pod_name> `
- ` $ kubectl get pod nginx-pod -o yaml > pod-nginx.yaml `

### Token
- To list token: ` $ kubeadm token list `
- To create and also print all of joining command: ` $ kubeadm token create --print-join-command --ttl 1h `

### Labels & Selectors
- ` $ kubectl label node worker2 kubernetes.io/role=worker-2-B ` --> defined Role, that's being shown in $ kubectl get nodes
- ` $ kubectl get node --show-labels `
- ` $ kubectl get pod --show-labels `
- ` $ kubectl get deployment --show-labels `
- ` $ kubectl get pod --selector app=nginx -o wide `


### Executing a command inside pod
- ` $ kubectl -n kube-system exec -it etcd-master1 -- sh ` --> connects to a pod to execute something
- ` $ nerdctl -n k8s.io exec -it a42ffs4y sh ` --> connects to a pod to execute something

### Deleting resources
- ` $ nerdcl -n k8s.io kill <container_name> `
- ` $ kubectl delete -f  "path/name.yaml" `
- ` $ kubectl delete pod  nginx-pod `

### Namespace
- ` $ kubectl create -f namespace-dev.yml `
- ` $ kubectl create namespace dev `
- ` $ kubectl config set-context kubernetes-admin@kubernetes --namespace=dev ` --> make dev namespace default namespace inside kube.config file


### Test & Debug
- ` $ kubectl run nginx-pod  --image nginx:1.21 `
- ` $ kubectl run debugger-pod  --image docker.arvancloud.ir/alpine --command -- sleep infinity `



### Service
- ` $ kubectl get endpoints nginx-svc ` 


## Components:
### Master Nodes
- manages k8s cluster

### Worker Nodes
- Applications are there

### ETCD Cluster
- It is for archiving everything. Key-value pair DB. Jason-based.
- ETCD is an open source distributed key-value store used to hold and manage thecritical information that distributed systems need to keep running.
- You can see its process: ` $ ps -aux | grep etcd `

### Kube Scheduler
- scheduled which workloads is going to be assigned to which worker
- Kube scheduler schedule based on:
1. Filter nodes: For example if it matches lable of node, It is going to be scheduled there. And if there is a taint on node, It is not going to be scheduled
2. Rank Nodes (based on resources)

### Kube Controller Manager
- Checks status of workers and workloads. In a 5 second interval check health of components.
-  Has so many Controllers. It is not a centralized contrller:
#### Node Controller
1. Watch status
2. Remediate Situation
3. Node Monitor Period = 5s
4. Node Monitor Grace Perido = 40s --> After this 40s, The node is going to have an unschedulable taint
5. POD Eviction Timeout = 5m --> Pods are going to other nodes, scheduler decides on how

#### Replication controller
- In times of Evicting node, Replication controller moves Pods that are buid using Replicaset or Deployment to nodes that are working 

#### PV-Binder Controller
#### Service-Account Controller
#### Stateful-Set Controller
#### ReplicaSet Controller
#### CronJob Controller
#### Job-Controller Controller
#### PV-Protection Controller
#### Deployment Controller
#### Namespace Controller
#### Endpoint Controller


### Kube APIServer
- A Manager which have to be informed for every interaction. Components do not talk to each other directly. The talk to API-Server and then API-Server communicate what have to be done. The only component that is connected to ETCD
- You can see its process: ` $ ps -aux | grep kube-api `


### Kubelet
- Exists on master node + worker node. Have so many responsibilities. Kubelet does status checks to API-Server. Master node Kubelet checks
- Does not recognize anything as a container. just Pod. Pod is just a concept that does not acyually exists.
- Its home directory is: ` /var/lib/kubelet `
- Works as a unit service, not a pod
- Has different responsibilities:
1. Register Node
2. Create PODs
3. Monitor Node & PODs

### CRD (Container Runtime Engine)
- A container controller

### Kube Proxy
- Exists on master node + worker node. Set Firewall Rules. For example for port forwarding
- Create IPTables Rules for network of K8S
- Services are transforming into IPtables firewall rules. Also take note that Services don't actually exists, They are logical constructs
- Every 5 seconds Check for service creations/changes

### Service
- has 2 main pros:
1. Load balancing (Round Robin by default)
2. connecting via name, not IP

### CoreDNS

## Errors
- CrashLoopBackoff: When container gets restarted so many times. So container creation has an error somewhere.
- ImagePullBackoff: Can't pull image

## Resources

### Namespace
- To create Namespace using yaml file:
```
apiVersion: v1
kind: Namespace
metadata:
  name: dev
```

#### Namespace Policy
- Request is when starting, limit is maximum amount of resource
```
apiVersion: v1
kind: ResourceQuota
metadata:
  name: dev-quota
  namespace: dev 
spec:
  hard: 
    pods: "10"
    count/deployments.apps: "2"
    requests.cpu: "100m"
    limits.cpu: "10"
    requests.memory: "100M"
    limits.memory: "10Gi"
```

<br>

- For connecting to a service outside of current namespace:
  - db-service.dev.svc.cluster-local
  - Service name . Namespace . Service . domain

#### Systematic Namespaces
##### default
- default namespace when you login to k8s using admin user

##### kube-node-lease

##### kube-public
- Whatever resource you put here, is accessible for all other namespaces

##### kube-system
- systemcatic resources for k8s
```
$ kubectl get pod -n kube-system
coredns (2 pods)
etcd
kube-apiserver
kube-controller
kube-Proxy
kube-scheduler
```

### Service
- Enable communication between various components within and outside
of the application
- Different Types of services:
1. NodePort
2. ClusterIP
3. LoadBalancer

#### NodePort Service
- Is a layer above ClusterIP, So you can use it for both external and inter-cluster connections
- Port Range: 30000 - 32767
- Service has an internal IP Address (From ClusterIP part of NodePort Serive) with an assigned desired internal Port.
- There are 3 different ports:
1. Target Port: Port of Pod that we want to map to
2. Port (From ClusterIP part of NodePort Serive): Assigned to Internal part of Service. Can be not unique across cluster, since there are lots of services that can be created and al of them are going to have different IPs, so they are having
3. NodePort: External Port that we connect to service using it

- Port Forwarding is happening using Kube-Proxy in IPTables level 
- Using Internal Serivce (From ClusterIP part of NodePort Serive), You can LoadBalance traffic to different Pods. LoadBalancing Algorithm is RoundRobin.
- thing is session is to sensitive to IP. So If you Change IP of clinet (Refresh page for example) There is this chance that You are going to be connected to a different pod. If You want this to not happen, You can ` SessionAffinity: Yes ` 

```
apiVersion: v1
kind: Service
metadata:
  name: nginx
  namespace: dev
spec:
  type: NodePort
  ports:
    - targetPort: 80
      port: 8080
      nodePort: 31457
  selector:
    app: nginx
```

- To Use SessionAffinity:
```
apiVersion: v1
kind: Service
metadata:
  name: myservice
spec:
  type: NodePort
  ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 80
  selector:
    app: myapp
  # The Following adds session affinity
  SessionAffinity: ClientIP
  SessionAffinityConfig:
    clientIP:
      timeoutSeconds: 600
```

#### ClusterIP Service
- Used for inter-cluster connections
- Is default form of service. If you Don't assign anything in spec/type, It is going to be


```
apiVersion: v1
kind: Service
metadata:
  name: backend
  namespace: dev
spec:
  type: ClusterIP
  ports:
    - targetPort: 80
      port: 80
  selector:
    type: back-end
```

#### LoadBalancer Service
- Mostly used in cloud environments.
- Is a layer above NodePort
- After you create a loadBalancer Service, You are going to have an External-IP (Public) So you can LoadBalance using domain to differnet services.
```
apiVersion: v1
kind: Service
metadata:
  name: nginx
  namespace: dev
spec:
  type: LoadBalancer
  ports:
    - targetPort: 80
      port: 8080
  selector:
    app: nginx
```


### POD
- There is nothing as a pod. You can't see any procss mamed pod, but containers actually exesits
- Kubelet actually does not understand container, you need some logical thing as pod
- You can not have same kind of containers on a pod, because there are network/namespace conflicts
- despite of how many containers/volumes a Pod have, it is going to be assigned 1 IP Address
- Differetn forms of creating pod:
1. manifests
2. Deployment
3. ReplicaSet
4. DaemonSet

```
apiVersion: v1
kind: Pod
metadata:
  name: pod-nginx
  namespace: dev
  labels:
    app: nginx
    type: frontend
spec:
  containers:
    - name: nginx-container
      image: nginx:1.20
      imagePullPolicy: Never
  restartPolicy: Never
```

### Replicaset
- is a layer above pod. managed by kube-controller
- In replicaset yaml file, first metadata is assigned to our replicaset, second metadata is assigned to our pods.
- You can't assign replicaset's pod's a name.
- When you use ` $ kubectl create -f relicaset.yml ` you cannot change number of replicas and then ` $ kubectl apply -f relicaset.yml ` You have to ` $ kubectl replace -f relicaset.yml `
- For changing number of relpicas:
```
$ kubectl replace -f relicaset.yml
$ kubectl scale --replicas=6 -f replicaset.yml
$ kubectl scale --replicas=6 replicaset myapp-nginx-replica
```

```
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-replicaset
  namespace: dev
  labels:
    app: nginx
    type: frontend
spec:
  replicas: 5
  selector:
    matchLabels:
        course: kubernetes
  template:
    metadata:
      labels:
        anisa: devops
        course: kubernetes
    spec:
      containers:
        - name: nginx-container
          image: docker.arvancloud.ir/nginx:1.21
```
- ` $ kubectl describe replicasetes.apps nginx-replicaset ` 




---

### Deployment
- Is a layer above Replicaset, So that it manages replicaset + pod
- Benefits:
  - Rolling Updates: In rolling updates (versions) it is useful because it has 0 downtime. It is maximum cahnges 25% of pods at a version update.
  - Rollback Changes: Rolling back is also really easy
  - Pause/Resume Changes: You can also pause deploying a version. and start it at a certain time, so everything is ready for resume changes
- When you create a deployment, your pod name looks like (Replicaset and pod name are going to have a random set of characters assigned to them): ` <Deployment name> - <Replicaset name> - <Pod name> `
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: dev
  labels:
    app: nginx-anisa
spec:   
  replicas: 6
  selector: 
    matchLabels:
      anisa: kubernetes
  template: 
    metadata:
      labels:
        anisa: kubernetes
    spec:
      containers:
        - name: nginx-container
          image: docker.arvancloud.ir/nginx:1.21  
          resources:
            requests:
              cpu: "10m"
              memory: "10M"
            limits:
              cpu: "2"
              memory: "512M" 
```

# Kubernetes Course
# Contents
- Install, Configure and validation
- Core Concept (Architecture, Pods, Deployments, etc)
- Scheduling
- Logging & Monitoring
- Application Lifecycle Management
- Cluster Maintenance
- Security
- Storage
- Networking

# Sessions
## Session 1 - Core Concepts & Architecture

- K8s is written in GO lang
- It is possible to have a k8s cluster using linux services not containers, but it is very difficult & unconvenient.
- k8s policy for deprecating some feature is after 3 versions, for example if it has deprecated some thing in 1.19, it will stop working in 1.23

### Components:
- Master Nodes: manages k8s cluster
- Worker Nodes: Applications are there
- ETCD Cluster: Is for archiving everything. Key-value pair DB. Jason-based
- Kube Scheduler: scheduled which workloads is going to be assigned to which worker
- Kube Contreoller Manager: Checks status of workers and workloads. Has so many Controllers. It is not a centralized contrller. In a 5 second interval check health of components
- Kube APIServer: A Manager which have to be informed for every interaction. Components do not talk to each other directly. The talk to API-Server and then API-Server communicate what have to be done. The only component that is connected to ETCD
- Kubelet: Exists on master node + worker node. Have so many responsibilities. Kubelet does status checks to API-Server. Master node Kubelet checks 
- CRD (Container Runtime Engine): A container controller
- Kube Proxy: Exists on master node + worker node. Set Firewall Rules. For example for port forwarding

### Architecture
#### Master Node
- Kubelet
- Kube Proxy
- CRD
- Kube APIServer
- ETCD Cluster
- Kube Contreoller Manager
- Kube Scheduler

#### Worker Node
- Kubelet
- Kube Proxy
- CRD

### Deploying an app procedure
- Setup a yaml file for my-app
- After applying, yaml file is being passed to API-Server. In this stage "Pod is Created" is being outputted, but it is not actually created yet.
- Then it is passed to ETCD then scheduler. 
- After Scheduler make checks, it passes it request to related kublet of a worker node.
- Kublet of worker node then commadns Containerd to create containers.
- After it starts to run, kubelet acknowledge API-Server
- API-Server tells ETCD that node is active and running
- Controller Manager checks all components during the process

### dockershim vs cri-containerd
- docker uses containerd for its lifecycle management (start, stop, ...)

- dockershim
```mermaid
  graph LR;
      A(kublet)<-- CRI -->B;
      B(dockershim)<-->C;
      C(docker)<-->D;
      D(containerd)-->F(container 1);
      D-->G(container 2);
      D-->H(container 3);
```
<span style="font-size: 2em;">&#x2B07;</span>
<span style="font-size: 2em;">&#x2B07;</span>
<span style="font-size: 2em;">&#x2B07;</span>


- cri-containerd developed as a driver between kubelet and containerd, so it improved performance of dockershim and docker
```mermaid
  graph LR;
      A(kublet)<-- CRI -->B;
      B(cri-containerd)<-->C;
      C(containerd)-->F(container 1);
      C-->G(container 2);
      C-->H(container 3);
```

- You usually don't need to interact with containers directly, but when need to troubleshoot them, instead of ` $ docker ` you have to use ` $ ctr ` for example:
```
$ ctr images pull doceker.io/library/redis:alpine
$ ctr run doceker.io/library/redis:alpine redis
```
- instead of ` $ ctr` use ` $ nerdctl ` It is exactly like ` $ docker `

### Initialize a k8s Cluster
1. Provision the VMs (Min of 1 Master, 1 Worker):
2. Select and Install CRE (Containerd or others) on all the nodes. Get containerd from github. Install runc
3. Install Kubeadm, kubectl & kubelet on all the nodes
4. Initialize the cluster (on the master node)
5. Apply a CNI (Calico or flannel) on cluster
6. Join worker nodes to the cluster

### Install & Configure K&s:
- A compatible Linux host (Debian or Red Hat)
- 2GB or more of RAM per machine (any less will leave little room for your
apps).
- 2 CPUs or more.
- Full network connectivity between all machines in the cluster (public or
private network is fine).
- Unique hostname, MAC address, and product_uuid for every node.
- Certain ports are open on your machines
- Swap disabled. You MUST disable swap in order for the kubelet to work
properly
```
$ free -m --> check how much swap is being used
$ swappoff -a --> temporarily turn swap off
$ nano /etc/fstab --> To permanently turn swap off
```
- Set Time Zone (Asia/Tehran) ` $ timedatectl set-timezone Asia/Tehran `
- static IP on each node
- Set Public DNS (shecan.ir, 403.online or Open-VPN for Iran)
- Join the Worker Nodes

### Ports & Protocols
#### Control plane
| **Protocol** | **Direction** | **Port Range** |       **Purpose**       |      **Used By**     |
|:------------:|:-------------:|:--------------:|:-----------------------:|:--------------------:|
|      TCP     |    Inbound    |      6443      |      K8s API Server     |          All         |
|      TCP     |    Inbound    |    2379-2380   |  ETCD server client API | kube-apiserver, etcd |
|      TCP     |    Inbound    |      10250     |       Kubelet API       |  self, Control Plane |
|      TCP     |    Inbound    |      10259     |      Kube-Scheduler     |         self         |
|      TCP     |    Inbound    |      10257     | Kube-Controller-Manager |         self         |

- 2379 --> is a port that API-SERVER commuicate with ETCD 
- 2380 --> is a port that ETCDs commuicate with ETCD

#### Worker node
| **Protocol** | **Direction** | **Port Range** |    **Purpose**    |     **Used By**     |
|:------------:|:-------------:|:--------------:|:-----------------:|:-------------------:|
|      TCP     |    Inbound    |      10250     |    Kubelet API    | self, Control Plane |
|      TCP     |    Inbound    |   30000-32767  | NodePort Services |         ALL         |

- runc is creating namespaces and Cgroups

## Session 2 - Initialize a k8s Cluster

- runc: is in docker, create and manages cgroups and namespaces in linux kernel

### Initialize a k8s Cluster
#### Contaienrd
- get containerd from [https://www.github.com/containerd/containerd/releases/download/v1.7.16/containerd-1.7.16.tar.gz](https://www.github.com/containerd/containerd/releases/download/v1.7.16/containerd-1.7.16.tar.gz)
- extract it to /usr/local/ ` $ tar Cxzvf /usr/local/ containerd-1.6.31-linux-amd64.tar.gz `
- Download containerd service ` $ wget https://raw.githubsercontent.com/containerd/containerd/main/containerd.service ` and then ` $ mv containerd.service /usr/lib/systemd/system ` then ` $ systemtl deamon-reload` and ` $ systemctl start containerd.service `

#### runc
- get runc from [https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64](https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64)
- ` $ install -m 755 runc.amd64 /usr/local/sbin/runc `

<br>

- ` $ mkdir /etc/containerd `
- ` containerd config default | tee /etc/containerd/config.toml ` --> created default config

#### CNI for containerd
- see project [https://github.com/containernetworking/plugins/](https://github.com/containernetworking/plugins/)
- get CNI plugin from [https://github.com/containernetworking/plugins/releases/download/v1.4.1/cni-plugins-linux-amd64-v1.4.1.tgz](https://github.com/containernetworking/plugins/releases/download/v1.4.1/cni-plugins-linux-amd64-v1.4.1.tgz)
- ` $ mkdir -p /opt/cni/bin ` and then ` $ tar Cxzv /opt/cni/bin/ ni-plugins-linux-amd64-v1.4.1.tgz `

<br>

- Now we have to introduce cgroup to containerd
```
$ vim /etc/containerd/config.toml
search for { plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc }
add this line to end of section: SystemdCgroup = true

go to next section: { plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options }
change: SystemdCgroup = false --> SystemdCgroup = true
```
- then ` $ systemctl restart containerd.service `

#### Enabling IPV4 packet forwarding
```
# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system
```
- Verify that net.ipv4.ip_forward is set to 1 with: ` $ sysctl net.ipv4.ip_forward `

#### Allow Bridge Network packets for IPTables Configuration
```
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system
```


#### Installing Kubeadm, Kubelet & kubectl
- [https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
- After adding related k8s version source to sources.list ` $ apt install kubelet=1.27.12-1.1 kubeadm=1.27.12-1.1 kubectl=1.27.12-1.1 -y `

#### Initializing k8s cluster on master nodes
- ` $ kubeadm init --pod-network-cidr=10.10.0.0/16 --apiserver-advertise-address=<IP of master node, On network Interface that we want> --kubernetes-version 1.27.12`


#### Copying Kube-config file
- Now you can use ` $ kubectl get node  --kubeconfig /etc/kubernetes/admin.conf `
- For convenience and not passing ` --kubeconfig /etc/kubernetes/admin.conf ` everytime, you can:
```
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):%(id -f) $HOME/.kube/config
```

#### Installing Calico
- When we initialize a cluster, etcd, kube-apiserver, kube-controller, kube-Proxy, kube-scheduler are going to be assigned IP Address of bridge (exact host IP), but coreDNS won't initialize untill we have a CNI. In this state, our node is not schedulable since It can't assign an IP address to created pods. So we need an overlay network.
- [https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart](https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart)

- ` $ kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/tigera-operator.yaml `

- IMPORTANT! DO NOT PROCEED LIKE DOCUMENT, INSTEAD:
```
$ wget https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/custom-resources.yaml
$ vim custom-resources.yaml
Change: cidr: 192.168.0.0/16 --> cidr: 10.10.0.0/16 

$ kubectl create -f custom-resources.yaml
```

- If in process of initialization have any problems, ` $ service kubelet restart `


#### Joining Workers
- To list token: ` $ kubeadm token list `
- To create and also print all of joining command: ` $ kubeadm token create --print-join-command --ttl 1h `

#### Auto completion bash for kubectl
```
$ source <(kubectl completion bash) --> kubectl auto complete
$ echo 'source <(kubectl completion bash)' >> ~/.bashrc
```


#### Installing Nerdctl
- for managing and Troubleshooting containers
- [https://github.com/containerd/nerdctl](https://github.com/containerd/nerdctl)
- Lots of Nerdctl commands are like docker. you can check differneces here: [https://github.com/containerd/nerdctl/blob/main/docs/command-reference.md](https://github.com/containerd/nerdctl/blob/main/docs/command-reference.md)
- Download full version of it. [https://github.com/containerd/nerdctl/releases/download/v1.7.6/nerdctl-full-1.7.6-linux-amd64.tar.gz](https://github.com/containerd/nerdctl/releases/download/v1.7.6/nerdctl-full-1.7.6-linux-amd64.tar.gz)

- You can see all k8s related containers ` $ nerdtctl -n k8s.io ps `

### E2E Test
- Full test has around 1000 checks – takes ages (12h)
- Conformance test has around 160 checks – enough to be certified (1.5h)
- Examples:
  - Networking should function for intra-pod communication
  - Services should serv basic endpoint form pods
  - DNS should provide DNS for services
  - Service endpoints latency should not be very high


## Session 3 - Components
- To get all keys of ETCD:
```
$ kubectl -n kube-system exec -it etcd-master1 -- etcdctl get / --cert="/etc/kubernetes/pki/etcd/server.crt" --cacert="/etc/kubernetes/pki/etcd/ca.crt" --key="/etc/kubernetes/pki/etcd/server.key" --prefix --keys-only
```

### Kube API Server
- steps after execution of a simple get command using kubectl is passed to kube API Server, for example $ kubectl get nodes :
1. authenticate User
2. Validate request (authorization)
3. Retrieve data from ETCD

- steps after execution of a simple post command using kubectl is passed to kube API Server, for example $ kubectl create node :
1. authenticate User
2. Validate request (authorization)
3. Retrieve data from ETCD
4. Update ETCD
5. Scheduler
6. Kubelet


## Session 4 - Pod, Replicaset, Deployment
- In YAML File, first values are named top level.
- In Yaml file, we write in camel case style

### necessary top levels for pod in a manifest:
```
apiVersion:
kind:
metadata:

spec:
```

#### apiVersion
- For apiVersion reference:
  - [https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/)
  - [https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/) 
- If our resource was part of core group, you don't need to write: core/v1 , You just write: v1
  nerdcl -n k8s.io kill <container_name>
 
#### Kind
- in kind top level, first word is Always capital

#### Metadata 

#### spec

- A container name consists of: [Namespace]/[Pod Name]/[Container Name]


## Session 5 - Namespace, NamespacePolicy, ClusterIP Service, NodePort Service


## Session 6 (7 on classes) - LoadBalance Service, Manual Scheduling, Lables & Selectors, Annotations, Taint & Tolerations
### Scheduling
#### Scheduling Using NodeName
- For manual scheduling using NodeName, add ` nodeName ` to your yaml file:
```
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
  nodeName: worker2
```
- Using NodeName you override all taints, so you can deploy directly on master nodes

#### Scheduling in No Scheduler
- In this setting, since you don't have automatic scheduling, you need to define a binding resource, then using curl pass it to API-Server
```
pod-definition.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
      - containerPort: 8000


pod-bind-definition.yaml
apiVersion: v1
kind: Binding
metadata:
  name: nginx
target:
  apiversion: v1
  kind: Node
  name: node02
```
```
$ curl --header "Content-Type:application/jason" --request POST '{"apiVersion":"v1", "kind":"Binding" ... }' http://$SERVER/api/v1/namespace/default/pods/$PODNAME/binding/
```

### Annotations
- You can add some notes to your yaml file in order to keep things in mind. This functionality is not being used often.
- Mostly it is being used for config saving. For example in this annotation ` cache: True ` then read this value and set caching of app to true
- put values in " "
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: dev
  labels:
    app: nginx-anisa
  annotation:
    buildVersion: "1.34"
spec:   
  replicas: 8
  selector: 
    matchLabels:
      anisa: kubernetes
  template: 
    metadata:
      labels:
        anisa: kubernetes
    spec:
      containers:
        - name: nginx-container
          image: docker.arvancloud.ir/nginx:1.21 
```

### Taint & Tolerations

slide 5
6 --> 2:55
Add contets to k8s_course



```
Label and selector:
========
kubectl create deployment web-server --image docker.arvancloud.ir/nginx:1.21 --replicas 5
====
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: dev
  labels:
    app: nginx-anisa
spec:   
  replicas: 8
  selector: 
    matchLabels:
      anisa: kubernetes
  template: 
    metadata:
      labels:
        anisa: kubernetes
    spec:
      containers:
        - name: nginx-container
          image: docker.arvancloud.ir/nginx:1.21 
      tolerations:
        - key: "anisa"
          operator: "Equal"
          value: "kubernetes"
          effect: "NoSchedule"
    =====
    kubectl taint node worker1 anisa-
========
kubectl taint node worker1 anisa=kubernetes:NoSchedule-
=======
kubectl taint node worker1 anisa=kubernetes:NoSchedule
====
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: dev
  labels:
    app: nginx-anisa
spec:   
  replicas: 8
  selector: 
    matchLabels:
      anisa: kubernetes
  template: 
    metadata:
      labels:
        anisa: kubernetes
    spec:
      containers:
        - name: nginx-container
          image: docker.arvancloud.ir/nginx:1.21 
      tolerations:
        - key: "node-role.kubernetes.io/control-plane"
          operator: "Exists"
====
kubectl taint node worker2 app=nginx:PreferNoSchedule
=======
kubectl taint node worker1 app=nginx:NoExecute
=====
```

## Session 7 (8 on classes)
```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: nginx
  namespace: dev
spec:
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx
==========
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  namespace: dev
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.21
      nodeSelector:
        size: small
========
kubectl label node kubeworker-2 size=small
=====
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  namespace: dev
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.18
      affinity:
        nodeAffinity:
                  requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
              - matchExpressions:
                 - key: "size"
                   operator: "In"
                   values:
                     - "large"
                     - "small"
============
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: dev
  labels:
    app: nginx
spec:
  replicas: 10
  selector:
    matchLabels:
      type: frontend
  template:
    metadata:
      labels:
        type: frontend
    spec:
      containers:
        - name: nginx-container
          image: nginx:1.20
      affinity:
        nodeAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
            - weight: 1
              preference:
                matchExpressions:
                  - key: color
                    operator: In
                    values:
                      - blue
==========
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-red
  namespace: dev
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
              - matchExpressions:
                - key: "color"
                  operator: "In"
                  values:
                    - red
      tolerations:
        - key: "color"
          operator: "Equal"
          value: "red"
          effect: "NoSchedule"
      containers:
        - name: nginx
          image: nginx
========       

```


## Session 8 (9 on classes)

## Session 9 (11 on classes)
```
apiVersion: v1
kind: Pod
metadata:
  name: alpine-pod
  namespace: default
spec:
  containers:
    - name: alpine-container
      image: registry.docker.ir/alpine
      command:
        - sleep
        - infinity
      env:
        - name: WORDPRESS_DB_NAME
          value: "anisa"
        - name: WORDPRESS_DB_USER
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: DB_USER
=====
kubectl create configmap config --from-env-file=.env
======
kubectl -n dev create secret docker-registry ckatestaccount --docker-username=burux --docker-password=@nis@12345678 --dry-run=client -o yaml > docker-registry-secret.yaml
======
apiVersion: v1
kind: Pod
metadata:
  name: pod-multi
  namespace: default
  labels:
    app: nginx
spec:
  volumes:
    - name: myvol
      emptyDir:
        sizeLimit: 10Mi
  initContainers:
    - name: config-creator
      image: registry.docker.ir/alpine
      volumeMounts:
        - name: myvol
          mountPath: /mnt/vol
      command:
        - /bin/sh
        - -c
        - |
          echo "$(date) here is your Config" > /mnt/vol/init1.txt
          sleep 5
    - name: git-cloner
      image: registry.docker.ir/alpine
      volumeMounts:
        - name: myvol
          mountPath: /mnt/vol
      command:
        - /bin/sh
        - -c
        - |
          echo "$(date) here is your git repository" > /mnt/vol/init2.txt
  containers:
    - name: nginx-container
      image: registry.docker.ir/nginx:1.21
      volumeMounts:
        - name: myvol
          mountPath: /mnt/vol
======

```

## Session 10 (12 on classes)
```

```

## Session 11 (13 on classes)
```

etcdctl snapshot save snapshot20240718.db --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key --cacert=/etc/kubernetes/pki/etcd/ca.crt
=====
etcdctl snapshot status snapshot20240718.db --write-out=table
=====


```

## Session 12 (14 on classes)
```

 kubectl --kubeconfig /root/.kube/config config use-context anisa@kubernetes
 =====
 apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: webserver
  namespace: dev
spec:
  podSelector:
    matchLabels:
      app: webserver
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: green
      ports:
        - port: 80
          protocol: TCP
=====
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: anisa-developer
  namespace: dev
roleRef:
  apiGroup: "rbac.authorization.k8s.io"
  kind: "Role"
  name: "developer"
subjects:
  - apiGroup: "rbac.authorization.k8s.io"
    kind: "User"
    name: "anisa"
    ====
    apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: developer
rules:
  - apiGroups:
      - ""
      - "apps"
    resources:
      - "pods"
      - "deployments"
      - "nodes"
    verbs:
      - "list"    
      - "get"
      ======
      apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: developer
  namespace: dev
rules:
  - apiGroups:
      - ""
    resources:
      - "pods"
    verbs:
      - "list"
      - "get"
    resourceNames:
      - nginx-pod
  - apiGroups:
      - "apps"
    resources:
      - "deployments"
    verbs:
      - "list"
      - "get"
      - "watch"
      ======
      apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: anisa-developer
roleRef:
  apiGroup: "rbac.authorization.k8s.io"
  kind: "ClusterRole"
  name: "developer"
subjects:
  - apiGroup: "rbac.authorization.k8s.io"
    kind: "User"
    name: "anisa"
    ======
```


# Advanced Kubernetes Course
# Sessions
## Session 1

## Session 2 (3 on classes)
```
frontend kubernetes-frontend
  bind *:6443
  mode tcp
  option tcplog
  default_backend kubernetes-backend

backend kubernetes-backend
  option httpchk GET /healthz
  http-check expect status 200
  mode tcp
  option ssl-hello-chk
  balance roundrobin
    server kmaster1 192.168.1.5:6443 check fall 3 rise 2
    server kmaster2 192.168.1.6:6443 check fall 3 rise 2
    server kmaster3 192.168.1.7:6443 check fall 3 rise 2
======
apt install haproxy keepalived -y
=====
#!/bin/sh

errorExit() {
  echo "*** $@" 1>&2
  exit 1
}

curl --silent --max-time 2 --insecure https://localhost:6443/ -o /dev/null || errorExit "Error GET https://localhost:6443/"
if ip addr | grep -q 192.168.1.20; then
  curl --silent --max-time 2 --insecure https://192.168.1.20:6443/ -o /dev/null || errorExit "Error GET https://192.168.1.20:6443/"
fi
====
vrrp_script check_apiserver {
  script "/etc/keepalived/check_apiserver.sh"
  interval 3
  timeout 10
  fall 5
  rise 2
  weight 2
}

vrrp_instance VI_1 {
    state MASTER
    interface enp0s3
    virtual_router_id 1
    priority 100
    advert_int 5
    authentication {
        auth_type PASS
        auth_pass mysecret
    }
    virtual_ipaddress {
        192.168.1.20
    }
    track_script {
        check_apiserver
    }
}
====
etcdctl version
===
[Unit]
Description=etcd

[Service]
Type=exec
ExecStart=/usr/local/bin/etcd \
  --name etcd1 \
  --initial-advertise-peer-urls http://192.168.1.10:2380 \
  --listen-peer-urls http://192.168.1.10:2380 \
  --advertise-client-urls http://192.168.1.10:2379 \
  --listen-client-urls http://192.168.1.10:2379,http://127.0.0.1:2379 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster etcd1=http://192.168.1.10:2380,etcd2=http://192.168.1.11:2380,etcd3=http://192.168.1.12:2380 \
  --initial-cluster-state new
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
====
```

- Master node resources:

  - Minimum: 8 GB Ram + 4 core CPU
  - on average: 16 GB Ram + 12 core CPU

- Worker node resources:
  - Minimum: 16 GB Ram + 16 core CPU

## Session 3 (4 on classes)
```

https://github.com/cloudflare/cfssl/
===
ca-config.json:

{
    "signing": {
        "default": {
            "expiry": "87600h"
        },
        "profiles": {
            "etcd": {
                "expiry": "8760h",
                "usages": ["signing","key encipherment","server auth","client auth"]
            }
        }
    }
}
====
ca-csr.json :
 
{
  "CN": "etcd cluster",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "GB",
      "L": "England",
      "O": "Kubernetes",
      "OU": "ETCD-CA",
      "ST": "Cambridge"
    }
  ]
}

cfssl gencert -initca ca-csr.json | cfssljson -bare ca
====
etcd-csr.json :

{
  "CN": "etcd",
  "hosts": [
    "localhost",
    "127.0.0.1",
    "192.168.1.10",
    "192.168.1.11",
    "192.168.1.12"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "GB",
      "L": "England",
      "O": "Kubernetes",
      "OU": "etcd",
      "ST": "Cambridge"
    }
  ]
}

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=etcd etcd-csr.json | cfssljson -bare etcd
=====
/etc/systemd/system/etcd.service:

[Unit]
Description=etcd

[Service]
Type=notify
ExecStart=/usr/local/bin/etcd \
  --name etcd1 \
  --cert-file=/etc/etcd/pki/etcd.pem \
  --key-file=/etc/etcd/pki/etcd-key.pem \
  --peer-cert-file=/etc/etcd/pki/etcd.pem \
  --peer-key-file=/etc/etcd/pki/etcd-key.pem \
  --trusted-ca-file=/etc/etcd/pki/ca.pem \
  --peer-trusted-ca-file=/etc/etcd/pki/ca.pem \
  --peer-client-cert-auth \
  --client-cert-auth \
  --initial-advertise-peer-urls https://192.168.1.10:2380 \
  --listen-peer-urls https://192.168.1.10:2380 \
  --advertise-client-urls https://192.168.1.10:2379 \
  --listen-client-urls https://192.168.1.10:2379,https://127.0.0.1:2379 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-cluster etcd1=https://192.168.1.10:2380,etcd2=https://192.168.1.11:2380,etcd3=https://192.168.1.12:2380 \
  --initial-cluster-state new \
  --data-dir=/etc/etcd/pki
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target

systemctl daemon-reload
systemctl start etcd

etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/etcd/pki/ca.pem --cert=/etc/etcd/pki/etcd.pem --key=/etc/etcd/pki/etcd-key.pem member list
======
kubeadm-config.yaml:

apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
kubernetesVersion: v1.28.9
controlPlaneEndpoint: 192.168.1.50:6443
networking:
  podSubnet: "10.10.0.0/16"
etcd:
    external:
        endpoints:
        - https://192.168.1.10:2379
        - https://192.168.1.11:2379
        - https://192.168.1.12:2379
        caFile: /etc/kubernetes/pki/etcd/ca.pem
        certFile: /etc/kubernetes/pki/etcd/etcd.pem
        keyFile: /etc/kubernetes/pki/etcd/etcd-key.pem

---
apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: "192.168.1.5"
======
etcdctl get / --endpoints=https://192.168.1.10:2379 --cacert=/etc/etcd/pki/ca.pem --cert=/etc/etcd/pki/etcd.pem --key=/etc/etcd/pki/etcd-key.pem --prefix --keys-only
====
etcdctl snapshot restore snapshot20240605.db --data-dir /var/lib/etcd/ --initial-cluster etcd1=https://192.168.1.10:2380 --initial-advertise-peer-urls https://192.168.1.10:2380 --name etcd1
====
etcdctl snapshot save snapshot20240605.db --cert=/etc/kubernetes/pki/etcd/server.crt --cacert=/etc/kubernetes/pki/etcd/ca.crt --key=/etc/kubernetes/pki/etcd/server.key
====
```

## Session 4 (5 on classes)

## Session 5 (6 on classes)

## Session 6 (7 on classes)

## Session 7 (8 on classes)

## Session 8 (9 on classes)

## Session 9 (10 on classes)

## Session 10 (12 on classes)

## Session 11 (13 on classes)
```

tar Cxzvvf /usr/local nerdctl-full-1.7.6-linux-amd64.tar.gz
====
/etc/gitlab-runner/config.toml
====
kubectl create secret docker-registry anisa-registry --docker-username=burux --docker-password=@nis@12345678
====
image: docker:latestservices:  - docker:dindstages:  - build  - deployvariables:  COMMIT: $CI_COMMIT_SHORT_SHA  IMAGE_TAG1: burux/nginx:$COMMITBUILD:  stage: build  only:    - main    script:    - docker build -t $IMAGE_TAG1 .    - docker push $IMAGE_TAG1    - echo "push on docker hub"DEPLOY:  stage: deploy  only:    - main      script:    - kubectl set image deployment/anisa-web nginx-container=$IMAGE_TAG1    - echo "deploy done"


```

## Session 12 (14 on classes)

## Session 13 (15 on classes)

## Session 14 (16 on classes)
```
apiVersion: batch/v1
kind: Job
metadata:
  name: helloworld
spec:
  template:
    spec:
      containers:
      - name: busybox
        image: busybox
        command: ["echo", "Hello Kubernetes!!!"]
      restartPolicy: Never
=====
apiVersion: batch/v1
kind: Job
metadata:
  name: helloworld
spec:
  ttlSecondsAfterFinished: 20
  template:
    spec:
      containers:
        - name: busybox
          image: busybox
          command: ["echo", "hello Kubernetes!!!"]
      restartPolicy: Never
====
apiVersion: batch/v1
kind: Job
metadata:
  name: helloworld
spec:
  template:
    spec:
      containers:
      - name: busybox
        image: busybox
        command: ["sleep", "60"]
      restartPolicy: Never
      ===
      apiVersion: batch/v1
kind: Job
metadata:
  name: helloworld
spec:
  completions: 2
  template:
    spec:
      containers:
      - name: busybox
        image: busybox
        command: ["echo", "Hello Kubernetes!!!"]
      restartPolicy: Never
      ====
      apiVersion: batch/v1
kind: Job
metadata:
  name: helloworld
spec:
  completions: 2
  parallelism: 2
  template:
    spec:
      containers:
      - name: busybox
        image: busybox
        command: ["echo", "Hello Kubernetes!!!"]
      restartPolicy: Never
===
apiVersion: batch/v1
kind: Job
metadata:
  name: helloworld
spec:
  template:
    spec:
      containers:
      - name: busybox
        image: busybox
        command: ["ls", "/anisa"]
      restartPolicy: Never
===
apiVersion: batch/v1
kind: Job
metadata:
  name: helloworld
spec:
  backoffLimit: 2
  template:
    spec:
      containers:
      - name: busybox
        image: busybox
        command: ["ls", "/anisa"]
      restartPolicy: Never
    ====
    kubectl apply -f jobs.yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: helloworld-cron
spec:
  schedule: "* * * * *"
  suspend: true
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: busybox
            image: busybox
            command: ["echo", "Hello Kubernetes!!!"]
          restartPolicy: Never
   
   ======
   apiVersion: batch/v1
kind: CronJob
metadata:
  name: helloworld-cron
spec:
  schedule: "* * * * *"
  successfulJobsHistoryLimit: 0
  failedJobsHistoryLimit: 0 
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: busybox
            image: busybox
            command: ["echo", "Hello Kubernetes!!!"]
          restartPolicy: Never 
          =====
          apiVersion: batch/v1
kind: CronJob
metadata:
  name: helloworld-cron
spec:
  schedule: "* * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: busybox
            image: busybox
            command: ["echo", "Hello Kubernetes!!!"]
          restartPolicy: Never
          ====
          apiVersion: batch/v1
kind: Job
metadata:
  name: helloworld
spec:
  activeDeadlineSeconds: 10
  template:
    spec:
      containers:
      - name: busybox
        image: busybox
        command: ["sleep", "60"]
      restartPolicy: Never 
```

## Session 15 (17 on classes)
```

apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: web-server-hpa
  namespace: dev
spec:
  scaleTargetRef:
    kind: Deployment
    name: php-apache
    apiVersion: apps/v1
  minReplicas: 1
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 80
    - type: Resource
      resource:
        name: memory
        target:
          type: AverageValue
          averageValue: 200Mi
====
apiVersion: apps/v1
kind: Deployment
metadata:
  name: php-apache
  namespace: dev
spec: 
  selector: 
    matchLabels:
      run: apache
  replicas: 1
  template:
    metadata:
      labels:
        run: apache
    spec:
      containers:
        - name: php-apache-container
          image: registry.k8s.io/hpa-example
          resources:
            limits:
              cpu: 500m
            requests:
              cpu: 100m
====
```

## Session 16 (18 on classes)

## Session 17 (19 on classes)
```

echo "Password: $(kubectl -n argocd get secret argocd-secret -o jsonpath="{.data.clearPassword}" | base64 -d)"
====
$(Build.Repository.Name):$(Build.BuildId)
Copy Files to: $(Build.ArtifactStagingDirectory)


```

# acknowledgment
## Contributors

APA 🖖🏻

## Links
### Initializing a k8s cluster
- [https://https://kubernetes.io/releases/](https://https://kubernetes.io/releases/)
- [https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
- calico: [https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart](https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart)

### Proxy
- [https://github.com/myxuchangbin/dnsmasq_sniproxy_install](https://github.com/myxuchangbin/dnsmasq_sniproxy_install)


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