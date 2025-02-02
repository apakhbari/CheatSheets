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
