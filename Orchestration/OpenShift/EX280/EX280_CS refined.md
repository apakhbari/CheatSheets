# Red Hat EX280

## Red Hat OpenShift Administration

---

- Module 1: Managing OpenShift Clusters
  - 1: Understanding OpenShift Clusters
  - 2: Managing OpenShift Clusters

- Module 2: Managing OpenShift Resources
  - 3: Managing OpenShift Resources
  - 4: Managing OpenShift Storage

- Module 3: Managing OpenShift Authentication and Access
  - 5: Configuring Authentication
  - 6: Managing Access Control

- Module 4: Performing Operational Cluster Management Tasks
  - 7: Managing OpenShift Networking
  - 8: Managing Pod Scaling and Scheduling
  - 9: Managing OpenShift Clusters

- Module 5: Red Hat Certified Specialist in OpenShift Sample Exam
  - 10: EX280 Sample Exam

---

## Module 1: Managing OpenShift Clusters

---

### 1-Understanding OpenShift Clusters

#### 1.1 Understanding the OpenShift Product Offering
- Red Hat OpenShift Container Platform extends Kubernetes with features commonly needed in the corporate datacenter
- Different OpenShift offerings exist
  - Red Hat OpenShift Container Platform: a platform that is managed by the customer to provide OpenShift service on physical or virtual infrastructure, on premise or in the cloud
  - Red Hat OpenShift Dedicated: a Red Hat managed cluster offered in AWS, GCP, Azure, or IBM cloud
  - Cloud-provider managed OpenShift solutions
  - Red Hat OpenShift Online: a Red Hat managed OpenShift infrastructure that is shared across multiple customers
  - Red Hat OpenShift Kubernetes Engine: just Kubernetes and related features
  - Red Hat Code Ready Containers: a minimal OpenShift installation
  - OKD: the OpenShift open source upstream

#### 1.2 Understanding OpenShift Components
- **Control node** → runs all OpenShift services. It exists no matter if it's on cloud or on-premise. It runs CoreOS, and uses CRI-O as the container image. On top of CoreOS and CRI-O, there is Kubernetes (kube scheduler).
- **Compute nodes** → orchestrated by the control node. On version 4 and later, it is based on CoreOS, which is immutable. This means nothing can go wrong with it, it's container-like. It exists no matter if it's on cloud or on-premise. It uses CRI-O as the container image, and on top of CoreOS and CRI-O, there is Kubernetes (kubelet).
- **Web console**
- **oc**
- **Registry** → images → S2I
- **Monitoring**

#### Core Components
- CoreOS: the immutable operating system which is used as the OS foundation
- CRI-O: Open Container Initiative (OCI) compliant container runtime, used as the foundation to run containers
- Kubernetes: the open-source orchestration platform
- A web console
- Pre-installed application services such as an internal container image registry and monitoring framework
- Certified container images for programming languages, databases, and more

### OpenShift Features
- **High Availability**: core components are offered in a redundant HA setup
- **Load Balancing**: external load balancers are provided for access to the applications
- **Automatic Scaling**: number of replicas automatically scaled up or down when needed
- **Logging and Monitoring**: integrated Prometheus is used for gathering cluster metrics, and Elasticsearch is included for aggregated logging
- **Service Discovery**: based on an internal DNS service that auto-registers all applications
- **Storage**: provided by Kubernetes to offer access to many types of cloud, cluster, or local storage
- **Source To Image**: automatically builds and runs applications from source code
- **Application Catalog**: contains many runtime languages used in S2I, and can be extended by installing new operators
- **Operators**: ready-to-run added functionality that makes working with OpenShift easier

### 1.3 Using Cluster Operators

- Operators are apps that extend k8s functionality, they typically are used to manage other apps, they automate tasks (deploy, update, backup) that normally would be done by a human admin.
- Operators vs helm chart: operators can work with API extensions.
- Operators are started from container images and use Custom Resources to store their settings and configurations.
- Operators can be written in any programming language, no specific SDK is used, they just need to meet two requirements:
  - Ability to invoke REST APIs
  - Use secrets that contain access credentials to the Kubernetes APIs

- Operator Framework is a toolkit for building, testing, and packaging operators.
- Operator Software Development Kit: Contains code examples and a container image that can be used as a template.
- Operator Life Cycle Manager (OLM): provides an app that manages the operator lifecycle when deployed using an operator catalog.
- OperatorHub is a web interface that is used as an operator registry for publishing and accessing operators.
- OpenShift cluster operators are managed by the OpenShift cluster version operator.
- OpenShift cluster operators provide OpenShift extension APIs and cluster infrastructure services.

- The OAuth server, which authenticates access to the control node and APIs.
- Core DNS, the internal DNS server.
- Web Console, the management interface.
- Internal image registry, allows for the storing of internal images.
- Monitoring, generates metrics and alerts about cluster health.

- OpenShift operators and its managed apps share the same project, found as the openshift-* projects.
- Every cluster operator defines a custom resource of the type ClusterOperator.
- ClusterOperator API exposes information about the specific operator components such as health status or version information.

### 1.4 Understanding OpenShift Architecture

#### Controller node:
- CRI-O - kubelet (it is still a Pod as k8s views it).
- k8s Static Pods (what starts k8s. kubelet starts them in order to work): etcd - kube scheduler - kube controller manager - kube api server.
- OpenShift additional services: OpenShift api server - OpenShift controller manager - Core DNS - operators.

#### Worker nodes:
- CRI-O - kubelet.
- User Pod.

- Load Balancer: it’s an external resource, taking care of user pods + different OpenShift controller node services that are running via HA.

### 1.5 Understanding OpenShift Installation Methods

- Depending on how you are going to use OpenShift, you might not even have to install it.
- Red Hat OpenShift Dedicated runs in the cloud and is managed and installed by Red Hat.
- Red Hat OpenShift Container Platform can be installed on-premise.
- Red Hat OpenShift Online is managed and installed in the cloud.
- OKD can be installed on-premise.
- Code Ready Containers provides a minimal installation that you can run on your own laptop.
- Full-Stack Automation is the method that requires minimum installation data to set up a fully functional OpenShift cluster on pre-existing cloud or virtualization provider.
  - Supported on limited virtualization and cloud providers.
  - All nodes run RHEL CoreOS.
  - For example, Node auto-scaler is only available in this mode.
- Pre-existing infrastructure requires you to configure a set up computer, storage, and network resources which are next used by the OpenShift installer. Use this method to install on bare-metal or unsupported cloud and virtualization providers.
- Control plane nodes run RHEL CoreOS, worker nodes may run RHEL.

#### Deployment Process (not part of EX280, Red Hat has a course about it):
- (Process needs 3 machines: bootstrap machine, temporary control plane machine, final control plane machine.)
  - A bootstrap machine is created.
  - The bootstrap machine boots and starts hosting the resources required for booting control plane machines.
  - Control plane machines get remote resources from the bootstrap machine and finish booting.
  - Control plane machines create an etcd cluster and start a temporary Kubernetes cluster.
  - The temporary control plane schedules the final control plane.
  - Temporary control plane is replaced by the final control plane.
  - The bootstrap node injects OpenShift-specific components into the control plane.
  - The installer tears down the bootstrap machine.

### 1.6 Performing a Code Ready Containers-Based Installation

- On [developers.redhat.com](http://developers.redhat.com) you can get access to Code Ready Containers, which is all-in-one Red Hat licensed version of OpenShift 4.
  - CRC works on mac, windows, and linux.
  - Recommended: dedicated Linux VM to avoid any conflicts.
  - System Requirements: 4 vCPUs, 16 GB RAM, 35 GB of storage in /home.
  - OKD 4 can be installed as well, but requires a recommended minimum of 20GB of RAM.
  - To work with CRC, download the xz archive, as well as the pull secret from [developers.redhat.com](http://developers.redhat.com).
  - CentOS / RedHat / Fedora is supported.
  - Required packages: libvirt and NetworkManager.
  - `$ crc setup`, as non-root to provide initial setup.
  - `$ crc start -p pull-secret -m 12244`, to start, import the pull secret, and define it gets 12GB of RAM as well.
  - `$ crc console`, gives access to the CRC console.
  - `$ crc console --credentials`, prints credentials.
  - `$ crc oc-env`, prints a command to execute to add the oc binary to your path.
  - `$ source <(oc completion bash)` — setting up auto completion.

#### CRC Considerations
- CRC clusters need to be rebuilt often.
  - `$ crc cleanup` → delete the old cluster.
  - `$ crc setup; crc start` → run a new cluster.
  - Make sure to select `htpassword_provider` in the password field before logging in as developer.
  - `$ oc get co` → verify availability of operators.
  - `$ cat .crc/machines/crc/kubeadmin-password` → if forget password, you can find it here.

---
