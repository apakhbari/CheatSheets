# CKA (Certified Kubernetes Administrator) - 3rd Edition

---

## Table of Contents

- Introduction
- Module 1: Building a Kubernetes Cluster
    - Lesson 1: Understanding Kubernetes Architecture
    - Lesson 2: Creating a Kubernetes Cluster with kubeadm
- Module 2: Running Applications
    - Lesson 3: Deploying Kubernetes Applications
    - Lesson 4: Managing Storage
    - Lesson 5: Managing Application Access
- Module 3: Managing Kubernetes Clusters
    - Lesson 6: Managing Clusters
    - Lesson 7: Performing Node Maintenance Tasks
    - Lesson 8: Managing Scheduling
    - Lesson 9: Networking
    - Lesson 10: Managing Security Settings
    - Lesson 11: Logging, Monitoring, and Troubleshooting
- Module 4: Practice Exams
    - Lesson 12: Practice CKA Exam 1
    - Lesson 13: Practice CKA Exam 2
- Summary

---

——————————————————

**Introduction**

——————————————————

**Certified Kubernetes Administrator (CKA): Introduction**

- CNCF (Cloud Native COmputong Foundation) : Is part of linux foundation, offers 4 certificates

- KCNA (Kubernetes and Cloud Native Associate)
- CKAD (Certified Kubernetes Application Developer)
- CKA (Certified Kubernetes Administrator)
- CKS (Certified Kubernetes Security Specialist)

——————————————————

**Module 1: Building a Kubernetes Cluster**

——————————————————

**Lesson 1: Understanding Kubernetes Architecture**

1.1 Vanilla Kubernetes and the Ecosystem

- Vanilla K8s is open-source k8s, installed with kubeadm directly from the kubernetes project Git repository
- A new release of Vanilla k8s is published every 4 months
- It provides core functionality, but does not contain some essential components

- Networking
- Support
- Graphical Dashboard

- To make a completely working environment, additional solutions from the k8s ecosystem are added

- Have a look at [cncf.io](http://cncf.io) > Projects Tab > Graduated —> there are projects that are approved for using in k8s environment

- CNCF (Cloud Native Computing Foundation) hosts many projects related to cloud native computing
- Kubernetes is among the most important projects, but many other projects are offered as well, implementing a wide range of functionality

- Networking
- Dashboard
- Storage
- Observability
- Ingress

- To get a completely working Kubernetes solution, products from the ecosystem need to be installed also
- This can be done manually, or by using a distribution

1.2 Running Kubernetes in Cloud or on Premise

- K8s is a platform for cloud native computing, and as such is commonly used in cloud
- All major cloud providers have their own integrated k8s distribution
- K8s can also be installed on premise, within the secure boundaries of your own datacenter
- And also, there are all-in-one solutions which are perfect for learning kubernetes, like minikube

1.3 Kubernetes Distributions

- K8s distributions add products from the ecosystem to vanilla k8s and provide support
- Normally, distributions run one or two k8s versions behind
- Some distributions are opinionated and integrate multiple products to offer specific solutions
- Other distributions are less opinionated and integrate multiple products to offer specific solutions

Common K8s distributions

- in Cloud

- Amazon Elastic Kubernetes Services (EKS)
- Azure Kubernetes Services (AKS)
- Google Kubernetes Engine (GKE)

- On Premise

- OpenShift
- Google Antos
- Rancher
- Canonical Charmed Kubernetes

- Minimal (learning) Solutions

- Minikube
- K3s

1.4 Kubernetes Node Roles

- The Control plane runs Kubernetes core services, Kubernetes agents, and no user workloads
- The worker plane runs user workloads and Kubernetes agents
- All nodes are configured with a container runtime, which is required for running containerized workloads
- The kubelet systemd service is responsible for running orchestrated containers as Pods on any node

- CRI (Container Runtime Interface) + kubelet: are systemd managed, they start when OS boots
- Scheduler: distributing workloads
- etcd: Heart of k8s cluster which stores all your resources
- Calico: network plugin, runs on control node, scheduler makes sure it's also running on worker node
- What happens when you start my-app using kubectl? It is going to be on control node, it is going to address it to API server, then API server is going to store it on etcd, etcd will bring it to scheduler, and scheduler gets in touch with kubelet of worker nodes, so my-app is now being started
- Control Node is a protected node, user apps are not running there

——————————————————

**Lesson 2: Creating a Kubernetes Cluster with kubeadm**

2.1 Understanding Cluster Node Requirements

- To install Kubernetes cluster using kubeadm, you’ll need at least two nodes that meet the following requirements:

- Running a recent version of Ubuntu or CentOS
- 2GiB RAM or more
- @ CPUs or more on the control-plane nodes

- Before setting up the cluster with kubeadm, install the following:

- A container runtime
- The kubernetes tools

**Container runtime Interface**

- The container runtime is the component that allows you to run containers
- Kubernetes supports different container runtimes

- containerd
- CRI-O
- Docker Engine
- Mirantis Container Runtime

- Installing a container runtime is not a CKA exam requirement
- In the course git repository at [https://github.com/sandervanvugt/cka](https://github.com/sandervanvugt/cka) the setup-container.sh script is provided to set up a container runtime
- Differetn forms

- Stand-alone

- Docker
- Podman

- Cloud

- Kubernetes

- Note that k8s does no longer need docker for running containers, it need light weight CRI in order to run containers and k8s takes care of the rest

**Installing k8s tools**

- Before starting the installation, you’ll have to install the Kubernetes tools

- kubeadm: used to install and manage a kubernetes cluster
- kubelet: the core Kubernetes service that starts all Pods
- kubectl: the interface that allows you to run and manage applications in kubernetes

- Installing the kubernetes tools is not a CKA requirement
- In the course git repository at [https://github.com/sandervanvugt/cka](https://github.com/sandervanvugt/cka) the setup-kubetools.sh script is provided to set up k8s tools

2.2 Understanding Node Networking Requirements

- Different types of network communication are used in k8s:

- Node Communication: handled by the physical network
- External-to-service communication: handled by kubernetes Service resources
- Pod-to-Service Communication: handled by Kubernetes Services
- Pod-to-Pod Communication: handled by the network plugin
- Container-to-container communication: handled within the Pod

- To create the software defined Pod network, a network add-on is needed
- Different network add-ons are provided by the Kubernetes ecosystem
- Vanilla Kubernetes doesn’t come with a default add-on, as it doesn’t want to favor a specific solution
- Kubernetes provides the Container Network Interface (CNI) , a generic interface that allows different plugins to be used
- Availability of specific features depends on the network plugins that are used

- Networkpolicy
- IPv6
- Role Base Access Control (RBAC)

**Common network Add-ons**

- Calico: probably the most common network plugin with support for all relevant features
- Flannel: a generic network add-on that was used a lot in the past, but doesn’t support NetworkPolicy
- Multus: a plugin that can work with multiple network plugins. Current default in OpenShift.
- Weave: a common network add-on that does support common features

2.3 Understanding Cluster Initialization

- While running `$ kubeadm init`, different phases are executed

- preflight: ensures all conditions are met and core container images are downloaded
- certs: a self-signed Kubernetes CA is generated, and related certificates are created for apiserver, etc, and proxy
- Kubeconfig: configuration files are generated for core Kubernets services
- kubelet-start: the kubelet is started
- control-plane: static Pod manifests are created and started for apiserver, controller manager, and scheduler
- etcd: static Pod manifests are created and started for etcd
- upload-config: ConfigMaps are created for ClusterConfiguration and kubelet component config
- upload-certs: uploads all certificates to /etc/kubernetes/pki
- mark-control-plane: marks the node as control plane
- bootstrap-token: generates the token that can be used to join other nodes
- kubelet-finalize: finalizes kubelet settings
- add-on: installs coredns and kube-proxy add-ons

2.4 Installing the Cluster

- Install CRI
- Install kubetools
- Install the cluster: `$ sudo kubeadm init`
- set up the client:

  - mkdir ~/.kube
  - sudo cp -i /etc/kubernetes/admin.conf ~/.kube/config
  - sudo chown $(id -u):$(id -g) .kube/config

- Install network add-on: `kubectl apply -f [https://docs.projectcalico.org/manifests/calico.yaml](https://docs.projectcalico.org/manifests/calico.yaml)`
- Join other nodes: (on other nodes) `sudo kubeadm join <join-token>`

2.5 Using kubeadm init

- While using `$ kubeadm init`, different arguments can be used to further define the cluster

- `--apiserver-advertise-address`: the IP address on which the API server is listening
- `--config`: the name of a configuration file used for additional configuration
- `--dry-run`: performs a dry-run before actually installing for real
- `--pod-network-cidr`: sets the service CIDR to something other than 10.96.0.0/12

- In most cases, just using `$ kubeadm init` will be enough

2.6 Adding Nodes to the Kubernetes Cluster

- When Kubernetes cluster is initialized, a join token is generated
- Use this join token to join to other hosts, using `$ sudo kubeadm join` from the hosts you want to join
- In case the join token is lost or expired, use `$ sudo kubeadm token create —print-join-command`

2.7 Configuring the Kubernetes Client

- After cluster initialization, the `/etc/kubernetes/admin.conf` file is copied to `~/.kube/config` to provide admin access to the Kubernetes cluster
- Alternatively, as Linux root user, use `$ export KUBECONFIG=/etc/kubernetes/admmin.conf` to get admin access
- For more advanced user configuration, users must be created and provided with authorizations using Role Based Access Control (RBAC)

**Client Configuration**

- The context groups client access parameters using a convenient name
- By selecting a context, a specific group of parameters can be accessed
- Each context has three parameters

- Cluster: the cluster you want to connect to
- Namespace: the default Namespace
- User: the user account used (lesson 10)

- use `$ kubectl cofig view`, to view the context
- use `$ kubectl set-context`, to set a different context (lesson 10)

**Understanding Connectivity Parameters**

- The cluster is a k8s cluster, defined by its endpoint and the certificate of the CA that has signed its keys

- Use `$ kubectl config —kubernetes=~/.kube/config set-cluster devcluster —server=[https://192.168.29.120](https://192.168.29.120) —certificate-authority=clusterca.crt`

- The namespace is the default namespace defined in this context

- Use `$ kubectl create ns`, if it does not exist yet

- The user is a user account, defined by its X.509 certificates or other (lesson 10)

- `$ kubectl config —kubeconfig=~/.kube/config set-credentials anna —client-certificate=anna.crt —client-key=anna.key`

- After defining all, use `$ kubectl set-context devcluster —cluster=devcluster —namespace=devspace —user=anna`, to define the new context

**Lesson 2 Lab: Building a Kubernetes Cluster**

——————————————————

**Module 2: Running Applications**

——————————————————
**Lesson 3: Deploying Kubernetes Applications**

3.1 Using Deployments

- the deployment is the standard way for running containers in kubernetes
- Deployments are responsible for starting Pods in a scalable way
- The Deployment resource uses a ReplicaSet to manage scalability
- Also, the Deployment offers the RollingUpdate feature to allow for zero-downtime application updates
- To start a deployment the imerative way, use $ kubectl create deploy …

3.2 Running Agents with DaemonSets

- A DaemonSet is a resource that starts one application instance on each cluster node
- It is commonly used to start agents like the kube-proxy & calico-agent that need to be running all cluster nodes
- It can also be used for user workloads
- If the DaemonSet needs to run on control-plane nodes, a toleration must be configured to allow the node to run regardless of the control-plane taints
- DeamonSets do not need a replicaset, because it is controlling pods directly
- $ kubectl get ds -n kube-system calico-node -o yaml | less
- for more refrence —> [kubernetes.io/docs](http://kubernetes.io/docs) search for daemonset

3.3 Using StatefulSets

- A stateless application is an application that doesn’t store any session data
- Redirecting rtaffic in a stateless application is easy, the traffic can just be directed to another Pod instance
- A stateful application saves session data to persistent storage
- Databases are an example of stateful applications
- Even if stateful applications can be started by a Deployment, it’s better to start it in a StaatefulSet
- A statefulSet offers features that are needed by stateful applications

- It provides guarantees about ordering and uniqueness of Pods
- It maintains a sticky identifier for each of the Pods it creates
- Pods in a StatefulSet are not interchangable: each Pod has a persistent identifier that it maintains while being rescheduled
- The unique Pod identifiers make it easier to match existing volumes to replace Pods

- StatefulSet is used for applications that require one or more of the following (if none of these is neede, Deployment should be used):

- Stable and unique network identifiers
- Stable persistent storage
- Ordered, graceful deployment and scaling
- Ordered and automated rolling update

**StatefulSet Considerations**

- Storage must be automatically provisioned by a persistent volume provisioner. Pre-provisioning is challenging, as volumes need to be dynamically added when new Pods are scheduled
- When a StatefulSet is deleted, associated volumes will not be deleted
- A headless Service resource (ClusterIP: None) must be created in order to manage the network identity of Pods
- Pods are not guaranteed to be stopped while deleting a StatefulSet, and it is recommended to scale down to zero Pods before deleting the StatefulSet

3.4 The Case for Running Individual Pods

- Running individual Pods has disadvantages:

- No workload protection
- No load balancing
- No zero-downtime application update

- Use individual Pods only for testing, troubleshooting, and analyzing
- In all other cases, use Deployment, DaemonSet or StatefulSet
- $ kubectl run —> Create and run a particular image in a pod

3.5 Managing Pod Initialization

- If preparation is required before running the main container, use an init container
- Init containers run to completion, and once completed the main container can be started
- Use init containers in any case where preliminary setup is required
- for more reference —> [kubernetes.io/docs](http://kubernetes.io/docs) search for init container

3.6 Scaling Applications

- kubectl scale is used to manually scale Deployment, ReplicaSet, or StatefulSet

- $ kubectl scale deployment myapp —replicas=3

- Alternatively, HorizontalPodAutoscaler can be used

3.7 Using Sidecar Containers for Application Logging

- As a Pod should be created for each specific task, running single-container Pods is the standard
- In some cases, an additional container is needed to modify or present data generated by the main container
- Specific use cases are defined:

- Sidecar: provides additional functionality to the main container
- Ambassador: is used as a proxy to connect containers externally
- Adapter: is used to standardize or normalize main container output

- In a multi-container Pod, Pod volumes are often used as shared storage
- The Pod Volume may use PersistentVolumeClaim (PVC) to refer to a PersistentVolume, but may also directly refer to the required storage
- By using shared storage, the main container can write to it, and the helper Pod will pick up information written to the shared storage

**Lesson 3 Lab: Running a DaemonSet**

——————————————————

**Lesson 4: Managing Storage**

4.1 Understanding Kubernetes Storage Options

- A Pod is collection of two things, containers + Volumes

4.2 Accessing Storage Through Pod Volumes

- Pod Volumes are a part of the Pod specification and have the storage reference hard coded in the Pod manifest
- This is not bad, but it doesn’t allow for flexible storage allocation
- Pod volumes can be used for any storage type
- Also, the ConfigMap can be used to mount Pod Volumes
- the most ephemeral volume you can create in k8s —> Volumes: - name: test, emptyDir: {}

4.3 Configuring Persistent Volume (PV) Storage

- Persistnet Volumes (PV) are an API resource that represents specific storage
- PVs can be created manually, or automatically using StorageClass and storage provisioners
- Pods do not connect to PVs directly, but indirectly using PersistentVolumeClaim (PVC)

4.4 Configuring PVCs

- PVCs allows Pods to connect to any type of storage that is provided at a specific site
- Site-specific storage needs to be created as a PersistnetVolume, either manually or automatically using StorageClass
- Behind StorageClass a storage provisioner is required

**Notes**

- If you want to manually assign PVC to PV, you should take note that their StorageClassName should be exactly the same, if not, they are not going to bound and status will be pending.
- in manually bounding, if PVC is 1Gi and PV is 2Gi, then PVC is going to be 2Gi

4.5 Configuring Pod Storage with PV and PVCs

4.6 Using StorageClass

- StorageClass is an API resource that allows storage to be automatically provisioned
- StorageClass can also be used as a property that connects PVC and PV without using an actual StorageClass resource
- Multiple StorageClass resource can co-exist in the same cluster to provide access to different types of storage
- For automatic working, one StorageClass must be set as default.

- $ kubectl patch storageclass mysc -p ‘{“metadata”: {“annotations”:”{“[storageclass.kubernetes.io/is-default-class”:true](http://storageclass.kubernetes.io/is-default-class%E2%80%9D:true)”}}}’

- To enable automatic provisioning, StorageClass needs a backing storage provisioner
- In the PV and PVC definition, a storageClass property can be set to connect to a specific StorageClass which is useful if multiple StorageClass resources are available
- If the storageClass property is not set, the PVC will get storage from the default StorageClass
- If also no default StorageClass is set, the PVC will get stuck in a status of Pending

4.7 Understanding Storage Provisioners

- The storage Provisioner works with a StorageClass to automatically provide storage
- It runs as a Pod in the Kubernetes cluster, provided with access control configured through Roles, RoleBindings, and ServiceAccounts
- Once operational, you don’t have to manually create PersistentVolumes anymore
- In a nfs share, you can bound as many PVCs as you want

**Requirements**

- To create a storage provisioner, access permissions to the API are required
- Roles and RoleBindings are created to provide these permissions
- A ServiceAccount is created to connect the Pod to the appropriate RoleBinding
- More info in lesson 10

**Configuring a StorageProvisioner**

- on control: $ sudo apt install nfs-server -y
- on other nodes: $ sudo apt install nfs-client
- on control: $ sudo mkdir /nfsexport
- on control: $ sudo sh -c ‘echo “/nfsexport \* (rw,no_root_squash)” > /etc/exports’
- on control: $ sudo systemctl restart nfs-server
- on other nodes: $ showmount -e control_IP
- Fetch the helm binary from [github.com/helm/helm/releases](http://github.com/helm/helm/releases) and install it to /usr/local/bin
- Add the helm repo using $ helm repo add nfs-subdir-external-provisioner [https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner](https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner) nfs-subdir-external-provisioner/nfs-subdir-external-provisioner —set nfs.server=xx.xx.xx.yy —set nfs.path=/nfsexport
- use $ kubectl get pods , to verify that the nfs-subdir-provisioner Pod is running

**Creating the PVC**

- $ kubectl get pv , to verify that currently no PVs are available
- $ kubectl apply -f nfs-provisioner-pvc-test.yaml , to create a PVC
- $ kubectl get pvc,pv , to verify the PVC is created and bound to an automatically created PV
- Create any Pod that mounts the PVC storage, and verify data end up in the NFS share

**Default StorageClass**

- $ kubectl apply -f another-pvc-test.yaml
- $ kubectl get pvc , will show pending: there is no default StorageClass
- $ $ kubectl patch storageclass mysc -p ‘{“metadata”: {“annotations”:”{“[storageclass.kubernetes.io/is-default-class”:true](http://storageclass.kubernetes.io/is-default-class%E2%80%9D:true)”}}}’
- $ kubectl get pvc , will now work

4.8 Using ConfigMaps and Secrets as Volumes

- A ConfigMap is an API resource used to store site-specific data
- A secret is a base64 encoded ConfigMap
- ConfigMaps are used to store either environment variables, startup parameters or configuration files
- When a Configuration File is used in a ConfigMap or Secret, it is mounted as a volume to provide access to its contents
- ConfigMaps have 1 MB size limit, if more than this size is what you want to use, use PVs

**Creating a CM and mount it as volume**

- $ echo “hello world” > index.html
- $ kubectl create cm webindex —from-file=index.html
- $ kubectl describe cm webindex
- $ kubectl create deploy webserver —image=nginx
- $ kubectl edit deploy webserver

spec.template.spec

volumes:

- name: cmvol

configMap:

name: webindex

spec.template.spec.containers

volumeMounts:

- mountPath: /usr/share/nginx/html

name: cmvol

**Lesson 4 Lab: Setting up Storage**

——————————————————
**Lesson 5: Managing Application Access**

5.1 Exploring Kubernetes Networking

- In Kuberentes, networking happens at different levels:
- Between containers: implemented is IPC (Inter Process Communication) , no IP address, one linux process communicating with another linux process
- Between Pods: implemented by network plugins, use SDN that makes all Pods in the same broadcast domain no matter which physical node they actually access
- Between Pods and Services: implemented by Service resources
- Between users and Services: implemented by Services, with the help of Ingress

5.2 Understanding Network Plugins

- Network plugins are required to implement network traffic between Pods
- Network plugins are provided by the Kubernetes Ecosystem
- Vanilla Kubernetes does not come with a default network plugin, and you’ll have to install it while installing a cluster
- Different plugins provide different features
- Currently, the Calico plugin is commonly used because of its support for features like NetworkPolicy

5.3 Using Services to Access Applications

- Service resources are used to provide access to Pods
- If multiple Pods are used as Service endpoint, the Service will load balance traffic to the Pods
- Different types of Services can be configured:
  - ClusterIP: the service is internally exposed and is reachable only from within the cluster
  - NodePort: the Service is exposed at each node’s IP address as a port. The Service can be reached from outside the cluster at nodeip:nodeport
  - LoadBalancer: the cloud provider offers a load balancer that routes traffic to either NodePort -or ClusterIP- based Services
  - ExternalName: the Service is mapped to an external name that is implemented as a DNS CNAME record

- use `$ kubectl expose`, to expose applications through their Pods, ReplicaSet or Deployment (recommended)
- use `$ kubectl create service`, as an alternative

**Creating Services**

- `$ kubectl create deploy webshop —image=nginx —replicas=3`
- `$ kubectl get pods —selector app=webshop -o wide`
- `$ kubectl expose deploy webshop —type=NodePort —port=80`
- `$ kubectl describe svc webshop`
- `$ kubectl get svc`
- `$ curl nodeip:nodeport`

5.4 Running an Ingress Controller

- Ingress is an API object that manages external access to services in a cluster
- Ingress works with external DNS to provide URL-based access to Kubernetes applications
- Ingress consists of two parts:
  - A load Balancer available on the external network
  - An API resource that contacts the Service resources to find out about available back-end Pods
- Ingress load balancers are provided by the Kubernetes ecosystem, different load balancers are available
- Ingress exposes HTTP and HTTPS routes from outside the cluster to Services within the cluster
- Ingress uses the selector label in Services to connect to the Pod endpoints
- Traffic routing is controlled by rules defined on the Ingress resource
- Ingress can be configured to do the following, according to functionality provided by the load balancer:
  - Give Services externally-reachable URLs
  - Load balance traffic
  - Terminate SSL/TLS
  - Offer name based virtual hosting

**Installing Nginx Ingress Controller**

- `$ helm upgrade —install ingress-nginx ingress-nginx —repo [https://kubernetes.github.io/ingress-nginx](https://kubernetes.github.io/ingress-nginx) —namespace ingress-nginx —create-namespace`
- `$ kubectl get pods -n ingress-nginx`
- `$ kubectl create deploy nginxsvc —image=nginx —port=80`
- `kubectl expose deploy nginxsvc`
- `$ kubectl create ingress nginxsvc —class=nginx —rule=[nginxsvc.info/*=nginxsvc:80](http://nginxsvc.info/*=nginxsvc:80)`
- `$ kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80`
- `$ echo “127.0.0.1 nginxsvc/.info” >> /etc/hosts`
- `$ curl [nginxsvc.info:8080](http://nginxsvc.info:8080)`

5.5 Configuring Ingress

- Ingress rules catch incoming traffic that matches a specific path and optional hostname and connect that to a Service and port
- use `$ kubectl create ingress`, to create rules
- Different paths can be defined on the same host
  - `$ kubectl create ingress mygress —rule=“/mygress=mygress:80” —rule=“/yourgress=yourgress:80”`
- Different virtual hosts can be defined in the same Ingress
  - `$ kubectl create ingress nginxsvc —class=nginx —rule=[nginxsvc.info/*=nginxsvc:80](http://nginxsvc.info/*=nginxsvc:80) —rule=[otherserver.org/*=otherserver:80](http://otherserver.org/*=otherserver:80)`

**IngressClass**

- In one cluster, different Ingress controllers can be hosted, each with its own configuration
- Controllers can be included in an IngressClass
- While defining Ingress rules, the `—class` option should be used to implement the role on a specific Ingress controller
- If this option is not used, a default IngressClass must be defined
- Set [Ingressclass.kubernetes.io/is-default-class:](http://Ingressclass.kubernetes.io/is-default-class:) “true” , as an annotation on the IngressClass to make it the default
- After creating the Ingress controller as described before, an IngressClass API resource has been created
- Use `$ kubectl get ingressclass -o yaml`, to investigate its content

**Configuring Ingress Rules**

- `$ kubectl get deployment`
- `$ kubectl get svc webshop`
- `$ kubectl create ingress webshop-ingress —rule=“/=webshop:80” —rule=“/hello=newdep:8080”`
- `$ sudo vim /etc/hosts`
  - `127.0.0.1   [webshop.info](http://webshop.info)`
- `$ kubectl get ingress`
- `$ kubectl describe ingress webshop-ingress`
- `$ kubectl create deployment newdep —image=[gcr.io/google-samples/hello-app:2.0](http://gcr.io/google-samples/hello-app:2.0)`
- `$ kubectl expose deployment newdep —port=8080`
- `$ kubectl describe ingress webshop-ingress`

5.6 Using Port Forwarding for Direct Application Access

- `$ kubectl port-forward`, can be used to connect to applications for analyzing and troubleshooting
- It forwards traffic coming in to a local port on the kubectl client machine to a port that is available in a Pod
- Using port forwarding allows you to test application access without the need to configure Services and Ingress
- use `$ kubectl port-forward mypod 1234:80`, to forward local port 1234 to pod port 80
- To run in the background, use Ctrl-z or start with a & at the end of the `$ kubectl port-forward` command

**Lesson 5 Lab: Managing Networking**

——————————————————

**Module 3: Managing Kubernetes Clusters**

——————————————————

**Lesson 6: Managing Clusters**

6.1 Analyzing Cluster Nodes

- Kubernetes cluster nodes run Linux processes. To monitor these processes, generic Linux rules apply
- Use `$ systemctl status kubelet`, to get runtime information about the kubelet
- Use log files in `/var/log` as well as `$ journalctl`, output to get access to logs
- Generic node information is obtained through `$ kubectl describe`
- If the Metrics Server is installed, use `$ kubectl top nodes`, to get a summary of CPU/memory usage on a node. See lesson 7.1 for more about this
- `$ ls -lrt /var/log`
- `$ systemctl status kubelet`

6.2 Using crictl to Manage Node Containers

- All Pods are started as containers on the nodes
- crictl is a generic tool that communicates to the container runtime to get information about running containers
- As such, it replaces generic tools like docker and podman
- To use it, a runtime-endpoint and image-endpoint need to be set
- The most convenient way to do so, is by defining the `/etc/crictl.yaml` file on the nodes where you want to run crictl
- Must be run with sudo

**crictl.yaml:**

```
runtime-endpoint: unix:///var/run/containerd/containerd.sock
image-endpoint: unix:///var/run/containerd/containerd.sock
timeout: 10
debug: true
```

**Using crictl**

- list containers: `$ sudo crictl ps`
- List Pods that have been scheduled on this node: `$ sudo crictl pods`
- Inspect container configuration: `$ sudo crictl inspect <name-or-id>`
- Pull an image: `$ sudo crictl pull <imagename>`
- List images: `$ sudo crictl images`

6.3 Running Static Pods

- The kubelet systemd process is configured to run static Pods from the `/etc/kubernetes/manifests` directory
- On the control node, static Pods are an essential part of how k8s works: systemd starts kubelet, and kubelet starts core k8s services as static Pods
- Administrators can manually add static Pods if so desired, just copy a manifest file into the `/etc/kubernetes/manifests` directory and the kubelet process will pick it up
- To modify the path where kubelet picks up the static Pods, edit `staticPodPath` in `/var/lib/kubelet/config.yaml` and use `$ sudo systemctl restart kubelet`, to restart
- **NEVER DO THIS ON THE CONTROL NODE!**
- On controller node: `$ ls /etc/kubernetes/manifests/ —>`

```
etcd.yaml, kube-apiserver.yaml, kube-controller-manager.yaml, kube-scheduler.yaml
```

- On worker node: `$ ls /etc/kubernetes/manifests/ —>`

```
(empty)
```

**Running static Pods**

- `$ kubelet run staticpod —image=nginx —dry-run=client -o yaml > staticpod.yaml`
- `$ sudo cp staticpod.yaml /etc/kubernetes/manifests/`
- `$ kubectl get pods -o wide`

6.4 Managing Node State

- `$ kubectl cordon —>` used to mark a node as unschedulable, so pods won’t start/execute on that worker node anymore
- `$ kubectl drain —>` is used to mark a node as unschedulable and remove all running Pods from it
- Pods that have been started from a DaemonSet will not be removed while using `$ kubectl drain`, add `—ignored-daemonsets`, to ignore that
- Add `—delete-emptydir-data`, to delete data from emptyDir pod volumes
- While using cordon or drain, a taint is set on the nodes (lesson 8.4)
- Use `$ kubectl uncordon`, to get the node back in a schedulable state

**Managing Node State**

- `$ kubectl cordon worker2`
- `$ kubectl describe node worker2` (look for taints)
- `$ kubectl get nodes`
- `$ kubectl uncordon worker2`

6.5 Managing Node Services

- The container runtime (often containerd) and kubelet are managed by the Linux systemd service manager
- Use `$ systemctl status kubelet`, to check the current status of the kubelet
- To manually start it, use `$ sudo systemctl start kubelet`
- Notice that Pods that are scheduled on a node show as container processes in `$ ps aux`, output. Don’t use Linux tools to manage Pods
- When `$ ps aux | grep containerd`, for each container on node there is a containerd process

**Managing Node Services**

- `$ ps aux | grep kubelet`
- `$ ps aux | grep containerd`
- `$ systemctl status kubelet`
- `$ sudo systemctl stop kubelet`
- `$ sudo systemctl start kubelet`

**Lesson 6 Lab: Running Static Pods**

——————————————————
**Lesson 7: Performing Node Maintenance Tasks**

7.1 Using Metrics Server to Monitor Node and Pod State

- Kubernetes monitoring is offered by the integrated Metrics Server
- The server, after installation, exposes a standard API and can be used to expose custom metrics
- Use `$ kubectl top`, to see a top-like interface to provide resource usage information

**Setting up metrics Server**

- see [https://github.com/kubernetes-sigs/metrics-server.git](https://github.com/kubernetes-sigs/metrics-server.git)
- Read github documentation!
- `$ kubectl apply -f [https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml](https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml)`
- `$ kubectl -n kube-system get pods` (look for metrics-server)
- `$ kubectl -n kube-system edit deployment metrics-server`

    In `spec.template.spec.containers.args`, use the following:

    - `—kubelet-insecure-tls`
    - `—kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname`

- `$ kubectl -n kube-system logs metrics-server<TAB>` should show “Generating self-signed cert” and “Serving securely on [::]443”
- `$ kubelet top pods —all-namespaces`, will show most active pods

7.2 Backing up the Etcd

- The etcd is a core Kubernetes service that contain all resources that have been created
- It is started by the kubelet as a static Pod on the control node
- Losing etcd means losing all your configuration
- To back up the etcd, root access is required to run the etcdctl tool
- Use `$ sudo apt install etcd-client`, to install this tool
- etcdctl uses the wrong API version by default, fix this by using `$ sudo ETCDCTL_API=3 etcdctl … snapshot save`
- To use etcdctl, you need to specify the etcd service API endpoint, as well as cacert, cert and key to be used
- Values for all of these can be obtained by using `$ ps aux | grep etcd`

**Backing up etcd**

- `$ sudo apt install etcd-client`
- `$ sudo etcdctl —help; sudo ETCDCTL_API=3 etcdctl —help`
- `$ ps aux | grep etcd`
- `$ sudo ETCDLCTL_API=3 etcdctl —endpoints=localhost:2379 —cacert /etc/kubernetes/pki/etcd/ca.crt —cert /etc/kubernetes/pki/etcd/server.crt —key /etc/kubernetes/pki/etcd/server.key get / —prefix --keys-only —> to make sure we can access keys from API`
- `$ sudo ETCDLCTL_API=3 etcdctl —endpoints=localhost:2379 —cacert /etc/kubernetes/pki/etcd/ca.crt —cert /etc/kubernetes/pki/etcd/server.crt —key /etc/kubernetes/pki/etcd/server.key snapshot save /tmp/etcdbackup.db`

**Verifying the Etcd Backup**

- `$ sudo ETCDCTL_API=3 etcdctl —write-out=table snapshot status /tmp/etcdbackup.db`
- Just to be sure: `$ cp /tmp/etcdbackup.db /tmp/etcdbackup.db.2`

7.3 Restoring the Etcd

- `$ sudo ETCDCTL_API=3 etcdctl snapshot restore /tmp/etcdbackup.db —data-dir /var/lib/etcd-backup`, restores the etcd backup in a non-default folder
- To start using it, the Kubernetes core service must be stopped, after which the etcd can be reconfigured to use the new directory
- To stop the core services, temporarily move `/etc/kubernetes/manifests/*.yaml` to somewhere else
- As the kubelet process temporarily polls for static Pod files, the etcd process will disappear within a minute
- Use `$ sudo crictl ps`, to verify that it has been stopped
- Once the etcd Pod has stopped, reconfigure the etcd to use the non-default etcd path
- In etcd.yaml you’ll find a HostPath volume with the name etcd-data, pointing to the location where the Etcd files are found. Change this to the location where the restored files are
- Move back the static Pod to `/etc/kubernetes/manifests`
- Use `$ sudo crictl ps`, to verify the Pods have restarted successfully
- Next, `$ kubectl get all`, should show the original Etcd resources

**Restoring the Etcd**

- `$ kubectl delete —all deploy`
- `$ cd /etc/kubernetes/manifests/`
- `$ sudo mv * ..` (this will stop all running Pods)
- `$ sudo crictl ps`
- `$ sudo ETCDLCTL_API=3 etcdctl snapshot restore /tmp/etcdbackup.db —data-dir /var/lib/etcd-backup`
- `$ sudo ls -l /var/lib/etcd-backup`
- `$ sudo vi /etc/kubernetes/etcd.yaml` (change etcd-data HostPath volume to /var/lib/etcd-backup)
- `$ sudo mv ../*.yaml`
- `$ sudo crictl ps` (should show all resources)
- `$ kubectl get deploy -A`

7.4 Performing Cluster Node Upgrades

- Kubernetes clusters can be upgraded from one to another minor version
- Skipping minor versions (1.23 to 1.25) is not supported
- First, you’ll have to upgrade kubeadm
- Next, you’ll need to upgrade the control plane node
- After that, the worker nodes are upgraded, which is pretty similar to Control Plane Node update, even simpler than that
- Exam tip: Use “Upgrading kubeadm clusters” from the documentation

**Control Plane Node Upgrade**

- Upgrade kubeadm
- Use `$ kubeadm upgrade plan`, to check available versions
- Use `$ kubeadm upgrade apply v1.xx.y`, to run the upgrade
- Use `$ kubectl drain controlnode —ignore-daemonsets`
- Upgrade and restart kubelet and kubectl
- Use `$ kubectl uncordon controlnode`, to bring back the control node
- Proceed with other nodes

7.5 Understanding Cluster High Availability (HA)

**Options**

- There are two ways for HA:

    1.  Stacked control plane nodes requires less infrastructure as the etcd members, and control plane nodes are co-located
        - Control planes and etcd members are running together on the same node
        - For optimal protection, requires a minimum of 3 stacked control plane nodes

    3.  External etcd cluster requires more infrastructure as the control plane nodes and etcd members are separated
        - Etcd service is running on external nodes, so this requires twice the number of nodes

**HA requirements**

- In a k8s HA cluster, a load balancer is needed to distribute the workload between the cluster nodes
- The load balancer can be externally provided using open source software, or a load balancer appliance
- Knowledge of setting up the load balancer is not required on the CKA exam: in this course a load balancer setup script is provided
- In the load balancer setup, HAProxy is running on each server to provide access to port 8443 on all IP addresses on that server
- Incoming traffic on port 8443 is forwarded to the kube-apiserver port 6443
- The keepalived service is running on all HA nodes to provide a virtual IP address on one of the nodes
- kubectl clients connect to this VIP:8443
- Use the setup-lb-ubuntu.sh script provided in the github repository for easy setup
- Additional instructions are in the script
- After running load balancer setup, use `$ nc 192.168.29.100 8443`, to verify the availability of the load balancer IP and port

7.6 Setting up a Highly Available Kubernetes Cluster

**Cluster Node requirements**

- 3 VMs to be used as controllers in the cluster; install k8s software but don’t set up the cluster yet
- 2 VMs to be used as worker nodes; install k8s software
- Ensure `/etc/hosts` is set up for name resolution of all nodes and copy to all nodes
- Disable selinux on all nodes if applicable
- Disable firewall if applicable

**Initializing HA setup**

- `$ sudo kubeadm init —control-plane-endpoint “192.168.29.100:8443” —upload-certs`
- Save the output of the command which shows next steps
- Configure networking
- `$ kubectl apply -f [https://docs.projectcalico.org/manifests/calico.yaml](https://docs.projectcalico.org/manifests/calico.yaml)`
- Copy the kubectl join command that was printed after successfully initializing the first control node
- Make sure to use the command that has `—control-plane` in it!
- Complete setup on other control nodes as instructed
- Use `$ kubectl get nodes`, to verify setup
- Continue and join worker nodes as instructed

**Configuring HA client**

- On the machine you want to use as operator workstation, create a `.kube` directory and copy `/etc/kubernets/admin.conf` from any control node to the client machine
- Install the kubectl utility
- Ensure that host name resolution goes to the new control plane VIP
- Verify using `$ kubectl get nodes`

**Testing it!**

- On all nodes: find the VIP using `$ ip a`
- On all nodes with a kubectl, use `$ kubectl get all`, to verify client working
- Shut down the nodes that have the VIP
- Verify that `$ kubectl get all`, still works
- Troubleshooting: consider using `$ sudo systemctl restart haproxy`

**Lesson 7 Lab: Etcd Backup and Restore**

——————————————————

**Lesson 8: Managing Scheduling**

8.1 Exploring the Scheduling Process

- Kube-scheduler takes care of finding a node to schedule new Pods
- Nodes are filtered according to specific requirements that may be set:
  - Resource requirements
  - Affinity and anti-affinity
  - Taints and tolerations and more
- The scheduler first finds feasible nodes then scores them; it picks the node with the highest score
- Once this node is found, the scheduler notifies the API server in a process called binding
- Once the scheduler decision has been made, it is picked up by the kubelet
- The kubelet will instruct the CRI to fetch the image of the required container
- After fetching the image, the container is created and started

8.2 Setting Node Preferences

- The nodeSelector field in the pod.spec specifies a key-value pair that must match a label which is set on nodes that are eligible to run the Pod
- Use `$ kubectl label nodes [worker1.example.com](http://worker1.example.com) disktype=ssd`, to set the label on a node
- Use `nodeselector:disktype:ssd` in the pod.spec to match the Pod to the specific node
- `nodeName` is part of the pod.spec and can be used to always run a Pod on a node with a specific name
  - Not recommended: if the node is not currently available; the Pod will never run

**Using Node Preferences**

- `$ kubectl label nodes worker2 disktype=ssd`
- `$ kubectl apply -f selector-pod.yaml`

8.3 Managing Affinity and Anti-Affinity Rules

- (Anti-)Affinity is used to define advanced scheduler rules
- Node affinity is used to constrain a node that can receive a Pod by matching labels of these nodes
- Inter-pod affinity constrains node to receive Pods by matching labels of existing Pods already running on that node
- Anti-affinity can only be applied between Pods, in order to make sure that specific pods are not going to schedule together
- A pod that has a node affinity label of key=value will only be scheduled to nodes with a matching label
- A pod that has a Pod affinity label of key=value will only be scheduled to nodes running Pods with the matching label

**Setting Node Affinity**

- To define node affinity, two different statements can be used:
  - `requiredDuringSchedulingIgnoredDuringExecution` requires the node to meet the constraint that is defined
  - `preferredDuringSchedulingIgnoredDuringExecution` defines a soft affinity that is ignored if it cannot be fulfilled
- At the moment, affinity is only applied while scheduling Pods, and cannot be used to change where Pods are already running
- Affinity rules go beyond labels that use a key=value label
- A `matchexpression` is used to define a key (the label), an operator as well as optionally one or more values.

**Example Affinity Rules**

- Below affinity rule, matches any node that has type set to either blue or green:

```
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        - matchExpressions:
            - key: type
              operator: In
              values:
                - blue
                - green
```

- Below affinity rule, matches any node where the key storage is defined:

```
nodeSelectorTerms:
  - matchExpressions:
      - key: storage
        operator: Exist
```

- Some other examples are in the github repo of course:
  - `pod-with-node-affinity.yaml`
  - `pod-with-node-anti-affinity.yaml`
  - `pod-with-pod-affinity.yaml`

- When defining Pod affinity and anti-affinity, a `topologyKey` property is required
- The `topologyKey` refers to a label that exists on nodes, and typically has a format containing a slash
  - [kubernetes.io/host](http://kubernetes.io/host)
- Using `topologyKeys` allows the Pods only to be assigned to hosts matching the topologyKey
- This allows administrators to use zones where the workloads are implemented
- If no matching `topologyKey` is found on the host, the specified `topologyKey` will be ignored in the affinity

**Using Pod Anti-Affinity**

- `$ kubectl create -f redis-with-pod-affinity.yaml`
- On a two-node cluster, one Pod stays in a state of pending
- `$ kubectl create -f web-with-pod-affinity.yaml`
- This will run web instances only on nodes where redis is running as well

8.4 Managing Taints and Tolerations

- Taints are applied to a node to mark that the node should not accept any Pod that doesn’t tolerate the taint
- Tolerations are applied to Pods and allow (but do not require) Pods to schedule on nodes with matching Taints - so they are an exception to taints that are applied
- Where Affinities are used on Pods to attract them to specific nodes, Taints allow a node to repel a set of Pods
- Taints and Tolerations are used to ensure Pods are not scheduled on inappropriate nodes, and thus make sure that dedicated nodes can be configured for dedicated tasks
- A control node is a control node just because a couple of taints are set that don't allow user pods to be executed on them
- Three types of Taint can be applied:
  - `NoSchedule`: does not schedule new Pods
  - `PreferNoSchedule`: does not schedule new Pods, unless there is no other option
  - `NoExecute`: migrates all pods away from this node
- If the pod has a toleration however, it will ignore the taint

**Taints are set in different ways**

- Control plane nodes automatically get taints that won’t schedule user Pods
- When `$ kubectl drain`, and `$ kubectl cordon`, are used, a taint is applied on the target node
- Taints can be set automatically by the cluster when critical conditions arise, such as a node running out of disk space
- Administrators can use `$ kubectl taint`, to set taints:

```
$ kubectl taint node worker1 key1=value1:NoSchedule  # Add a taint
$ kubectl taint node worker1 key1=value1:NoSchedule  # Remove a taint
```

- To allow a Pod to run on a node with a specific taint, a toleration can be used
- This is essential for running core k8s Pods on the control plane nodes
- While creating taints and tolerations, a key and value are defined to allow for more specific access

```
$ kubectl taint nodes worker1 storage=ssd:NoSchedule
```

- While defining a toleration, the Pod needs a key, operator, and value:

```
tolerations:
  - key: "storage"
    operator: "Equal"
    value: "ssd"
```

- The default value for the operator is “Equal”; as an alternative, “Exist” is commonly used
- If the operator “Exists” is used, the key should match the taint key and the value is ignored
- If the operator “Equal” is used, the key and value must match

**Node conditions that can automatically create taints:**

- memory-pressure
- disk-pressure
- pid-pressure —> running out of pids
- unschedulable
- network-unavailable

- If any of these conditions apply, a taint is automatically set
- Node conditions can be ignored by adding corresponding Pod tolerations, but this is really a bad idea

**Using Taints**

- `$ kubectl taint nodes worker1 storage=ssd:NoShcedule`
- `$ kubectl describe nodes worker1`
- `$ kubectl create deployment nginx-taint --image=nginx`
- `$ kubectl scale deployment nginx-taint --replicas=3`
- `$ kubectl get pods -o wide` (will show that pods are all on worker2)
- `$ kubectl create -f taint-toleration.yaml` (will run)
- `$ kubectl create -f taint-toleration2.yaml` (will not run)

8.5 Understanding LimitRange and Quota

- LimitRange is an API object that limits resource usage per container or Pod in a Namespace
- It uses three relevant options:
  - `type`: specifies whether it applies to Pods or containers
  - `defaultRequest`: the default resources the application will request
  - `default`: the maximum resources the application can use
- Quota is an API object that limits total resources available in a Namespace
- If a Namespace is configured with Quota, applications in that Namespace must be configured with resource settings in `pod.spec.containers.resources`
- Where the goal of the LimitRange is to set default restrictions for each application running in a Namespace, the goal of Quota is to define maximum resources that can be consumed within a Namespace by all applications

8.6 Configuring Resource Limits and Requests

- `$ kubectl create namespace limited`
- `$ kubectl create quota qtest --hard pods=3,cpu=100m,memory=500Mi --namespace limited`
- `$ kubectl describe quota --namespace limited`
- `$ kubectl create deploy nginx --image=nginx:latest --replicas=3 -n limited`
- `$ kubectl get all -n limited` (no pods)
- `$ kubectl describe rs/nginx-xxx -n limited` (it fails because no quota has been set on the deployment)
- `$ kubectl set resources deploy nginx --requests cpu=100m,memory=5Mi --limits cpu=200m,memory=20Mi -n limited`
- `$ kubectl get pods -n limited`

8.7 Configuring LimitRange

- `$ kubectl explain limitrange.spec.limits`
- `$ kubectl create ns limited`
- `$ kubectl apply -f limitrange.yaml -n limited`
- `$ kubectl describe ns limited`
- `$ kubectl run limitpod --image=nginx -n limited`
- `$ kubectl describe pod limitpod -n limited`

**Lesson 8 Lab: Configuring Taints**

——————————————————

**Lesson 9: Networking**

9.1 Managing the CNI and Network Plugins

- The Container Network Interface (CNI) is the common interface used for networking when starting kubelet on a worker node
- The CNI doesn’t take care of networking, that is done by the network plugin
- CNI ensures the pluggable nature of networking, and makes it easy to select between different network plugins provided by the ecosystem
- The CNI plugin configuration is in `/etc/cni/net.d`
- Some plugins have generic settings, and are using additional configuration
- Often, the additional configuration is implemented by Pods
- Generic CNI documentation is on [https://github.com/containernetworking/cni](https://github.com/containernetworking/cni)

9.2 Understanding Service Auto Registration

- k8s runs the coredns Pods in the kube-system Namespace as internal DNS servers
- These Pods are exposed by the kubedns Service
- Service register with this kubedns Service
- Pods are automatically configured with IP address of the kubedns Services as their DNS resolver
- As a result, all Pods can access all Services by name
- If a Service is running in the same Namespace, it can be reached by the short hostname
- If a Service is running in another Namespace, an FQDN consisting of servicename.namespace.svc.clustername must be used
- The clustername is defined in the coredns Corefile and set to `cluster.local` if it hasn’t been changed, use `$ kubectl get cm -n kube-system coredns -o yaml` to verify

**Accessing Services by Name**

- `$ kubectl run webserver --image=nginx`
- `$ kubectl expose pod webserver --port=80`
- `$ kubectl run testpod --image=busybox --sleep 3600`
- `$ kubectl get svc`
- `$ kubectl exec -it testpod -- wget webserver`

**Accessing Pods in other Namespaces**

- `$ kubectl create ns remote`
- `$ kubectl run interginx --image=nginx`
- `$ kubectl run remotebox --image=busybox -n remote -- sleep 3600`
- `$ kubectl expose pod interginx --port=80`
- `$ kubectl exec -it remotebox -n remote -- cat /etc/resolv.conf`
- `$ kubectl exec -it remotebox -n remote -- nslookup interginx` (fails)
- `$ kubectl exec -it remotebox -n remote -- nslookup interginx.default.svc.cluster.local`

9.3 Using Network Policies to Manage Traffic Between Pods

- By default, there are no restrictions to network traffic in k8s
- Pods can always communicate, even if they’re in other Namespaces
- To limit this, NetworkPolicies can be used
- NetworkPolicies need to be supported by the network plugin though
- The weave plugin does not support NetworkPolicies
- If in a policy there is no match, traffic will be denied
- If no NetworkPolicy is used, all traffic is allowed
- In NetworkPolicy, three different identifiers can be used:
  - Pods: `(podSelector)` note that a Pod cannot block access to itself
  - Namespaces: `(namespaceSelector)` to grant access to specific Namespaces
  - IP blocks: `(ipBlock)` notice that traffic to and from the node where a Pod is running is always allowed
- When defining a Pod- or Namespace-based NetworkPolicy, a selector label is used to specify what traffic is allowed to and from the Pods that match the selector
- NetworkPolicies do not conflict, they are additive

**Exploring NetworkPolicy**

- `$ kubectl apply -f nwpolicy-complete-example.yaml`
- `$ kubectl expose pod nginx --port=80`
- `$ kubectl exec -it busybox -- wget --spider --timeout=1 nginx` (will fail)
- `$ kubectl label pod busybox access=true`
- `$ kubectl exec -it busybox -- wget --spider --timeout=1 nginx` (will work)

9.4 Configuring Network Policies to Manage Traffic Between Namespaces

- To apply a NetworkPolicy to a Namespace, use `-n namespace` in the definition of the NetworkPolicy
- To allow ingress and egress traffic, use the `namespaceSelector` to match the traffic

**Using Network Policies Between Namespaces**

- `$ kubectl create ns nwp-namespace`
- `$ kubectl create -f nwp-lab9-1.yaml`
- `$ kubectl expose pod nwp-nginx --port=80`
- `$ kubectl exec -it nwp-busybox -n nwp-namepace -- wget --spider --timeout=1 nwp-nginx` (gives bad address error)
- `$ kubectl exec -it nwp-busybox -n nwp-namespace -- nslookup nwp-nginx` (explains that it’s looking in the wrong ns)
- `$ kubectl exec -it nwp-busybox -n nwp-namespace -- wget --spider --timeout=1 nwp-nginx.default.svc.cluster.local` (is allowed)
- `$ kubectl create -f nwp-lab9-2.yaml`
- `$ kubectl exec -it nwp-busybox -n nwp-namespace -- wget --spider --timeout=1 nwp-nginx.default.svc.cluster.local` (is not allowed)
- `$ kubectl create deployment busybox --image=busybox -- sleep 3600`
- `$ kubectl exec -it busybox[TAB] -- wget --spider --timeout=1 nwp-nginx`

**Lesson 9 Lab: Using NetworkPolicies**

——————————————————

**Lesson 10: Managing Security Settings**

10.1 Understanding API Access

10.2 Managing SecurityContext

10.3 Using ServiceAccounts to Configure API Access

10.4 Setting Up Role Based Access Control (RBAC)

10.5 Configuring Cluster Roles and RoleBindings

10.6 Creating Kubernetes User Accounts

**Lesson 10 Lab: Managing Security**

——————————————————

**Lesson 11: Logging, Monitoring, and Troubleshooting**

11.1 Monitoring Kubernetes Resources

11.2 Understanding the Troubleshooting Flow

11.3 Troubleshooting Kubernetes Applications

11.4 Troubleshooting Cluster Nodes

11.5 Fixing Application Access Problems

**Lesson 11 Lab: Troubleshooting Nodes**

——————————————————

**Module 4: Practice CKA Exam**

——————————————————

**Lesson 12: Practice CKA Exam 1**

12.1 Question Overview

12.2 Creating a Kubernetes Cluster

12.3 Scheduling a Pod

12.4 Managing Application Initialization

12.5 Setting up Persistent Storage

12.6 Configuring Application Access

12.7 Securing Network Traffic

12.8 Setting up Quota

12.9 Creating a Static Pod

12.10 Troubleshooting Node Services

12.11 Configuring Cluster Access

12.12 Configuring Taints and Tolerations

——————————————————

**Lesson 13: Practice CKA Exam 2**

13.1 Question Overview

13.2 Configuring a High Availability Cluster

13.3 Etcd Backup and Restore

13.4 Performing a Control Node Upgrade

13.5 Configuring Application Logging

13.6 Managing Persistent Volume Claims

13.7 Investigating Pod Logs

13.8 Analyzing Performance

13.9 Managing Scheduling

13.10 Configuring Ingress

13.11 Preparing for Node Maintenance

13.12 Scaling Applications

——————————————————

**Summary**

Certified Kubernetes Administrator (CKA): Summary

——————————————————