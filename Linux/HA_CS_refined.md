- **Index**
- HA Cluster Management
- HA Concepts: crom - fence - speedtest
- LB Clusters: ipvsadm - keepalive - haproxy - octavia
- Failover Clusters: corosync (cluster engine) - pacemaker (resource management in a cluster)
- HA Cluster Storage
- DRBD (Distributed Replicated Block Device): replicate in 0,1 level
- Cluster Storage Access: tgt - san storage linux
- Clustered File Systems: gfs - ocfs - Active/Active
- HA Distributed Storage
- GlusterFS Storage Clusters
- Ceph Storage Clusters
- Single Node HA
- HardWare and Resource HA
- Advanced RAID
- Network HA

---

**1st session: Introduction**

- HA is a known word, but an unknown concept
- mostly we outsource HA to the services, when service is down we really don’t know what it does and how it does it
- First uses of HA was in VMs
- We care about keeping a service up and real-time
- everything could be in a cluster
- Most of companies don’t really have a plan for their disaster time
- there is no such thing as restarting a service inside a cluster!
- almost all services have HA

  - DB —> oracle
  - Storage —> Ceph
  - Services - virtualization —> ESXI - Hypervisor - KVM
  - Container —> k8s
  - queuing —> RabbitMQ

- HA: config delivery quality performance and handle different loads and failures with minimum zero downtime
- FailOver Cluster: a set of services that are working together to maintain HA
- Active Passive cluster: consists of one active server and one passive standby server with a third-party LB
- Cluster engine: when 2 servers are clustered together, they are using a cluster engine app like corosync
- Cluster resource: an engine in clustering which manages resources which are mostly services, like pacemaker. cluster-resource agent is aware of health of its resource

---

**2nd session: HaProxy - IPVS - Keepalive**

LB

- Load balance: method of distributing network traffic across a pool of resources
- What are the benefits of LB
  - App availability
  - App scalability
  - App security: because our servers are not facing internet
  - App performance

- LB algorithms:
  
  - Static:
    - Round-robin
    - Weighted round-robin
    - IP hash method: respond request to the specific server

  - Dynamic:
    - Least connection method
    - Weighted least connection method
    - Least response time method
    - Resource-base method

- HAProxy has a health-check method and would understand if a server is now down
- HAProxy is better than nginx in LB, but nginx is simpler for config
- IPVS (IP Virtual Server) is a part of linux kernel which implements transport-layer LB (layer 4), it is both TCP and UDP based. It runs on a host and acts as a LB in front of a cluster of real servers. It can make services of the real servers appear as virtual services on a single IP address. k8s uses it a lot for communicating its controller/API and kubelets of nodes
- IPVS modes
  
  - IPVS Via NAT: IP Addresses are mapped from one group to another. The LB gets Packets and then distributes it, then returns it
  - IPVS Via Tunneling: encapsulate IP datagram within IP diagrams. LB transfer packet to servers, then servers respond to user directly. communication between LB and servers are tunneled. You should create tunnels yourself in order for it to work
  - IPVS Via Direct Routing: not being used that much. (although usually NAT is being used in internal networks) this one is good for internal networks. LB gets packets and then transfer it to servers and then servers respond to user

- Octavia is LB as a service
- in LB:
  - Front: where you are facing client
  - Back: where LB is facing real servers
- Keepalive is a kind of LB, in level 4, it has a VRRP (Virtual Router Redundancy Protocol) which has a virtual IP that you can define it as your main IP
- in a cluster, when a node is down, after it is up again we don’t give it resources. since it needs further investigations and is probably un-stable. we don’t use keepalive because it doesn’t have this feature implemented in it, so it is mostly used in LB
- keepalive is good but just for LB. It is not good for clusters, it is mostly used in Active/Passive situations
- All services in Linux could be clustered, it is using pacemaker
- haProxy module is actually very advanced, specially in Apache and HTTP-based apps. it is in layer 4 ([http://192.168.1.20:80](http://192.168.1.20:80)) & layer 7 (which means it can load balance [http://192.168.1.20:8080/register.name](http://192.168.1.20:8080/register.name)), It is even stronger than nginx. It is widely being used in other enterprise softwares such as open-stack. It even can handle SSL, in two ways:
  1. request is encrypted while transmitting to HAProxy, then it communicates with its servers in http
  2. request is encrypted while transmitting to HAProxy, then it decrypts messages and encrypts it with an internal SSL then communicates with its servers, this way it has an overload. You can also return errors 400, 403, 408, 500, 502, 503, 504. It has health checking
- HAProxy is consisted of:

  - FrontEnd:
    - bind: which port it is
    - default_backend: refer to which backend
    - ACL (Access Control List): you can set who can access what. for example only internal users can access this server
    - option
  
  - BackEnd:
    - Balance (Roundrobin, leastconn, …)
    - Server

- If we are only using TCP, ipvsadm is better than HAProxy

Commands:

- `$ apt install ipvsadm`
- `$ ipvsadm -L —> shows table`
- `$ apt install keepalived`
- `$ apt install haproxy`
- `$ apt install haproxyctl`
