##

**Docker**

—————————

**Commands:**

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>docker ps - -all —> List all running containers
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>docker create <image name>
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>docker start -a <container id>
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>docker system prune —> clean all resources
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>docker logs <container id>
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>docker stop <container id>
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>docker kill <container id>
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>docker exec -it <container id> <command> —> Execute an additional command in a container\
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>docker build . —> generate image out of a dockerfile
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>docker build -t apakhbari/redis:latest .
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>docker run -it <image name> —> Creating and Running a Container from an Image + active terminal accese
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>docker run -p 8080:8080 <image id> —> docker run with port mapping
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>docker push apakhbari/posts —> push to docker hub
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>docker compose up —build

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>docker-compose -f docker-compose.ymI -f docker-compose.dev.ymI up -d


- ``` $ docker-compose up ```
- ``` $ docker-compose down ```
- ``` $ docker-compose down -v ``` --> frees up all mount points

—————————

**Tips & Tricks**

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>for creating network:

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>$ docker network create —driver=bridge —subnet=192.168.0.0/16 —ip-range=172.28.5.0/24 —gateway=172.28.5.254 172network<name of network>

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>containers will be in this dir, their files are here too: /var/lib/docker/overlay2/containerid
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>$ docker volume ls —> see all volumes
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>$ docker run -it —name nginx1 -v fisrt_container_vol:/data4 nginx bash —> create volume
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>$ docker volume create sec_container_vol —> create volume
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>for bind mounting : $ docker run -it —name nginx1 -v /root/data4/:/data4 nginx bash<span class="Apple-converted-space"> </span>
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>in Dockerfile

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>difference between add & copy is that add is like wget, it adds stuff from web to our image
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>difference between CMD & ENTRYPOINT is that entrypoint cannot be overwritten

* <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>Usually inside spec add imagePullPolicy: IfNotPresent
* <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>apk —> alpine images package manager
- To add a package with no cache to image --> ``` $ apk --no-cache add curl ```
  —————————

**network Drivers**

- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>bridge: The default network driver. If you don’t specify a driver, this is the type of network you are creating. Bridge networks are commonly used when your application runs in a container that needs to communicate with other containers on the same host. —> IPs will be private
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>host: Remove network isolation between the container and the Docker host, and use the host’s networking directly. —> Ips will be in range of host, within available subnet
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>overlay: Overlay networks connect multiple Docker daemons together and enable Swarm services and containers to communicate across nodes. This strategy removes the need to do OS-level routing.
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>ipvlan: IPvlan networks give users total control over both IPv4 and IPv6 addressing. The VLAN driver builds on top of that in giving operators complete control of layer 2 VLAN tagging and even IPvlan L3 routing for users interested in underlay network integration.
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>macvlan: Macvlan networks allow you to assign a MAC address to a container, making it appear as a physical device on your network. The Docker daemon routes traffic to containers by their MAC addresses. Using the macvlan driver is sometimes the best choice when dealing with legacy applications that expect to be directly connected to the physical network, rather than routed through the Docker host’s network stack
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;"></span>none: Completely isolate a container from the host and other containers. none is not available for Swarm services.
- <span class="s1" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 12px; line-height: normal;">[<span class="s2" style="font-variant-numeric: normal; font-variant-east-asian: normal; font-variant-alternates: normal; font-kerning: auto; font-optical-sizing: auto; font-feature-settings: normal; font-variation-settings: normal; font-variant-position: normal; font-stretch: normal; font-size: 13px; line-height: normal;">Network plugins</span>](https://docs.docker.com/engine/extend/plugins_services/)</span>: You can install and use third-party network plugins with Docker.

—————————

**Creating a Dockerfile:**

<span class="Apple-tab-span" style="white-space: pre;"></span>1- Spcify a base image —> FROM alpine

<span class="Apple-tab-span" style="white-space: pre;"></span>2- Run some commands to install additional programs —> RUN apk add —update redis

<span class="Apple-tab-span" style="white-space: pre;"></span>3- Specify a command to run on container startup —> CMD [“redis-server”

Example:

# Specify a base image

FROM node:alpine

WORKDIR /usr/app

# Install some depenendencies

COPY ./package.json ./

RUN npm install

# copy all other things

COPY ./ ./

# Default command

CMD ["npm", "start"]

- Add .dockerignore

—————————

**Creating a docker compose :**

for running: in directory $docker-compose up

docker-compose.yml :

version: '3'

services:

<span class="Apple-converted-space"> </span> postgres:

<span class="Apple-converted-space">   </span> image: 'postgres:latest'

<span class="Apple-converted-space">   </span> environment:

<span class="Apple-converted-space">     </span> - POSTGRES_PASSWORD=postgres_password

<span class="Apple-converted-space"> </span> redis:

<span class="Apple-converted-space">   </span> image: 'redis:latest'

<span class="Apple-converted-space"> </span> nginx:

<span class="Apple-converted-space">   </span> depends_on:

<span class="Apple-converted-space">     </span> - api

<span class="Apple-converted-space">     </span> - client

<span class="Apple-converted-space">   </span> restart: always

<span class="Apple-converted-space">   </span> build:

<span class="Apple-converted-space">     </span> dockerfile: Dockerfile.dev

<span class="Apple-converted-space">     </span> context: ./nginx

<span class="Apple-converted-space">   </span> ports:

<span class="Apple-converted-space">     </span> - '3050:80'

<span class="Apple-converted-space"> </span> api:

<span class="Apple-converted-space">   </span> build:

<span class="Apple-converted-space">     </span> dockerfile: Dockerfile.dev <span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>//don’t include directory address, just the name of dockerfile

<span class="Apple-converted-space">     </span> context: ./server

<span class="Apple-converted-space">   </span> volumes:

<span class="Apple-converted-space">     </span> - /app/node_modules <span class="Apple-tab-span" style="white-space: pre;"></span><span class="Apple-tab-span" style="white-space: pre;"></span>//don’t override this one

<span class="Apple-converted-space">     </span> - ./server:/app <span class="Apple-tab-span" style="white-space: pre;"></span> <span class="Apple-tab-span" style="white-space: pre;"></span>// copy everything on ./server (except node_modules) into /app

<span class="Apple-converted-space">   </span> environment:

<span class="Apple-converted-space">     </span> - REDIS_HOST=redis

<span class="Apple-converted-space">     </span> - REDIS_PORT=6379

<span class="Apple-converted-space">     </span> - PGUSER=postgres

<span class="Apple-converted-space">     </span> - PGHOST=postgres

<span class="Apple-converted-space">     </span> - PGDATABASE=postgres

<span class="Apple-converted-space">     </span> - PGPASSWORD=postgres_password

<span class="Apple-converted-space">     </span> - PGPORT=5432

<span class="Apple-converted-space"> </span> client:

<span class="Apple-converted-space">   </span> stdin_open: true

<span class="Apple-converted-space">   </span> build:

<span class="Apple-converted-space">     </span> dockerfile: Dockerfile.dev

<span class="Apple-converted-space">     </span> context: ./client

<span class="Apple-converted-space">   </span> volumes:

<span class="Apple-converted-space">     </span> - /app/node_modules

<span class="Apple-converted-space">     </span> - ./client:/app

<span class="Apple-converted-space"> </span> worker:

<span class="Apple-converted-space">   </span> build:

<span class="Apple-converted-space">     </span> dockerfile: Dockerfile.dev

<span class="Apple-converted-space">     </span> context: ./worker

<span class="Apple-converted-space">   </span> volumes:

<span class="Apple-converted-space">     </span> - /app/node_modules

<span class="Apple-converted-space">     </span> - ./worker:/app

<span class="Apple-converted-space">   </span> environment:

<span class="Apple-converted-space">     </span> - REDIS_HOST=redis

<span class="Apple-converted-space">     </span> - REDIS_PORT=6379

—————————

alpine image —> minimal version of image

—————————

How to push to docker hub:

1- login —> docker login -u apakhbari

for password enter ACCESS TOKEN<span class="Apple-converted-space"> </span>

2- build —> docker build -t <image_name> .

3- tag image —> docker image tag <image_name> apakhbari/<image_name>:latest

4- push image —> docker image push apakhbari/<image_name>:latest

—————————

don’t forget to add .dockerignore with:

node_modules

.next
