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
