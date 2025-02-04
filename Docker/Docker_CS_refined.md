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
1- Specify a base image —> `FROM alpine`

2- Run some commands to install additional programs —> `RUN apk add --update redis`

3- Specify a command to run on container startup —> `CMD ["redis-server"]`

### Example:

```dockerfile
# Specify a base image
FROM node:alpine

WORKDIR /usr/app

# Install some dependencies
COPY ./package.json ./

RUN npm install

# copy all other things
COPY ./ ./

# Default command
CMD ["npm", "start"]
```

- Add `.dockerignore`

—————————

## Creating a Docker Compose:

For running: in directory `$ docker-compose up`

`docker-compose.yml`:

```yaml
version: '3'

services:
  postgres:
    image: 'postgres:latest'
    environment:
      - POSTGRES_PASSWORD=postgres_password

  redis:
    image: 'redis:latest'

  nginx:
    depends_on:
      - api
      - client
    restart: always
    build:
      dockerfile: Dockerfile.dev
      context: ./nginx
    ports:
      - '3050:80'

  api:
    build:
      dockerfile: Dockerfile.dev # don’t include directory address, just the name of dockerfile
      context: ./server
    volumes:
      - /app/node_modules # don’t override this one
      - ./server:/app # copy everything on ./server (except node_modules) into /app
    environment:
      - REDIS_HOST=redis
      - REDIS_PORT=6379
      - PGUSER=postgres
      - PGHOST=postgres
      - PGDATABASE=postgres
      - PGPASSWORD=postgres_password
      - PGPORT=5432

  client:
    stdin_open: true
    build:
      dockerfile: Dockerfile.dev
      context: ./client
    volumes:
      - /app/node_modules
      - ./client:/app

  worker:
    build:
      dockerfile: Dockerfile.dev
      context: ./worker
    volumes:
      - /app/node_modules
      - ./worker:/app
    environment:
      - REDIS_HOST=redis
      - REDIS_PORT=6379
```

—————————

## Alpine Image —> Minimal version of image

—————————

## How to push to Docker Hub:

1- Login —> `docker login -u apakhbari`  
For password enter **ACCESS TOKEN**

2- Build —> `docker build -t <image_name> .`

3- Tag image —> `docker image tag <image_name> apakhbari/<image_name>:latest`

4- Push image —> `docker image push apakhbari/<image_name>:latest`

—————————

Don’t forget to add `.dockerignore` with:

```
node_modules
.next
```


# acknowledgment
## Contributors

APA 🖖🏻

## Links


## APA, Live long & prosper
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