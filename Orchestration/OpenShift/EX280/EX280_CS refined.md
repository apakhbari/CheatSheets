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

# 6.1 Managing Permissions with RBAC

- the purpose of RBAC is to connect users to specific roles
- Roles have either a project or a cluster scope
- Different types of users are available
- Users are created as a specific user type, and are granted access to cluster resources using role bindings
- A role is an API resource that gives specific users access to OpenShift resources, based on verbs
- verbs are used as permissions, and include : get - list - watch - create - update - patch - delete
- cluster roles are created when OpenShift is installed
- Local Roles provide access to project-based resources
- use `$ oc describe clusterrole.rbac`, for an overview of currently existing cluster roles
- a Role Binding is used to connect a cluster role to a user or group
- use `$ oc describe clusterrolebinding.rbac`, for an overview of bindings between users/groups and roles
- `$ oc describe rolebinding.rbac` —> see all roles with a non-cluster scope
- `$ oc describe rolebinding.rbac -n myproject` —> see all local roles assigned to a specific project
- some default roles are provided to be applied locally or the entire cluster

    - admin: gives full control to all project resources
    - basic-user: gives read access to projects
    - cluster-admin: allows a user to perform any action in the cluster
    - cluster-status: allows a user to request status information
    - edit: allows creating and modifying common application resources, but gives no access to permissions, quotas, or limit ranges
    - self-provisioner: allows users to create new projects (by default all users have this)
    - vies: allows users to view but not modify project resources

- the admin role gives users full project permissions
- the edit role corresponds to the typical developer user
- regular users represents a user object that is granted access to the cluster platform
- system users are created automatically to allow system components to access specific resources

    - system:admin has full admin access
    - system:openshift-registry is used for registry access
    - system:node:[server1.example.com](http://server1.example.com) is used for node access

- Service accounts are special system accounts used to give extra privileges to pods or deployments

    - deployer: is used to create deployments
    - builder: is used to create build configs in S2I

- Cluster admin can use `$ oc adm policy`, to manage cluster and namespace roles

    - `$ oc adm policy add-cluster-role-to-user rolename username`
    - `$ oc adm policy remove-cluster-role-to-user rolename username`

- to figure out who can do what, use `$ oc adm policy who-can delete user`
- DEMO

    - `$ oc get clusterrolebinding -o wide | grep ‘self-provisioner’`
    - `$ oc describe clusterrolebindings self-provisioners`
    - `$ oc adm policy remove-cluster-role-from-group self-provisioner system:authenticated:oauth —> remove cluster role binding`
    - `$ oc login -u linda -p password —> we see that linda cannot create projects anymore`
    - `$ oc adm policy add-cluster-role-to-user admin linda`
    - `$ oc adm groups new dev-group`
    - `$ oc adm groups add-users dev-group anouk`
    - `$ oc adm groups new qa-group`
    - `$ oc adm groups add-users qa-group lisa`
    - `$ oc get groups`
    - `$ oc policy add-role-to-group edit dev-group`
    - `$ oc policy add-role-to-group view qa-group`
    - `$ oc get rolebindings -o wide`
    - `$ oc adm policy add-cluster-role-to-group —rolebinding-name self-provisioners self-provisioner system:authenticated:oauth —> reverting removing cluster role binding`

# 6.2 Creating Roles

- New roles can be created by assigning verbs and resources to the newly created role

    - `$ oc create role podview —verb=get —resource=pod -n userstuff` —> namespace userstuff
    - `$ oc adm policy add-role-to-user podview ahmed —role-namespace=userstuff -n userstuff` —> user ahmed can view pods in userstuff namespace

    - `$ oc create clusterrole podviewonly —verb=get —resource=pod` —> scope is whole cluster
    - `$ oc adm policy add-cluster-role-to-user podviewonly lori`

# 6.3 Using Secrets to Manage Sensitive Information

- a secret is a base64 encoded ConfigMap
- To really protect data in a secret, the Etcd can be encrypted
- secrets are commonly used to decouple configuration and data from the apps running in OpenShift
- Using secrets allows OpenShift to load site-specific data from external sources
- secrets can be used to store different kinds of data

    - passwords
    - sensitive configuration files
    - Credentials such as SSH keys or OAuth tokens

- Different types of secrets exist:

    - docker-registry
    - generic
    - tls

- when information is stored in a secret, OpenShift validates that the data conforms to the type of secret
- In OpenShift, secrets are mainly used for two reasons

    - store credentials which is used by Pods in a MicroService architecture
    - store TLS certificates and keys. A TLS secret stores the certificate as tls.crt and the certificate key as tls.key

- Developers can mount the secret as a volume and create a pass-through route to the app
- Creating secrets:

    - generic secrets: `$ oc create secret generic secretvars —from-literal user=root —from-literal password=verysecret`
    - generic secrets, containing SSH keys: `$ oc create secert generic ssh-keys —from-file id_rsa=~/.ssh/id_rsa —from-file id_rsa.pub=~/.ssh/id_rsa.pub`
    - secrets containing TLS certificate and key: `$ oc create secret tls secret-tls —cert certs/tls.crt keys/tls.keys`

- secrets can be referred to as variables, or as files from the pod
- use `$ oc set env`, to write the environment variables obtained from a secret to a pod or deployment

    - `$ oc set env deployment/mysql —from secret/mysql —prefix MYSQL_` —> prefix let defining and using variable in configuration. for example make ROOT_PASSWORD to MYSQL_ROOT_PASSWORD. so you can have a file and dynamically create different variations for different pods

- use `$ oc set volume`, to mount secrets as volumes
- Notice that when using `$ oc set volume`, all files currently in the target directory are no longer accessible

    - `$ oc set volume deployment/mysql —add —type secret —mount-path /run/secrets/mysql —secret-name mysql`

- DEMO

    - `$ oc create secret generic mysql —from-literal user=sqluser —from-literal password=password —from-literal database=secretdb —from-literal hostname=mysql —from-literal root_password=password`
    - `$ oc new-app —name mysql —docker-image bitnami/mysql`
    - `$ oc set env deployment/mysql —from secret/mysql —prefix MYSQL_`
    - `$ oc get pods -w`
    - `$ oc exec -it <podname> — enc —> print all environmental values`

# 6.4 Creating ServiceAccounts

- A ServiceAccount (SA) is a user account that is used by a pod to determine Pod access privileges to system resources
- The default SA used by Pods allows for very limited access to cluster resources
- Sometimes a Pod cannot run with this very restricted SA
- After creating SA, specific access privileges need to be set
- `$ oc create serviceaccount <name of SA>` —> create a SA, optionally add `-n <namespace>`
- After creating SA, use a role binding to connect the SA to a specific role
- Or associate the SA with a specific Security Context Constraint

# 6.5 Managing Security Context Constraints

- A security Context Constraint (SCC) is an OpenShift resource, similar to the Kubernetes Security Context resource, that restrict access to resources
- The purpose is to limit access from a Pod to the host environment
- Different SCCs are available to control:
    - Running privileged Containers
    - Requesting additional capabilities to a container
    - Using host directories as volumes
    - Changing SELinux context of a container
    - Changing the user ID

- Using SCCs may be necessary to run community containers that by default don’t work under the tight OpenShift security restrictions
- `$ oc get scc` —> an overview of SCCs
- `$ oc describe scc <name>`, for example `$ oc describe scc nonroot` —> more details
- `$ oc describe pod <podname> | grep scc` —> see which SCC is currently used by a Pod
- `$ oc get pod <name> -o yaml | oc adm policy scc-subject-review -f -` —> if a pod can’t run due to an SCC
- To change a container to run with a different SCC, you must create a service account and use that in the Pod
- `$ oc describe pod`, shows a line `[openshift.io/scc:](http://openshift.io/scc:) restricted; most Pods run as restricted`
- Some Pods require access beyond the scope of their own containers, such as S2I pods, To provide this access, SAs are needed
- To change the container to run using a different SCC, you need to create a service account and use that with the Pod or Deployment
- The service account is used to connect to an SCC
- Once the service account is connected to the SCC it can be bound to a deployment or pod to make sure that it is working
- This allows you for instance to run a Pod that requires root access to use the anyuid SCC so that it can run anyway
- DEMO

    - As linda : `$ oc new-project sccs`
    - `$ oc new-app —name sccnginx —docker-image nginx`
    - `$ oc get pods` —> show an error
    - `oc logs pod/nginx[tab]` —> fails because of a permission problem
    - as admin: `$ oc get pod nginx[tab] -o yaml | oc adm policy scc-subject-review -f -` —> show which scc to use
    - as admin: `$ oc create sa nginx-sa` —> creates the dedicated service account
    - as admin: `$ oc adm policy add-scc-to-user anyuid -z ngix-sa`
    - as linda: `$ oc set serviceaccount deployment sccnginx nginx-sa`
    - `$ oc get pods sccs[tab] -o yaml` —> look for serviceAccount and serviceAccountName then change the default to nginx-sa
    - `$ oc get pods` —> pod is running now

# 6.6 Running Containers as Non-root

- by default, OpenShift denies containers to run as root
- many community containers run as root by default
- A container that runs as root has root privileges on the container host as well, and should be avoided
- If you build your own container images, specify which user it should run
- Frequently, non-root alternatives are available for the images you’re using
    - [quay.io](http://quay.io) images are made with OpenShift in mind
    - bitnami has reworked common images to be started as non-root

- Non-root containers cannot bind to a privileged port
- In OpenShift, this is not an issue, as containers are accessed through services and routes
- Configure the port on the service/route, not on the pod
- Also non-root containers have limitations accessing files
- DEMO

    - `$ oc new-app —docker-image=bitnami/nginx:latest —name=bginx`
    - `$ oc get pods -o wide`
    - `$ oc describe pods bginx-<xxx>`
    - `$ oc get services`

---

# Module 4: Performing Operational Cluster Management Tasks
# 7-Managing OpenShift Networking

## 7.1 Understanding OpenShift Networking Resources

- Services provide load balancing to replicated Pods in an app, and are essential in providing access to apps
- Services connect to Endpoints, which are Pod individual IP addresses
- Ingress is a k8s resource that exposes services to external users
- Ingress adds URLs, load balancing, as well as access rules
- Ingress is not used as such in OpenShift
- OpenShift routes are an alternative to Ingress

## 7.2 Understanding OpenShift SDN

- OpenShift uses Software Defined Networking (SDN) to implement connectivity
- OpenShift SDN separates the network in a control plane and a data plane
- SDN solves 5 requirements:
  - Manage network traffic and resources as software such that they can be programmed by the app owner
  - Communicate between containers running within the same project
  - Communicate between Pods within and beyond project boundaries
  - Manage network communication from a Pod to a service
  - Manage network communication from external network to service
- The network is managed by the OpenShift Cluster network Operator
- The DNS operator implements the CoreDNS DNS server
- The internal CoreDNS server is used by Pods for DNS resolution
- `$ oc describe dns.operator/default` —> see DNS config
- The DNS operator has different roles:
  - Create default cluster DNS name cluster.local
  - Assign DNS names to namespaces
  - Assign DNS names to services
  - Assign DNS names to Pods
- DNS names are composed as servicename.projectname.cluster-dns-name
  - Example: db.myproject.cluster.local
- Apart from the A resource records, core DNS also implements an SRV record, in which port name and protocol are prepended to the service A record name
  - Example: `_443._tcp.webserver.myproject.cluster.local`
- If a service has no IP address, DNS records are created for the IP addresses of the Pods, and round-robin is applied
- The OpenShift Cluster Network Operator defines how the network is shaped and provides information about the following:
  - Network address
  - Network mode
  - Network provider
  - IP address pools
- `$ oc get network/cluster -o yaml` —> see details
- Notice that currently OpenShift only supports the OpenShift SDN network provider, this may change in future. Future versions will use OVN-Kubernetes to manage the cluster network
- Network policy allows defining Ingress (incoming traffic) and Egress (outgoing traffic) filtering
  - If no network policy exists, (which is by default) all traffic is allowed
  - If a network policy exists, it will block all traffic with the exception of allowed Ingress and Egress traffic

## 7.3 Managing Services

- A service is used as a load balancer that provides access to a group of Pods that is addressed by using a label as the selector
- Services are needed for Pod access, as Pods are dynamically added as well as removed
- Services are using labels and selectors to dynamically address Pods
- When using `$ oc new-app`, a service resource is automatically added to expose access to the app
- Service Types:
  - **ClusterIP**: the service is exposed as an IP address internal to the cluster. This is used as the default type, where services cannot be directly addressed
  - **NodePort**: exposes a port on the node IP address
  - **LoadBalancer**: exposes the service through a cloud provider load balancer. The cloud provider LB talks to the OpenShift network controller to automatically create a node port to route incoming requests
  - **ExternalName**: creates a CNAME in DNS to match an external host name. Use this to create different access points for apps external to the cluster (used in migration scenarios)

## 7.4 Managing Routes

- Ingress traffic is generic terminology for incoming traffic (is more than just k8s Ingress)
- Ingress resource is managed by the Ingress operator and accepts external requests that will be proxied
- Route resource is an OpenShift resource that provides more features than Ingress:
  - TLS re-encryption
  - TLS passthrough
  - Split traffic for blue-green deployment
- OpenShift route resources are implemented by the shared router service that runs as a Pod in the cluster
- Router Pods bind to public-facing IP addresses on the nodes
- DNS wildcard is required for this to work
- Routes can be implemented as secure and as insecure routes
- Route resources need the following values:
  - Name of the service that the route accesses
  - A host name for the route that is related to the cluster DNS wildcard domain
  - An optional path for path-based routes
  - A target port, which is where the application listens
  - An encryption strategy
  - Optional labels that can be used as selectors
- Notice that the route does not use the service directly, it just needs it to find out to which Pods it should connect
- Secure routes can use different types of TLS termination:
  - **Edge**: certificates are terminated at the route, so TLS certificate must be configured in the route
  - **Pass-through**: termination is happening at the Pods, which means that the Pods are responsible for serving the certificates. Use this to support mutual authentication
  - **Re-encryption**: TLS traffic is terminated at the route, and new encrypted traffic is established with the Pods
- Unsecure routes require no key or certificate. It is easy, just use `$ oc expose service my.service --hostname my.name.example.com`
  - The service `my.service` is exposed
  - The hostname `my.name.example.com` is set for the route
- If no name is specified, the name `routename.projectname.defaultdomain` is used
- Notice that only the OpenShift route, and not the CoreDNS DNS server knows about route names
- DNS has a wildcard domain name that sends traffic to the IP address that runs at the router software, which will further take care of the specific name resolving. Therefore, the route name must always be a subdomain of the cluster wildcard domain

## 7.5 Understanding DNS Name Resolving

- Services are the first level of exposing applications
- To make services accessible, routes provide DNS names
- OpenShift has an internal DNS server, which is reachable from the cluster only
- To make OpenShift services accessible by name on the outside, Wildcard DNS is needed on the external DNS
- Wildcard DNS resolves to all resources created within a domain
- External DNS has wildcard DNS to the OpenShift loadbalancer
- The OpenShift loadbalancer provides a front end to the control nodes
- The control nodes run the Ingress controller and are a part of the cluster
- So they have access to the internal resource records

## 7.6 Creating Self-signed Certificates

- PKI certificates are everywhere in OpenShift
- To secure resources - like routes - it’s essential to understand how certificates are working
- To use public keys, they need to be signed by a Certificate Authority
- Self-signed certificates are an easy way to get started with your own certificates
- Next, these certificates can be used in OpenShift resources like routes
- **DEMO:**
  - **Creating the CA (it’s not a running service, it’s a signing entity):**
    - `$ mkdir ~/openssl`
    - `$ openssl genrsa -des3 -out myCA.key 2048` —> creating private key, needs password
    - `$ openssl req -x509 -new -nodes -key myCA.key -sha256 -days 3650 -out myCA.pem`

- **Creating the certificate:**
  - `$ openssl genrsa -out tls.key 2048`
  - `$ openssl req -new -key tls.key -out tls.csr` —> make sure the CN matches the DNS name of route which is `project.apps-crc.testing`
  
- **Self-signing the certificate:**
  - `$ openssl x509 -req -in tls.csr -CA myCA.pem -CAkey myCA.key -CAcreatserial -out tls.crt -days 1650 -sha256`

## 7.7 Securing Edge and Re-encrypt Routes Using TLS Certificates

- Edge routes hold TLS key material so that TLS termination can occur at the router
- Connections between router and application are not encrypted, so no TLS configuration is needed at the application
- Re-encryption routes offer a variation on edge termination
  - The router terminates TLS with a certificate, and re-encrypts its connections to the endpoint (typically with a different certificate)
- **DEMO: configuring an Edge route**
  - **Part 1: creating deploy, svc, route**
    - `$ oc new-project myproject`
    - `$ oc create cm linginx1 --from-file linginx.conf`
    - As admin: `$ oc create sa linginx-sa` —> creates dedicated service account
    - As admin: `$ oc adm policy add-scc-to-user anyuid -z linginx-sa`
    - `$ oc create -f linginx-v1.yaml`
    - `$ oc get pods`
    - `$ oc get svc`
    - `$ oc create route edge linginx1 --service linginx1 --cert=/openssl/tls.crt --key=/openssl/tls.key --ca-cert=/openssl/myCA.pem --hostname=linginx-myproject.apps-crc.testing` —> name of route must be equal to name of certificate
    - `$ oc get routes`
  
  - **Part 2: Testing from another pod in the cluster**
    - `$ curl -svv https://linginx-myproject.apps-crc.testing` —> certificate check, show a self-signed certificate error
    - `$ curl -s -k https://linginx-myproject.apps-crc.testing` —> give access

## 7.8 Securing Passthrough Routes Using TLS Certificates
- A passthrough route configures the route to pass forward the certificate to guarantee client-route-application end-to-end encryption
- To make this happen, a secret providing the certificate as well as the certificate key is created and mounted in the application
- The passthrough route type doesn’t hold any key materials, but transparently presents the key materials that are available in the app - the router doesn’t provide TLS termination
- Passthrough is the only method that supports mutual authentication between application and client
- **DEMO**: Configuring a Passthrough Route

### Part 1: creating certificate: ensure that subject name matches name used in the route

- `$ mkdir openssl; cd openssl`
- `$ openssl genrsa -des3 -out myCA.key 2048`
- `$ openssl req -x509 -new -nodes -key myCA.key -sha256 -days 3650 -out myCA.pem`
- `$ openssl genrsa -out tls.key 2048`
- `$ openssl req -new -key tls.key -out tls.csr` → CN = linginx-myproject.apps-crc.testing
- `$ openssl x509 -req -in tls.scr -CA myCA.pem -CAkey myCA.key -CAcreateserial -out tls.crt -days 1650 -sha256`

### Part 2: creating secret

- `$ oc create secret tls linginx-certs --cert tls.crt --key tls.key`
- `$ oc get secret linginx-certs -o yaml`

### Part 3: create a configmap

- `$ oc create cm nginxconfigmap --from-file default.conf`
- `$ oc create sa linginx-sa` → creates the dedicated service account
- `$ oc adm policy add-sc-to-user anyuid -z linginx-sa`

### Part 4: starting deployment and service

- `$ vim linginx-v2.yaml`
- `$ oc create -f linginx-v2.yaml`

### Part 5: creating the passthrough route

- `$ oc create route passthrough linginx --service linginx2 --port 8443 --hostname=linginx-myproject.apps-crc.testing`
- `$ oc get routes`
- `$ oc get svc`

### Part 6: testing in a debug Pod

- `$ oc debug -t deployment/linginx2 --image [registry.access.redhat.com/ubi8/ubi:8.0](http://registry.access.redhat.com/ubi8/ubi:8.0)`
- `$ curl -s -k [https://172.25.201.41:8443](https://172.25.201.41:8443) (service IP address)` → only works from the same network
- `$ curl https://linginx-myproject.apps-crc.testing`
- `$ curl --insecure https://linginx-myproject.apps-crc.testing`

### 7.9 Configuring Network Policies

- By default, there are no restrictions to network traffic in k8s
- Pods can always communicate, even if they’re on different namespaces
- To limit this, Network policies can be used
- If in a policy there is no match, traffic will be denied
- If no Network Policy is used, all traffic is allowed
- In network policies, three different identifiers can be used:
  - **Pods**: (podSelector) note that a Pod cannot block access to itself
  - **Namespaces**: (namespaceSelector) to grant access to specific namespaces
  - **IP blocks**: (ipBlock) notice that traffic to and from the node where a Pod is running is always allowed
- When defining a Pod - or namespace - based network policy, a selector label is used to specify what traffic is allowed to and from the Pods that match the selector
- Network policies do not conflict, they are additive
- If cluster monitoring or exposed routes are used, Ingress from them needs to be included in the network policy
- Use `spec.ingress.from.namespaceSelector.matchlabels` to define
  - `[network.openshift.io/policy-group:](http://network.openshift.io/policy-group:) monitoring`
  - `[network.openshift.io/policy-group:](http://network.openshift.io/policy-group:) ingress`

### DEMO: configuring network policy

- `$ oc login -u admin -p password`
- `$ oc apply -f nwpolicy-complete-example.yaml`
- `$ oc expose pod nginx --port=80`
- `$ oc exec -it busybox -- wget --spider --timeout=1 nginx` → will fail
- `$ oc label pod busybox access=true`
- `$ oc exec -it busybox -- wget --spider --timeout=1 nginx` → will work

### DEMO: Advanced Network policy

- `$ oc login -u kubeadmin -p xxx`
- `$ oc new-project source-project`
- `$ oc label ns source-project type=incoming`
- `$ oc create -f nginx-source1.yml`
- `$ oc create -f nginx-source2.yml`
- `$ oc login -u linda -p password`
- `$ oc new-project target-project`
- `$ oc new-app --name nginx-target --docker-image [quay.io/openshiftteset/hello-openshift:openshift](http://quay.io/openshiftteset/hello-openshift:openshift)`
- `$ oc get pods -o wide`
- `$ oc login -u kubeadmin -p xxx`
- `$ oc exec -it nginx-access -n source-project -- curl <ip of nginx target pod>:8080` → works
- `$ oc exec -it nginx-noaccess -n source-project -- curl <ip of nginx target pod>:8080` → works
- `$ oc get pods -n source-project --show-labels`
- `$ oc create -f nwpol-allow-specific.yaml`
- `$ oc exec -it nginx-noaccess -n source-project -- curl <ip of nginx target pod>:8080` → works
- `$ oc label pod nginx-target-1-<xxxxxx> type=incoming`
- `$ oc exec -it nginx-noaccess -n source-project -- curl <ip of nginx target pod>:8080` → not works

### 7.10 Troubleshooting OpenShift Networking

- Use `$ oc debug deployment/<container name>`
- When troubleshooting it’s useful to get an exact copy of a running Pod and troubleshoot from there
- Since a Pod that is failing may not be started, and for that reason is not accessible to rsh and exec, the debug command provides an alternative. The debug Pod will start a shell inside of the first container of the referenced Pod. The started Pod is a copy of the source Pod, with labels stripped, no probes, and the command changed to `/bin/sh`
- Useful command arguments can be `--as-root` or `--as-user=10000` to run as root or as a specific user
- Use `exit` to close and destroy the debug Pod

---

**8-Managing Pod Scaling and Scheduling**
