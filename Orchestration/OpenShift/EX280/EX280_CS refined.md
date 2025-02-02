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
# 2-Managing OpenShift Clusters with Web Console

## 2.1 Managing Clusters with Web Console
- On CRC use `$ crc console` → limited feature availability because some essential operators are missing
- In full clusters use `$ oc get routes -n openshift-console`
- `$ oc whoami —show-console`

## 2.2 Managing Common Workloads with Web Console

## 2.3 Managing Operators with Web Console

## 2.4 Monitoring Cluster Events and Alerts

---

## **Module 2:** Managing OpenShift Resources

---

# 3-Managing OpenShift Resources

## 3.1 Working with Projects
- Linux kernel provides namespaces to offer strict isolation between processes
- k8s implements namespaces in a cluster environment
  - To limit inter-namespace access
  - To apply resource limitations
  - To delegate management tasks to users
- OpenShift implements k8s namespaces as a vehicle to manage access to resources for users, in OpenShift namespaces are reserved for cluster-level admin access and users work with projects to store their resources

## 3.2 Running Applications
- After creating a project, `$ oc new-app` can be used to create an app
- While creating an app, different k8s resources are created:
  - **Deployment or deploymentconfig**: the app itself, including its cluster properties
  - **Replicationcontroller or replicaset**: takes care of running pods in a scalable way, using multiple instances
  - **Pod**: actual instance of the app that typically runs one container
  - **Service**: a load balancer that exposes access to the app
  - **Route**: resource that allows incoming traffic by exposing FQDN
- If you go for k8s way `$ oc create deployment` but it does not include service or route
- To run app in OpenShift, different k8s resources are used, each resource is defined in the API to offer specific function, the API defines how resources connect to each other
- Many resources are used to define how a component in the cluster is running:
  - Pods define how containers are started using images
  - Services implement a load balancer to distribute incoming workload
  - Routes define an FQDN for accessing the app
- Resources are defined in the API

## 3.3 Monitoring Applications
- Pod is the representation of the running processes
  - `$ oc logs podnam` → see STDOUT
  - `$ oc describe` → see how the Pods are created in the cluster
  - `$ oc get pod <podname> -o yaml` → see all status information
  - `$ oc get pods —show-labels`
  - `$ oc get all —selector=<label>`

## 3.4 Exploring API Information
- OpenShift is based on k8s APIs. OpenShift-specific APIs are added on top of the k8s APIs
- OpenShift resources are not always guaranteed to be compatible with Kubernetes resources
- Exploring APIs: (based on this information, OpenShift resources can be defined in a declarative way in YAML files)
  - `$ oc api-resources` → shows resources as defined in the API
  - `$ oc api-versions` → show versions of APIs
  - `$ oc explain [—recursive]` → use to explore what is in the APIs. `$ oc explain pod.spec.containers`

---

## **4-Managing OpenShift Storage**

### 4.1 Understanding OpenShift Storage
- Container storage by default is ephemeral. Upon deletion of a container, all files and data inside it are also deleted
- Containers can use volumes or bind mounts to provide persistent storage
- Bind mounts are useful in stand-alone containers; volumes are needed to decouple the storage from the container
- OpenShift uses persistent volumes to provision storage
- Storage can be provisioned in a static or dynamic way
  - Static provisioning means that the cluster admin creates the persistent volumes manually
  - Dynamic provisioning uses storage classes to create persistent volumes on demand. OpenShift provides storage classes as the default solution
- Developers use persistent volume claim (PVC) to dynamically add storage to the app

### 4.2 Using Pod Volumes

### 4.3 Decoupling Storage with Persistent Volumes
- PVs provide storage in a decoupled way
- Admins create PV of a type that matches the site-specific storage solution
- Alternatively, StorageClass can be used to automatically provision persistent volumes
- PVs are available for the entire cluster and not bound to a specific project
- Once a PV is bound to a PVC, it cannot service any other claims
- Developers define a PVC to add access to a PV to their app
- PVC does not bind to a specific PV, but uses any PV that matches the claim requirements
- If no matching PV is found, PVC will wait until it becomes available
- When a matching PV is found, PV binds to PVC. Once a PV is bound, it cannot bind to another PVC

### 4.4 Using StorageClass
- PVs are used to statically allocate storage
- StorageClass allows containers to use the default storage that is provided in a cluster
- From the developer perspective it doesn’t make a difference, as developer only uses PVC to connect to the available StorageClass
- Set a default StorageClass to allow developers to bind to the default storage class automatically, without specifying anything specific in the PVC
- If no default StorageClass is set, the PVC needs to specify the name of the StorageClass it wants to bind to
- `$ oc annotate storageclass standard —overwrite "[storageclass.kubernetes.io/is-default-class=true](http://storageclass.kubernetes.io/is-default-class=true)"` To set a StorageClass as default
- In order to create PVs on demand, the storage class needs a provisioner, the following provisioners are provided:
  - AWS EBC
  - Azure File
  - Azure Disk
  - Cinder
  - GCE Persistent Disk
  - VMware vSphere
- If you create a storage class for a volume plug-in that does not have a corresponding provisioner, use storage class provisioner value of [kubernetes.io/no-provisioner](http://kubernetes.io/no-provisioner)

### 4.5 Using ConfigMap
- ConfigMaps are used to decouple information. Different types of information can be stored in ConfigMaps:
  - Command line parameters
  - Variables
  - ConfigFiles
- Start by defining the ConfigMap and create it: (Consider different sources that can be used for ConfigMaps)
  - `$ kubectl create cm myconf —from-file=my.conf` → put contents of a configuration file in the ConfigMap
  - `$ kubectl create cm variables —from-env-file=variables` → define variables
  - `$ kubectl create cm special —from-literal=VAR3=cow —from-literal=VAR4=goat` → define variables or command line arguments
  - Verify creation using `$ kubectl describe cm <cmname>`

### 4.6 Using the Local Storage Operator
- Operators can be used to configure additional resources based on custom resource definition
- Different storage types in OpenShift are provided as operators
- The local storage operator creates a new LocalVolume resource, but also sets up RBAC to allow integration of this resource in the cluster
- The operator itself can be implemented as ready-to-run code, which makes setting it up much easier

#### Demo: Installing the operator
- `$ crc console` → log in as kubeadmin user
- Select Operators > OperatorHub; check the Storage category
- Select LocalStorage, click Install to install it
- Explore its properties in Operators > Installed Operators

#### Demo: Using the LocalStorage Operator
- Explore operator resources: `$ oc get all -n openshift-local-storage`
- Create a block device on the CoreOS CRC machine:
  - `$ ssh -i ~/.crc/machines/crc/id_rsa core@$(crc ip)`
  - `$ sudo -i`
  - `$ cd /mnt; dd if=/dev/zero of=loopbackfile bs=1M count=1000`
  - `$ losetup -fP loopbackfile`
  - `$ ls -l /dev/loop0; exit`
- `$ oc create -f localstorage.yml`
- `$ oc get all -n openshift-local-storage`
- `$ oc get sc` → will show StorageClass in a waiting state

---

## **Module 3:** Managing OpenShift Authentication and Access

# 5-Configuring Authentication

## 5.1 Authenticating as a Cluster Administrator

- A user is an OpenShift object who can be granted permissions in the system by adding roles to the user or usergroup, using rolebinding
- OpenShift has 3 types of users:
  - System users are automatically created to allow parts of OpenShift to securely interact with the API
  - Service accounts are special system users that are associated with projects to give additional privileges to Pods and deployments
  - Regular users represent people who can perform specific tasks in OpenShift (kubeadmin + admin, are created by default)

- After installing OpenShift, there are two ways to authenticate API requests with administrator privileges:
  - kubeadmin virtual user and password that grants an OAuth access token
    - This virtual user is a hard-coded cluster admin user
    - Privileges of this user cannot be changed
    - Password is dynamically generated and hard-coded
    - Installation logs show how to log in as this user
    - After setting up an identity provider and creating a new user which has been assigned the cluster-admin role, this hard coded user can be removed. **Attention: don’t do this before verifying the new account works [A MUST DONE ACTION]**
    - `$ oc delete secret kubeadmin -n kube-system`
    - After setting up CRC, the login commands that use an auto-generated password are printed on screen:
      - `$ eval $(crc oc-env)` —> setup shell
      - `$ oc login -u kubeadmin -p xxxxxxx [https://api.crc.testing:6443](https://api.crc.testing:6443)` —> to authenticate
    - kubeconfig file that embeds an X.509 client certificate that doesn’t expire
      - A bit harder than kubeadmin user
      - On CRC You’ll find it in `~/.crc/machines/crc`
      - On real cluster You’ll find it in `~/auth/kubeconfig`
      - To use it: `$ export KUBECONFIG=/home/student/.crc/machines/crc/kubeconfig`
      - Alternatively use this command to specify the config on the command line:
        - `$ oc —config ~/.crc/machines/crc/kubeconfig get nodes`

## 5.2 Understanding Identity Providers

- When accessing OpenShift Cluster resources, a user makes a request to the API. The authentication layer is responsible for authentication of the user, and next the authorization layer uses RBAC policy to determine what the user is authorized to do. If API requests contain invalid authentication, it is authenticated as a request by the anonymous system user
- OAuth Access Tokens use access tokens to authenticate a request
- X.509 Client Certificate uses TLS certificate to authenticate requests
- The OpenShift Authentication Operator runs an OAuth server
- This server provides access tokens to users that authenticate to the API
- The OAuth server works with an identity provider to validate the identity of the requester
- This server connects the user with the identity and creates the OAuth access token which is next granted to the user

### Identity providers:
- HTPassword: validates username and password against a Kubernetes secret that stores credentials generated by the `$ htpasswd` command
- keystone: uses the OpenStack Keystone server for authentication
- LDAP: uses an LDAP identity provider to verify authentication
- GitHub
- OpenID connect: integrates with OpenID connect

## 5.3 Configuring the HTPasswd Identity Provider

- Must be installed: `$ yum install httpd-tools`
- HTPasswd identity provider uses a Kubernetes secret that contains usernames and passwords generated with the Apache htpasswd command
- Using this identity provider is recommended for small proof of concept environments
- In large environments, integration with the organization identity management system is recommended
- To use HTPasswd identity provider, the OAuth Custom Resource must be configured
- This resource exists by default as kind: OAuth, and it should contain `spec.identityProviders.htpasswd` in the list of identity providers
- `spec.identityProviders.htpasswd.fileData.name` field refers to the secret that needs to exist and contains the htpasswd generated password
- **TIP**: use `$ oc explian oauth.spec` for information on how to set it up
- To configure OAuth HTPasswd Identity Provider, the OAuth custom resource must be updated:
  - `$ oc get oauth cluster -o yaml > oauth.yaml`
  - After applying the required changes, the new custom resource can be applied:
    - `$ oc replace -f oauth.yaml`
  - It is best practice to define all users at first, because for editing it, there are lots of steps to take

## 5.4 Creating and Deleting Users

- Creating users is a 2-step procedure, after the OAuth identity provider has been configured:
  - Use `$ htpasswd`, to update the contents of the htpasswd file
  - Create a secret that contains the contents of that htpasswd file
  - Tell the OAuth provider to use that secret’s content

- To add users, the contents of the secret must be extracted to a temporary htpasswd file (or newly generated)
  - Next the `$ htpasswd` command is used to update that file’s contents and the secret is newly generated

### DEMO
```bash
$ htpasswd -c -B -b /tmp/htpasswd admin password
$ htpasswd -b /tmp/htpasswd anna password
$ htpasswd -b /tmp/htpasswd linda password
$ cat /tmp/htpasswd
$ oc create secret generic htpasswd-secret --from-file htpasswd=/tmp/htpasswd -n openshift-config --> -n openshift-config is for namespace
$ oc describe secret htpasswd-secret -n openshift-config
$ oc adm policy add-cluster-role-to-user cluster-admin anna --> assigning RBAC (cluster-admin role)
$ oc get oauth -o yaml > oauth.yaml
```

...

## 6-Managing Access Control

### 6.1 Managing Permissions with RBAC

- The purpose of RBAC is to connect users to specific roles.
- Roles have either a project or a cluster scope.
- Different types of users are available:
  - Users are created as a specific user type and are granted access to cluster resources using role bindings.
  - A role is an API resource that gives specific users access to OpenShift resources, based on verbs.

### Verbs are used as permissions:
- get
- list
- watch
- create
- update
- patch
- delete

### Cluster roles are created when OpenShift is installed.
- Local Roles provide access to project-based resources.
- Use `$ oc describe clusterrole.rbac`, for an overview of currently existing cluster roles.
- A Role Binding is used to connect a cluster role to a user or group.
- Use `$ oc describe clusterrolebinding.rbac`, for an overview of bindings between users/groups and roles.
- Use `$ oc describe rolebinding.rbac` to see all roles with a non-cluster scope.
- Use `$ oc describe rolebinding.rbac -n myproject` to see all local roles assigned to a specific project.

### Some default roles are provided to be applied locally or the entire cluster:
- admin: gives full control to all project resources
- basic-user: gives read access to projects
- cluster-admin: allows a user to perform any action in the cluster
- cluster-status: allows a user to request status information
- edit: allows creating and modifying common application resources, but gives no access to permissions, quotas, or limit ranges
- self-provisioner: allows users to create new projects (by default all users have this)
- view: allows users to view but not modify project resources
