# Docker

—————————

## Commands:

- `docker ps --all` —> List all running containers
- `docker create <image name>`
- `docker start -a <container id>`
- `docker system prune` —> clean all resources
- `docker logs <container id>`
- `docker stop <container id>`
- `docker kill <container id>`
- `docker exec -it <container id> <command>` —> Execute an additional command in a container
- `docker build .` —> generate image out of a dockerfile
- `docker build -t apakhbari/redis:latest .`
- `docker run -it <image name>` —> Creating and Running a Container from an Image + active terminal access
- `docker run -p 8080:8080 <image id>` —> docker run with port mapping
- `docker push apakhbari/posts` —> push to docker hub
- `docker compose up --build`
- `docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d`

```bash
$ docker-compose up
$ docker-compose down
$ docker-compose down -v
``` 
--> frees up all mount points

—————————

## Tips & Tricks

- For creating a network:

```bash
$ docker network create --driver=bridge --subnet=192.168.0.0/16 --ip-range=172.28.5.0/24 --gateway=172.28.5.254 172network<name of network>
```

- Containers will be in this dir, their files are here too: `/var/lib/docker/overlay2/containerid`
- `docker volume ls` —> see all volumes
- `docker run -it --name nginx1 -v first_container_vol:/data4 nginx bash` —> create volume
- `docker volume create sec_container_vol` —> create volume
- For bind mounting: `docker run -it --name nginx1 -v /root/data4/:/data4 nginx bash`

### In Dockerfile:

- The difference between `add` & `copy` is that `add` is like wget, it adds stuff from the web to our image.
- The difference between `CMD` & `ENTRYPOINT` is that `ENTRYPOINT` cannot be overwritten.

- Usually inside spec add `imagePullPolicy: IfNotPresent`
- `apk` —> Alpine images package manager
- To add a package with no cache to image: 
```bash
$ apk --no-cache add curl
```

—————————

## Network Drivers

- **bridge:** The default network driver. If you don’t specify a driver, this is the type of network you are creating. Bridge networks are commonly used when your application runs in a container that needs to communicate with other containers on the same host. —> IPs will be private
- **host:** Remove network isolation between the container and the Docker host, and use the host’s networking directly. —> IPs will be in range of host, within available subnet
- **overlay:** Overlay networks connect multiple Docker daemons together and enable Swarm services and containers to communicate across nodes. This strategy removes the need to do OS-level routing.
- **ipvlan:** IPvlan networks give users total control over both IPv4 and IPv6 addressing. The VLAN driver builds on top of that in giving operators complete control of layer 2 VLAN tagging and even IPvlan L3 routing for users interested in underlay network integration.
- **macvlan:** Macvlan networks allow you to assign a MAC address to a container, making it appear as a physical device on your network. The Docker daemon routes traffic to containers by their MAC addresses. Using the macvlan driver is sometimes the best choice when dealing with legacy applications that expect to be directly connected to the physical network, rather than routed through the Docker host’s network stack.
- **none:** Completely isolate a container from the host and other containers. `none` is not available for Swarm services.
- [**Network plugins**](https://docs.docker.com/engine/extend/plugins_services/): You can install and use third-party network plugins with Docker.

—————————

## Creating a Dockerfile: