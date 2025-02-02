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
