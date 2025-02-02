# Red Hat EX180

**Red Hat Certified Specialist in Containers and Kubernetes** (Podman - OpenShift)

RedHat Certified specialist in containers and Kubernetes: Red Hat EX180

---

## Module 1: Container Fundamentals

1. Introduction to containers and Kubernetes
2. Running Containers
3. Managing Container Images
4. Managing containers
5. Creating Custom images

## Module 2: OpenShift Fundamentals

6. Running OpenShift
7. Running Applications in OpenShift

## Module 3: Using OpenShift to automate complex application builds

8. Running MicroServices in OpenShift
9. Using Source-to-image
10. Troubleshooting OpenShift

## Module 4: The Red Hat Certified Specialist in Containers and Kubernetes exam (EX180) Sample Exam

11. EX180 Sample Exam

---

## PODMAN Commands

### Managing images:

- `$ Podman search` —> to find a container image
- `$ Podman search —no-trunc` —> to find a container image with description before pulling
- `$ Skopeo inspect [docker://registry.redhat](docker://registry.redhat).io/rhosp15-rhel8/openstack-mariadb` —> get information about available versions before pulling
- `$ podman login` —> using a non-root shell
- `$ Podman pull` —> download before using
- `$ podman images` —> see what images are available
- `$ podman run` —> run a container
- `$ podman run -d` —> run a container in a detached mode (background)
- `$ podman run -it ubi8/ubi /bin/bash` —> run container with interactive terminal (bash shell)
- `$ Podman exes -it new` —> run command in a container that’s running
- `$ Podman rmi` —> remove images
- `$ podman rmi -a` —> remove all images
- `$ Podman tag nginx mynginx:db` —> apply tag to an image

### Modifying images:

- `$ Podman commit` —> commit keeps logs and more runtime information in the captured images. Requires you to work with complete images, whereas Dockerfile is just a description of the work to be done to create the images. The image format can be specified as an option: docker is the old image format, oci is the default image format.
- `$ Podman diff` —> get a list of differences between the running container and the original image.

### Showing status of images:

- `$ podman ps` —> show status of a running containers
- `$ podman ps -a` —> show status of all containers

### Log & Analyze images:

- `$ podman logs <containerName>` —> analyze if a container needs additional information while starting.
- `$ Podman image inspect <containerName | containerID>` —> All of information about the image that’s on computer. After pulling, on disk.
- `$ podman inspect <containerName> | less` —> -l for last container that executed -f for filter
- `$ podman inspect -l -f "{{.NetworkSettings.IPAddress}}"` —> -l for last container that executed -f for filter

### Saving and Loading Images:

- `$ Podman save [quay.io/bitnami/nginx:latest](http://quay.io/bitnami/nginx:latest) -o mysql.tar <ImageID>` —> fetch and save image to a .tar file, or for backup
- `$ Podman load -I mysql.tar` —> load a container image from a tar file

### Flags:

- `-l` —> last executed container
- `-e key=value` —> flag for setting environmental variables
- `—nam=myName` —> set the name of container for easier access

### Container Status information:

- `$ Podman run [myimage]` —> starts a container with its default entry point
- `$ Podman run -it [myimage] sh` —> runs a non-default entry point
- `$ Exit` —> closes the current application and may shutdown the container
- `Ctrl-p, ctrl-q` —> detaches from the current application
- `$ Podman run -d [myimage]` —> runs an image in detached mode
- `$ Podman ps` —> show information about currently running containers
- `$ Podman ps -a` —> shows information about all containers that have been started
- `$ Podman inspect [mycontainer]` —> shows current properties of running containers. Detailed information, for example for seeing info about container’s IP address
- `$ Podman image inspect [myImage]` —> shows properties about images on the local system
- `$ Podman logs` —> connects to the entry point application STDOUT

### Container Management Tasks:

- `$ Podman stop` —> stop a container gracefully
- `$ Podman stop -a` —> stop all containers
- `$ Podman restart` —> start a previously stopped container using container data that is already locally available, or restart the container if it is currently running
- `$ Podman start` —> start a container that is currently stopped
- `$ Podman kill` —> send UNIX signals to manipulate container state. By default SIGKILL, use -s to specify other signal numbers
- `$ Podman rm` —> deletes a container, also delete its current state from the system

### Executing Commands in Containers:

- `$ podman exec [mycontainer] bash` —> run any additional command in an already running container
- `$ podman run [mycontainer] bash` —> replace entry point command with the command that is provided
- `$ podman run [mycontainer] —entrypoint=bash` —> if upper not works

---

# OpenShift Commands

## Deploy Apps

- `$ oc new-project` —> create new project
- `$ oc projects` , for developer or `$ oc get ns` , as administrator to get an overview of all projects
- `$ oc new-app` —> primary tool for running apps, can build images from different sources
- `$ oc new-app —as-deployment-config` —> run apps specifically as a deployment config
- `$ oc create deployment` —> can be used as an alternative for `$ new-app`, command, it's for k8s and doesn't know OpenShift specifics
- `$ oc run mymariadb —image=mariadb` —> start an unmanaged pod/naked pod

## Displaying Application Information:

- `$ oc get all` —> find all application resources, show pod, replica set, deployment, service information
- `$ oc get all -A` —> an overview of resources in all projects
- `$ oc get pods`
- `$ oc get pods -A`
- `$ oc get pods [mypod] -o yaml` —> see logs in yaml format
- `$ oc describe pod [mypod]` —> logs are being stored in etcd, if anything bad happens should use this command
- `$ oc logs [mypod]` —> check STDOUT of mypod
- `$ oc status` —> see status
- `$ oc get pods -o wide` —> show information of pods, with IP address

### For Troubleshooting:

- `$ oc get all`
- `$ oc get pods [mypod] -o yaml`
- `$ oc logs [mypod]`

## Using Labels

- `$ oc get pods,rs —show-labels` —> show all labels
- `$ oc get pods,rs —selector app=nginx` —> show filtered result using label
- `$ oc label pod [mypod] storage=ssd` —> add storage=ssd to end of labels of mypod
- `$ oc edit svc bitginx` —> edit configuration file. must be sure about what you are doing

---

## Tips & Tricks:

- `$ oc get all —selector app=<my-name>` —> with selector we only see what we want
- `$ oc create deploy mynewapp —image=busybox — sleep 3600` —> what comes after `—` means what is executed inside the OpenShift container
- For finding processes in a container that has no `$ ps` installed, `$ cat /proc/[PID]/cmdline`

# ——————————————————

## Module 1: Container Fundamentals

### Lessons: Part One: Red Hat EX180

#### 1- Introduction to containers and Kubernetes

- Podman: the default container engine in RHEL to run container images instead of docker.
- Container engine: takes a container image and turns it to a container. Consists of a runtime, CLI tool and sometimes a daemon. eg Podman, systems, docker, lxc
- Container Runtime: (heart of a container) a specific part of the container engine, which takes care of specific tasks: providing mount points, communicate with the kernel, setup groups and … . Eg CRI-O (RedHat), containerd (docker-based)
- runC : a lightweight universal container runtime. It’s included in CRI-O and containerd.

#### Stand-alone container limitations:

- Storage in containers are ephemeral
- Scaling up containers are not easy
- Providing access to containers are complex
- Providing site-specific information for a running container is complex

#### DataCenter Orchestration Features:

- Scalability
- Availability: making sure that a sufficient number of containers are always available
- Decoupling: separating site-specific data from static code
- Accessibility: providing a uniform way to access workloads, regardless if they’re provided by one or multiple containers
- Persistent storage: ensuring data outlives the container lifetime

- OpenShift: started as an independent solution to automate building software from source code to running applications. Its original intention was to be a DevOps tool, offering services to automate CI/CD. Current OpenShift is built on top of Kubernetes and adds many features on Kubernetes core.
- Open Shift Unique Features:
  - Source-to-image: automatically build container images from source code and run these as orchestrated containers.
  - Routes: easily exposes access to running application workloads.
  - Operators: additional features provided as open source or partner solutions through OperatorHub, such as: Storage providers, Monitoring and metering software, Applications that integrate in the Kubernetes APIs
  - More developed Kubernetes feature, like RBAC and other API extensions

# ——————————————————

#### 2- Running Containers

- Container images are configured with an entry point, which is the default command to be executed. If the container starts a service, the entry point is executed and the container will continue to run in the foreground.
- Running Containers with PodMan: decide if you want to run container as a rootless container, or with root privileges.
- Rootless containers: [default in OpenShift]
  - Runs with limited user privileges
  - Do not get an IP address
  - Cannot bind to a privileged port
  - Have limited access to filesystem

- To run rootless containers, rootless images must be provided. On docker hub, look for bitnami images which run as rootless images. In a RedHat environment, get images from Red Hat Container registries as these are rootless by default.
- From host OS perspective, a container is just a process. A well restricted process though, as namespaces, groups and SELinux limit what the container can do.

# ——————————————————
# 3- Managing Container Images

- Common public registries:

  - [Quay.io](http://Quay.io) —> RedHat sponsored public registry
  - [Catalog.redhat.com](http://Catalog.redhat.com) —> Red Hat ensures the reliability and security of images
  - Docker hub
  - [Cloud.google.com/container-registry](http://Cloud.google.com/container-registry) —> a common registry, used in Kubernetes

- `/etc/containers/registries.conf` —> access to registries information, eg [registries.search] and [registries.insecure] which is for registries without TLS
- After downloading user images, they are stored in user home directory
- After downloading images with sudo privileges, they are stored in `/var/lib/containers/storage/overlay-images`
- By default the `:latest` tag is used

# ——————————————————

# 4- Managing containers

- For realizing what was image’s entry point, `$ cat /proc/1/cmdline`

### Volume:

- containers has two parts by default: read-only image + read-write layer
- when a container is started, an ephemeral read/write storage is added, this storage guarantees that data is kept after restart. also after restart this data is still available. after using `$ podman rm` the read/write layer is removed. to ensure data will always be available, persistent storage must be provided
- a host directory is mounted inside the container to ensure data is stored externally, this guarantees the availability of data after the container lifetime
- to secure access to the host directory, the `container_file_t` SELinux context is applied. source context of SELinux for a container is `container_runtime_t`. if it is not set then we will get AVC denied error
- the type of storages that could be added to a container in order to has persistent storage:
  - bind-mount storage, which is a directory inside of host system
  - external volume (or NFS)

- to see files that are mounted in a container, `$ podman inspect`, look for Mounts
- SCENARIO: add bind-mount to a container:
  - to start, the host directory must be writable by the container main process. if containers are started with a specific UID, the numeric UID can be set. use `$ podman inspect [image]` and look for User to find which user it is
  - `$ sudo chown -R <id>:<id> /hostdir` —> set the User ID found in the container
  - now set SELinux
    - `$ sudo semange fcontext -a -t container_file_t “/hostdir(/.*)?”`
    - `$ sudo restorecon -Rv /hostdir`

- mount storage using `podman run -v /hostdir:/dir-in-container [myimage]`
- there is another way, for setting SELinux automatically, you can do: (recommended while using rootless containers)
  - `$ podman run -v /hostdir:/dir-in-container:Z [myimage]`

### Networking:

- Rootless containers don’t have an IP address and are accessible through port forwarding on the container host only
- Root containers connect to a bridge, using a container-specific IP address
- Containers behind the bridge are not directly accessible
- podman networking is according to the Container Network Interface (CNI), CNI standardizes network interfaces for containers in cloud native environments
- podman uses CNI to implement a Software Defined Network (SDN)
- according to `/etc/cni/net.d/87-podman-bridge.conflist`, a bridge is used for this purpose
- in this model containers on different hosts cannot directly connect to each other, to connect containers a higher level overlay network is required
- to make container applications accessible, port forwarding is used. note that traffic can go out of container but can’t come in, also it is host specific which means that you can’t move container to another host, there is another way in orchestration
  - `$ sudo podman run -d -p 8088:80 nginx` —> runs an nginx container on port 80 where port 8088 can be addressed on host to access its workload
  - `$ sudo podman run -d -p 127.0.0.1:8088:80 nginx` —> only traffic comes from this source ip it is allowed to access
  - `$ sudo podman port` —> find which port mapping applies to containers

# ——————————————————

# 5- Creating Custom images

### Options for customizing images

1. commit changes to an image is not good for maintainability, build automation and repeatability
2. Dockerfile or buildah: standard for building custom images that are easy to share
3. OpenShift S2I: can be used as a standalone s2i utility, or as a part of OpenShift to build custom applications from source code. It can build app directly from GitHub

### Where to get Images

1. Red Hat Software Collective Library (RHSCL): tools that don’t fit the default RHEL release, and contain Dockerfiles for many products. community versions of these Dockerfiles are on [github.com/sclorg?q=-container](http://github.com/sclorg?q=-container)
2. Red Hat Container Catalog (RHCC): RedHat quality assurance process
3. [Quay.io](http://Quay.io): community-contributed container images
4. Docker Hub: community-contributed, not tested or verified in any sense, not optimized to be used in Red Hat environment

### podman commit

- `$ podman commit [containername] [imagename]` , use `$ podman diff [containername]` , before committing to reveal changes that have been applied to running containers
- add `—format` to specify format: either oci or docker
- podman commit allows users to modify existing containers and commit the changes to a new image
- it commits the read-writable layer to the read-only disk of the image
- lacks traceability and keeps unnecessary files in the image

- in RedHat environment it’s common to talk about Containerfile instead of Dockerfile
- A child image is an image that is created from a parent image and incorporates everything in the parent image, starting from a parent image makes it easier to create a reliable image
- alternatively, Dockerfile images can be created by modifying existing images

### Writing a Dockerfile

- each Dockerfile starts with `FROM`, identifying base image to use
- next instructions are executed in that base image, order is important
- each Dockerfile instruction runs in an independent container, using an intermediate image built from a previous command, which means that adding multiple instructions results in multiple layers. try to use as fewer instructions as possible
- if not specify entry point, `/bin/sh -c` is executed as default command

#### Instructions:

- `FROM` identifies the base image to use
- `LABEL` is a key-value pair that is used for identification
- `MAINTAINER` is the name of person that maintains the image
- `RUN` executes command on the FROM image
- `EXPOSE` has metadata-only information on where the image should run
- `ENV` defines environment variables to be used within the container
- `ADD` copies files from the project directory to the image
- `COPY` copies files from the local project directory to the image, ADD is preferred
- `USER` specifies username for RUN, CMD, and ENTRYPOINT instructions
- `ENTRYPOINT` defines the default command
- `CMD` contains default arguments for the ENTRYPOINT instruction

#### Shell vs Exec form:

- options like ADD, COPY, ENTRYPOINT, CMD are used in shell form and in exec form
- **Shell form** is a list of items:
  - `ADD /my/file /mydir`
  - `ENTRYPOINT /usr/bin/nmap -sn 172.17.0.0/24`

- **Exec form** is a JSON array of items (preferred, shell form wraps commands in a `/bin/sh -c` shell, which sometimes creates unnecessary shell processes):
  - `ADD [“/my/file”, “/mydir”]`
  - `ENTRYPOINT [“/usr/bin/nmap”, “-sn”, “172.17.0.0/24”]`

#### Optimization:

- Each command used in a Dockerfile creates a new layer, don’t run multiple `RUN` commands, connect them using `&&`
- **Dockerfile size optimization**:
  - when installing software from a Containerfile, use `$ dnf clean all -y` to clean yum caches
  - Exclude documentation and unnecessary dependencies using the `—nodocs —setopt install_weak_deps=False` option to `$ dnf install`

#### Example:

```Dockerfile
FROM centos:7 (ub or ub8 : red hat universal base image)
MAINTAINER Sander <mail@sandervanvugt.nl>

# Add repo file
COPY ./sander.repo /etc/yum.repos.d/

# Install cool software
RUN yum --assumeyes update && \
    yum --assumeyes install bash nmap iproute && \
    yum clean all

ENTRYPOINT ["/usr/bin/nmap"]
CMD ["-sn", "172.17.0.0/24"]  (these are arguments for entry point, it must be array style “arg1”, “arg2”, ”arg3”, so the entrypoint is nmap -sn 172.17.0.0/24)
```

- `$ podman build -t [imagename] [:tag (optional, if not specified tagged as latest)] directory` —> create from Dockerfile

### Skopeo

- Skopeo can be used to manage images from image repositories
- `$ skopeo inspect` —> inspect images as they are stored in image repositories
- `$ skopeo copy` —> copy images between registries and between local files and registries
- in an OpenShift environment, Skopeo can be used to push images to the local OpenShift registry

### buildah

- Buildah can be used to create and manage custom images
- Image management functionality is also integrated in podman, but buildah has the advantage that it includes a scripting language, which allows you to build an image from scratch, such that it is not based on any base image
- Consider building an image from scratch, using buildah, it has nothing but the stuff that you’ll put in there

```bash
$ buildah from ubi8/ubi:latest —> creates a new image based on RHEL8
$ buildah images —> shows that NO image was created, we still have to create it
$ buildah containers —> shows that a new buildah-based container was started (ubi8-working-container)
$ curl -sSl [http://ftpmirror.gnu.org/hello-2.10.tar.gz](http://ftpmirror.gnu.org/hello-2.10.tar.gz) -o hello-2.10.tar.gz —> downloads a file
$ buildah copy ubi8-working-container hello-2.10.tar.gz /tmp/hello-2.10.tar.gz
$ buildah run ubi8-working-container yum install -y tar gzip gcc make
$ buildah run ubi8-working-container yum clean all
$ buildah run ubi8-working-container tar xzvf /tmp/hello-2.10.tar.gz -C /opt
$ buildah config —workingdir /opt/hello-2.10 ubi-working-container
$ buildah run ubi8-working-container ./configure
$ buildah run ubi8-working-container make
$ buildah run ubi8-working-container make install
$ buildah run ubi8-working-container hello -v
$ buildah config —entrypoint /usr/local/bin/hello ubi8-working-container
$ buildah commit —format docker ubi8-working-container hello:latest
```

**_———————————————_**
# Module 2: OpenShift Fundamentals

## Lessons: Part Two: Red Hat

### 6- Running OpenShift

- Red Hat OpenShift Container Platform (RHOCP) needs a license for enterprise level support
- Free version of OpenShift is OpenShift Kubernetes Distribution (OKD), previously known as OpenShift Origins. OKD is OpenSource Downstream of OpenShift
- options to work with OpenShift:
  - Red Hat OpenShift Container Platform (RHOCP): which allow customers to build their own OpenShift cluster on top of their own infrastructure, either bare metal, virtual machines, private or public cloud
  - Red Hat OpenShift Kubernetes Engine: provides just the K8s core functions and can be installed on top of any infrastructure
  - OpenShift Kubernetes Distribution (OKD): Open Source alternative to RHOCP
  - Red Hat OpenShift Dedicated: Dedicated OpenShift cluster, running on AWS or Google cloud and managed by Red Hat
  - Red Hat OpenShift Online: shared OpenShift cluster, managed by Red Hat running on Red Hat infrastructure (shared by other customers)
  - Managed versions for different cloud providers: Red Hat OpenShift services on AWS - Microsoft Azure Red Hat OpenShift - Red Hat OpenShift on IBM cloud

- Learning OpenShift:
  - Red Hat CodeReady containers provides an all-in-one virtual machine, offering OpenShift 4 services
  - OKD CodeReady containers: based on OKD
  - OpenShift CodeReady Containers (CRC): because OpenShift needs lots of resource, RedHat introduced CRC as an all-in-one test solution. Could be installed on top of all OSs, need 16 GB RAM (CRC needs at least 12 GB RAM), it’s better to install it on VM. Could be downloaded from [developers.redhat.com](http://developers.redhat.com), installation on RHEL is recommended
  - there is no update in CRC, should do this for update:
    - `$ crc delete`
    - `$ crc setup`
    - `$ crc start -m 12244 -p pull-secret.txt`

- After installation of OpenShift, local users are created:
  - `kubeadmin` is the “internal” OpenShift user that has full access to the cluster
  - `developer` is the developer user that has permission to deploy applications in OpenShift
  - for more advanced authentication, an authentication provider must be configured. (ex280) also for Role-Based Access Control (RBAC) you’ll need an external authentication provider

- `$ crc console —credentials` —> shows info to login as kubeadmin or developer
- OpenShift cluster has its own CA, which by signing clients pub key make client authentication easier.

### OC Client

- should install OpenShift CLI (OC Client) for working. It is primary command line interface to work with OpenShift. Must be preferred above using OpenShift Console. It is already installed in CRC.
- for start using it: (make sure do this to use latest version of OC Client)
  - `$ crc oc-env`
  - `$ eval $(crc oc-env)`
  - `$ source <(oc completion bash)` —> for auto completion
  - `$ oc login -u developer -p developer` —> login
  - `$ oc new-project [myfirstapp]` —> projects are isolated from each other
  - `$ oc create deployment [myweb] —image=bitnami/nginx (rootless image) —replicas=3`
  - (`$ oc new app` —> use extra resources)
  - use `-h` for help
  - `$ oc get all` —> see info about deployments and pods

### 7- Running Applications in OpenShift

**OpenShift Resources** (defined in OpenShift APIs & stored in etcd database):
- **Pod**: a running instance of an app, has IP, could have Volume
- **ReplicaSet** (formerly ReplicationController): the resource that takes care of running multiple instances of pods
- **Deployment** (formerly DeploymentConfig): resource that adds cluster properties to running the deployment, such as update strategy and replication. The ReplicaSet is managed by Deployment
- **Service**: used to load balance ingress traffic between the different Pod instances. (an API based Load Balancer)
- **Route** (OpenShift specific): used to expose a URL that provides access to services

- **Decoupling**: separating site-specific data from code. We do site-specific data (like environmental variables) using config map, essence of OpenShift is application code is being separated from application data which is running somewhere else. If something bad happens to one of running instances of app, it’s not a problem because OpenShift is going to run another instance which is going to connect to our data.

**APIs**:
- For scalability, we have replica set + deployment
- For accessibility, we have service + route
- For storing variables we have configMap + secret is for configuration and variables in a secure way
- For storage we have PV and storage can be dynamically created by storage class
  - `$ oc api-resources` —> show a list of all resources and the specific API collection they are coming from. If its version is 1 or v1 it is coming from k8s if not it is added by OpenShift
  - `$ oc explain [name of resource]` —> get more information about API resource
  - `$ oc explain [name of resource].spec` —> information about API resources that could be inside yaml file

**Deploy Applications in OpenShift**:
- applications should be deployed in isolated environments to enhance security and manageability, should use projects, could limit quota and RBAC on projects. OpenShift projects are on top of k8s namespaces, difference is RBAC is in OpenShift but not k8s
- before creating applications, create new projects. It’s best practice to have a project for each application
  - `$ oc new-project` —> create new project
  - `$ oc projects` for developer or `$ oc get ns` , as administrator to get an overview of all projects
  - `$ oc new-app` —> primary tool for running apps, can build images from different sources:
    - Dockerfile
    - Image from any image repository
    - Directly from source code
    - Indirectly from source code, using Source to image (s2i)
  - `$ oc new-app —as-deployment-config` —> run apps specifically as a deployment config
  - `$ oc create deployment` —> can be used as an alternative for `$ new-app`, common, its for k8s and doesn't know OpenShift specifics
  - `$ oc get all` —> find all application resources
  - `$ oc get all -A` —> an overview of resources in all projects
  - `$ oc status` —> see status

- when starting app with `$ oc new-app`, if you check `$ oc get all`, you’ll see a replicaset which is deactivated, it was being used when app was creating and now that everything is good there is no use for that, but OpenShift keeps it in order for you to want to roll back. After app updates old replicas hang around in order that a roll-back is desired
- when running apps in OpenShift, logs of apps are being written in etcd database with json format

### Labels
- automatically or manually applied to workloads in OpenShift, used as a selector
- Replicasets use labels to monitor availability of pods, if labels change or are deleted then replicaset is going to create new pods because availability of pods are being monitored using labels
- Services use labels to connect to Pods with a matching label
- Admins can use labels to make filtering or scheduling Pods easier

### Declarative vs Imperative
- In an **Imperative** way, an operator types commands to get things done
- In a **Declarative** way, the configuration is managed as code (preferred)
- while using declarative way, it’s easy to manage versions of configuration code using a version control system
- OpenShift resources can be defined in a declarative way using YAML files
  - generating them (not from scratch) —> `$ oc create deploy mynginx —image=bitnami/nginx —dry-run=client -o yaml > mynginx.yaml`, in dry-run it shows what it’s gonna do but will not do it
  - written from scratch, directions can be found using `$ oc explain`
  - generating from a running resource using `$ oc get deploy mynginx -o=yaml`, not recommended because you’ll need to clean up the resulting YAML file

### Services
- In OpenShift, a pod SDN (Software Defined Network) is provided for Pod access
- Pod IP addresses are volatile, pods are not addressed directly, but services are used instead
- Services are exposed on the cluster IP address
- The service provides an IP address that can be used to access workloads running in Pods, either from within the cluster, or from outside the cluster if a route is added
- Services also provide load balancing when multiple Pods are used in a replicated setup

- when a user sends a request, it is going to internal OpenShift DNS (FQDN) then going to Route, Route would use the Load balancer, LB forward traffic to nodeport, or directly to clusterIP. If it’s gonna be forwarded to nodeport, it is going to be port-forwarded because all of our api-servers are working in a specific port, node port service is port forwarding traffic to pods
- In MicroService architecture, it is convenient that FrontEnd is exposed via nodeport. We do traffic somehow that nodeport service is connected to clusterIP service and BackEnd is there so it is not exposed to outer world

### Pod to Service Connection
- Services are using selector labels to find Pods they should connect to
- Pods themselves know which services they are connected to by two environment variables that are automatically assigned to running Pods:
  - `SVC_NAME_SERVICE_HOST`: services IP address
  - `SVC_NAME_SERVICE_PORT`: services port
- Services also automatically register with k8s internal DNS server, which makes them accessible through DNS as:
  - `SVC_NAME.PROJECT_NAME.svc.clustername`
- Cluster name can be obtained using `$ oc config get-cluster`, or `$ oc config current-context`

### Pod Access Options
- Different services can be used:
  - **ClusterIP** provides an IP address that is only accessible on the ClusterIP. This IP address cannot be addressed directly by external users
  - **NodePort** provides a node port on the cluster nodes which allows users to connect to the service directly
  - In OpenShift services are not addressed directly. Use routes instead
  - `$ oc port-forward mynginx 8080:80` —> expose a Pod port on the local workstation where the oc client is used. This is good for admin/developer access but not to expose workloads to external users

### Routes
- Routes use services to access pods. Router Pods are deployed on infrastructure nodes
- Router Pods bind to the node public IP addresses, from where traffic can be forwarded to services, thus providing access to the pods
- DNS must be configured to enable traffic forwarding to the appropriate public node IP address
- In route spec, two important fields are used:
  - `spec.host`: DNS name that is used by the route to expose itself
  - `spec.to`: name of the service resource
- Routes can be configured to handle TLS traffic
  - `$ oc expose service <servicename>` —> generates a DNS name that looks like `routname.projectname.defaultdomain`, default domain is a wildcard DNS domain that is configured while installing OpenShift, and matches the OpenShift DNS name, on CRC the default domain is set to `apps-crc.testing`. The external DNS server needs to be configured with a wildcard DNS name that resolves to the load balancer that implements the route
- OpenShift runs a default router in the openshift-ingress namespace, the `ROUTER_CANONICAL_HOSTNAME` variable defines how this router is accessible from the outside:
  - `$ oc get pods -n openshift-ingress`
  - `$ oc describe pods -n openshift-ingress router-default-[TAB]`
  - `$ oc get pods -o wide` —> show information of pods, with IP address

——————————————————

# module 3: Using OpenShift to Automate Complex Application Builds

## 8- Running MicroServices in OpenShift

### Decoupling

- The different components in a microservice need to be connected to each other by providing site-specific information
- For decoupling site-specific information from generic application code, OpenShift provides several resources
- Services provide a single point of access that is used as a Load Balancer (LB) to provide access to the app
- Templates can be used to define a set of resources that belong together, as well as application parameters
- ConfigMaps and Secrets can be used to provide a set of variables, parameters, and configuration files that can be used by application resources
- Persistent Volume Claims (PVCs) are used to connect to storage that is available in a specific environment
- If you get an image from DockerHub which needs root privilege, you can bypass it running it with kubeadmin account

### ConfigMap

- Purpose of ConfigMaps are decoupling
- Decoupling means that static data is kept apart from site-specific dynamic data
- ConfigMaps and secrets are very similar, but information in secrets are Base64 encoded
- ConfigMaps are used to store the following types of values:
  - variables
  - Application startup parameters (not that commonly used)
  - Configuration Files

#### Demo, ConfigMap for ConfigFiles:

- `$ oc create deploy mynginx —image=bitnami/nginx`
- `$ oc get pods`
- `$ oc cp <podname> :/app/index.html index.html`
- Apply modifications to index.html
- `$ oc create configmap mycm —from-file=index.html`
- `$ oc set volume deploy mynginx —add —type configmap —configmap-name mycm —mount-path=/app/`
- `$ oc expose deploy mynginx —type=NodePort —port=8080`
- `$ oc get svc`
- `$ curl [http://$](http://$)(crc ip):<nodePort>`
- `$ oc get deploy mynginx -o yaml`

#### Demo, ConfigMap for variables

- `$ oc create deploy mymariadb —image=mariadb`
- `$ oc logs mymariadb-<ID>`
- `$ oc create configmap myvars —from-literal=MYSQL_ROOT_PASSWORD=password`
- `$ oc describe configmap myvars`
- `$ oc set env deploy mymariadb —from=configmap/myvars`
- `$ oc describe deploy mymariadb`
- `$ oc get deploy mymariadb -o yaml`

### Secrets

- A base64 encoded ConfigMap
- Secrets are used a lot internally in OpenShift:
  - To provide access to APIs
  - To provide access to passwords
  - To provide access to other resources
  - For authentication to external systems
- Using secrets to authenticate to external registries such as Docker may help in bypassing limitations (100 pulls in 6 hours for unauthenticated users)
  - `$ oc create secret docker-registry docker —docker-server=[docker.io](http://docker.io) —docker-username=YOURUSERNAME —docker-password=YOURpASSWORD —docker-email=YOUREMAILADDRESS`
  - `$ oc secrets link default docker —for=pull` —> make new secret your default pull secret

#### Demo, creating a secret from a file

- `$ podman login [docker.io](http://docker.io) # provide username and password`
- `$ oc create secret generic docker —from-file .dockerconfigjson=${XDG_RUNTIME_DIR}/containers/auth.json —type [kubernetes.io/dockerconfigjson](http://kubernetes.io/dockerconfigjson)`
- `$ oc describe secret docker`
- `$ oc get secret docker -o yaml`
- `$ oc secrets link default docker —for pull`

### Persistent Storage

- Container storage by nature is ephemeral
- To provide persistent decoupled storage, OpenShift uses persistent volumes
- A persistent volume is a cluster-wide storage resource that is created by the site admin to connect to site-specific storage
- Persistent volumes can be dynamically generated using StorageClass
- A Persistent Volume Claim (PVC) is used to request access to storage, applications are configured to use a specific PVC by referring to their name. A PVC has an access mode, and a resource request, but does not connect to a specific type of PV, that leaves the decision of what to connect to the cluster. To better determine what to connect to, StorageClass can be used as a matching label between the PV and the PVC. After requesting access to the PV, the PVC will show as bound
- Many templates are offered with a -persistent suffix, and offer access to persistent storage

- `$ oc get templates -n openshift | grep persistent`
- These templates contain a PersistentVolumeClaim resource, that only needs to know which type and how much storage is required. You only need to specify the required capacity, using the VOLUME_CAPACITY parameter

### Template

- When an app is defined, typically a set of related resources using the same parameters is created
- Templates can be used to make creating these resources easier
- Resource attributes are defined as template parameters
- Template parameters can be set statically, or generated dynamically
- OpenShift comes with a set of default templates; custom templates can be added as well
  - `$ oc get templates -n openshift` —> list default templates
- Each template contains specific sections:
  - **objects**: defines a list of resources that will be created
  - **parameters**: defines parameters that are used in the template objects

- `$ oc describe template templatename` —> list parameters that are used
- `$ oc process —parameters templatename`
- To generate an app from a template, first need to export the template
  - `$ oc get template mariadb-ephemeral -o yaml -n openshift > mariadb-ephemeral.yaml`
- Next, you need to identify parameters that need to be set, and process the template with all of its parameters
  - `$ oc process —parameters mariadb-ephemeral -n openshift`
  - `$ oc process -f mariadb-ephemeral.yaml -p MYSQL_USER=anna -p MYSQL_PASSWORD=password -p MYSQL_DATABASE=books | oc create -f -`

- Using `$ oc new app` with templates (most apps created like this must use —as-deployment-config in most cases, because most of them are still using deployment-config and not deployment)
  - `$ oc new-app —template=mariadb-ephemeral -p MYSQL_USER=anna -p MYSQL_PASSWORD=ann -p MYSQL_DATABASE=videos —as-deployment-config`

# Demo : setting up mysql and then connect wordpress to it

- `$ oc login -u developer -p password`
- `$ oc new-project microservice`
- `$ oc create secret generic mysql —from-literal=password=mypassword`
- `$ oc new-app —name mysql [registry.access.redhat.com/rhscl/mysql-57-rhel7](http://registry.access.redhat.com/rhscl/mysql-57-rhel7)`
- `$ oc set env deployment mysql —prefix MYSQL*ROOT* —from secret/mysql`
- `$ oc set volumes deployment/mysql -name mysql-pvc -add —type pvc —claim-size 1Gi —claim-mode rwo —mount-path /var/lib/mysql`
- `$ oc new-app —name wordpress —docker-image bitnami/wordpress`
- `$ oc expose svc wordpress`
- `$ oc create cm wordpress-cm —from-literal=host=mysql —from-literal=name=wordpress —from-literal=user=root —from-literal=password=password`
- `$ oc set env deployment wordpress —prefix WORDPRESS*DATABASE* —from configmap/wordpress-cm`
- `$ oc exec -it wordpress-[Tab] —env`

---

# Lab : run a mariaDB with 3 replicated pods. ensure that /var/lib/mysql directory is stored externally, using a claim for 1 GB of storage. Also make sure that the MYSQL_ROOT_PASSWORD variable is set to “password” using a ConfigMap

- `$ oc process —parameters mariadb-persistent -n openshift`
- `$ oc new-app —template=mariadb-persistenr -p MYSQL_ROOT_PASSWORD=password -p VOLUME_CAPACITY=1Gi -p MEMORY_LIMIT=2Gi —as-deployment-config`

---

# 9- Using Source-to-Image

- S2I is the tool that takes application source code from a Git repository, injects this source code in a base container that is based on the source code language and framework, and produces a new container image that runs the application
- Using S2I makes OpenShift easier
- Developer doesn’t have to know anything about Dockerfile or platform specifics
- Patching is made easy: run the process again

## Builder Image

- S2I builder image provides language specifics that are needed to build a working application based on the source code
- A set of standard builder images are provided with OpenShift, custom builder images can also be created
- Source Code + Builder Image = application image
- If either the source code or the builder image changes, the application image needs to be re-generated

## ImageStream

- Builder images are provided by the OpenShift ImageStream
- In an ImageStream builder images are identified, with specific tags that allow users to use different versions of the builder image
- When ImageStreams change, OpenShift will automatically rebuild applications built with that ImageStream
- `$ oc get is -n openshift` —> an overview of available ImageStreams
- `$ oc describe is php -n openshift` —> describe php ImageStreams

## Building apps with S2I

- When creating an app with S2I, you can set the ImageStream that should be used
- If just a git repo and no ImageStream is specified, OpenShift will try to detect the appropriate ImageStream
- `$ oc -o yaml new-app php~[https://github.com/](https://github.com/)… —name=siple_app > s2i.yaml` —> php~ identifying ImageStream
- View `s2i.yaml`
- `$ oc apply -f s2i.yaml`
- `$ oc status`
- `$ oc get builds`
- `$ oc get pods`

- What is the difference between `$ oc create`, and `$ oc apply` —> both can create app, if app already exists and run `$ oc apply`, it will make an updated version of the app but `$ oc create`, gives error

## Build Process

- ImageStream is used to provide access to the right language runtimes to build the source code
- BuildConfig defines input parameters and triggers that are executed to transform source code into a runnable image
- Deployment is responsible for actually running the application Pods
- Service provides access to the application Pods
- Notice that when using `$ oc new-app`, a route is not created automatically. While using the web console, routes are also created because web console is using templates

## Analyzing Build Process

- `$ oc get builds`
- `$ oc get bc/simple -o yaml`
- `$ oc get buildconfig simple`
- `$ oc start-build simple` —> will trigger a new build based on the previously created BuildConfig

---

# ImageStream

- When running container-based apps, images need to be pulled
- These images are stored in the internal OpenShift image registry
- To access images in the image registry, an ImageStream resource is used, which identifies specific images using SHA ID
- ImageStreams store images using tags, which makes it easy to refer to different versions of images
- OpenShift images are not managed directly from the registry, but by using the ImageStream resource —> DO NOT manage OpenShift images directly, only through ImageStream
- When a new app is created with `$ oc create deploy` or `$ oc new-app`, image registries will be contacted to check for a newer image, to prevent this use —image-stream to refer to an existing ImageStream and use the image from the internal image registry. Use `$ oc new-app -L` to list all existing image streams and tags included. Tags can be combined with the —image-stream argument. For instance, `$ oc new-app —name=whatever —image-stream=nginx:1.18-ubi8`
