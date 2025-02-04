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

---

**3rd session: Crosync - Pacemaker**

- Crosync: a cluster engine, which creates a group of systems with additional features for implementing HA within apps. It must be installed on all nodes for it to work. It doesn’t care about services and what is inside cluster it just connects nodes altogether
- corosync config file → /etc/corosync/corosync.conf
- Qourum: minimum number of votes that a distributed transaction has to obtain in order to be allowed to perform an operation in a distributed system. It reduces split brain. more than 2 systems must be involved. It even decide for who is in charge (DC) of cluster by having CIB
- In a cluster, all nodes are asking for more resource
- The Totem Single Ring Protocol (SRP), used by corosync, imposes a logical token-passing ring on the network to accomplish
  - Reliable delivery of messages
  - Flow Control
  - Fault Detection: This is based on IP, so if there is a problem in networking, it is going to be offline
  - Group Membership
  - Allowing a node, part of a cluster, to broadcast a message only if it holds the token

- Pacemaker: HA cluster resource manager - software that runs on a set of hosts (a cluster of nodes) in order to preserve integrity and minimize downtime of desired services (resources). It must be installed on all nodes for it to work.
- A resource is made of 3 parts
  - Standard
  - Provider (could be removed sometimes, so standard directly contact agent)
  - Agent

- Note: first config cluster, then launch pacemaker, then integrate desired service
- PCS Cli helps us. for integration of crosync + pacemaker
- Pacemaker Key Features
  - Detection of and recovery from node- and service-level failures
  - Ensure data integrity by fencing faulty nodes
  - Support for multiple nodes per cluster
  - Support for multiple resource interface standards (anything that can be scripted can be clustered)
  - Support for practically any redundancy configuration (active/passive, N+1, etc.)
  - Automatically replicated configuration that can be updated from any node
  - Relationships between services, such as ordering, colocation and anticolocation
- Fencing: also known as STONITH (acronym for Shoot The Other Node In The Head) is the ability to ensure that it is not possible for a node to be running a service. This is accomplished via fence devices such as intelligent power switches that cut power to the target, or intelligent network switches that cut the target’s access to the local network
- PaceMaker master processes (Daemons)
  - Pacemaker-based: Cluster Information Based (CIB) is an XML representation of the cluster’s configuration and the state of all nodes and resources keeps the CIB synchronized across the cluster and handles requests to modify it. It is possible to change this XML file while cluster is offline and then changes could happen
  - Pacemeker-attrd: maintains a DB of attributes for all nodes, keeps it synchronized across the cluster, and handles requests to modify them. These attributes are usually recorded in the CIB
  - Pacemeker-schedulerd: determines what actions are necessary to achieve the desired state of the cluster
  - Pacemeker-execd: handles requests to execute resources on the local cluster node, and returns the result
  - Pacemeker-fenced: handles requests to fence nodes. Given target node, the fencer decides which cluster node(s) should execute which fencing device(s), calls the necessary fencing agents (either directly, or via requests to the fencer peers on other nodes) and returns the result
  - Pacemeker-controld (DC): Pacemaker’s coordinator, maintaining a consistent view of the cluster membership and orchestrating the other components

commands:

- `$ apt install haproxyctl`

---

**4th session: Pacemaker- Active/Passive Cluster - DRBD - GlusterFS**

- If there are Two different resources on a server that have a sort of dependency, You have to use `$ pcs constraint`, in order to co-locate or order those services together.
- e.g. Ordering Constraints → start vip then start website (kind:mandatory)
- e.g. Colocation Constraints → website with vip (score:INFINITY)

- `$ Rsync` → sync two directories, It is part of linux kernel. Can work on NFS (Network File System)

- DRBD (Distributed Replicated Block Device): is a block device used to create highly available data clusters. This is done by mirroring a whole block device via an assigned network. DRBD can be compared to a network based raid-1. It is way more advanced than rsync
- It is possible to assign only one partition of a Disk to DRBD
- DRBD can be used when disk is not Formatted, so It is a level below that. you can assign it after partitioning. So when mounting you are not mounting disk, you are mounting DRBD. When doing FS, you are not FS disk, but you are FS DRBD
- DRBD is now in version 9
- DRBD is not working on 3 and above nodes, should use iSCSI for such workflows
- Instead of TCP/IP, It is possible to use DRBD using infinity band cables, then replicate servers physically
- DRBD Protocol (use protocol C in most cases)

  - **Protocol A:** Asynchronous replication protocol. Local write operations on the primary node are considered completed as soon as the local disk write has finished, and the replication packet has been placed in the local TCP send buffer.  
  - **Protocol B:** Memory synchronous (semi-synchronous) replication protocol. Local write operations on the primary node are considered completed as soon as the local disk write has occurred, and the replication packet has reached the peer node.
  - **Protocol C:** Synchronous replication protocol. Local write operations on the primary node are completed only after the local and the remote disk write(s) have been confirmed. As a result, the loss of a single node is guaranteed not to lead to any data loss.

- DRBD uses the TCP port 7788

- GlusterFS is way better than NFS. It does not need mounting like NFS. It handles it
- GlusterFS (Gluster File System) is an open source Distributed File System that can scale out in building-block fashion to store multiple petabytes of data.
- The clustered file system pools storage servers over TCP/IP or InfiniBand Remote Direct Memory Access (RDMA), aggregating disk and memory and facilitating the centralized management of data through a unified global namespace.
- It is better to use Object storages for GlusterFS
- Best FS for GlusterFS is XFS
- GlusterFS is like File Storage
