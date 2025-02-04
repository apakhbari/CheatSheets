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

---

**5th session: Ceph**

- Traditionally shared Storages (such as HP3par, EMC and Qnap) were being used which needed SAN Switches and HBA and also needed licensing and were expensive
- DevOps and Cloud Computing (like Openstack) went to OpenSource options for storages. They wanted OpenSource solution on SAN storages. Ceph was born here. Ceph was heavily linux based and operating it was different with HP3par, EMC and Qnap
- Traditionally HBA cards were needed in order to connect storage to servers. Ceph does not need that. It uses cards that support both network and storage
- Ceph storage solution can support all 3 (which was impossible before Ceph): File storage - block storage - object storage
- Ceph has a Native API which allows apps to directly communicate storage
- Hypervisors and VMs want to contact Block storages
- Ceph does its own replication, so there is no need to RAID storages when using Ceph

- Network Card in servers:
  - FC HBA (Fibre Channel) → only for storages
  - NIC (Ethernet) → only for Network
  - CNA (Fibre Channel + Ethernet) → for both storages & Network

- Ceph uses 3 or more nodes for clustering
- If you `$ vi /etc/ceph/ceph.conf`, you’ll see there are two sets of networks, Cluster Network & public network. they could be on same network but it is also possible to be on different networks
  - Cluster network: Cluster configurations and Replicating data happens here
  - Public network: all external services such as kubernetes, apps, Openstack, Vmware

- Ceph has different protocols for each kind of storage:
  - File Storage: MDS (MetaData Service)
  - Block Storage: RBD Protocol → for Vmware, kvm, all Hypervisors
  - Object Storage: Rados-GW (Rados GateWay) → for API, like Swift or Amazon S3

- Ceph does not assign names to its clusters, they have an fsid
- Inside A Ceph Cluster:
  - OSD: a Ceph node which contain SSD or HDD
  - MONs/MGRs: monitors and manages nodes. in /etc/ceph/ceph.conf refers to it as mon host. It is best practice to assign it to another server instead of one of OSDs. It is like corosync, a very vital component to Ceph cluster. It is possible to make mon dockerized. It is best practice to have it sort of clustered itself e.g. active/passive. Command for monitoring is `$ monmaptool`

- Inside a Ceph Cluster:
  - **Cluster monitors** (**ceph-mon**) that maintain the map of the cluster state, keeping track of active and failed cluster nodes, cluster configuration, and information about data placement and manage authentication.
  - **Managers (ceph-mgr)** that maintain cluster runtime metrics, enable dashboarding capabilities, and provide an interface to external monitoring systems.
  - **Object storage devices** (ceph-osd) that store data in the Ceph cluster and handle data replication, erasure coding, recovery, and rebalancing. SSD or HDD
  - **Rados Gateways** (ceph-rgw) that provide object storage APIs (swift and S3) via http/https.
  - **Metadata servers** (ceph-mds) that store metadata for the Ceph File System, mapping filenames and directories of the file system to RADOS objects
  - **iSCSI Gateways** (ceph-iscsi) that provide iSCSI targets for traditional block storage workloads such as VMware or Windows Server.

- Object storages are like icloud or dropbox, each object has a http address, it is accessible using API, you are not limited to a certain location. Object storage is one level upper than block storage, so it has better performance in upload/download purposes. Object Storages has certain Payloads, metadatas and ID. Usually all of video/music contents are Object Storages so it is easy to see video counts online and when you ask for a video, closest/fastest server to you respond and all servers are in replication with each other
- pg (placement group): a 20Gb data won’t store directly on an OSD. It is going to PGs then assigns to OSDs. This assignment is automatically being used by Ceph using CRUSH/CRASH service which is using lots of mathematical algorithms for doing so. Best Practice Number of PGs are whether 32, 64 or 128. The only thing admin interacts with is Pool.
- Pool: pools are like namespaces, they logically differentiate between different resources

- Since Ceph is Ip based, its security can be compromised, so CephX authentication system is used by Ceph to authenticate users and daemons and to protect against man-in-the-middle attacks.
- cephx uses shared secret keys for **authentication**. This means that both the client and the monitor cluster keep a copy of the client’s secret key.

- It is best practice to ssh-copy-id between Ceph components so there is agent-less and passwordless communication amongst them

---

**6th session: Ceph - iSCSI - Active/Active clustering**

- Ceph needs libvirt library for KVM APIs (specially GUI web-based dashboard) to work correctly, It is not being installed automatically, you have to install it in order to work with it
- iSCSI facilitates data transfers over intranets and to manage storage over long distances. It can be used to transmit data over local area networks (LANs), wide area networks (WANs), or the Internet and can enable location-independent data storage and retrieval.
- Using iscsi it is possible to mount storage of a server on another server
- Naming convention for ISCSI: iqn.2023-09.anisa.local:node1.target1
  - node1 is server1 and target is disk, so we know which storage is assigned to which disk
- All Linux FileSystems are working locally, they are not working in clusters.
- FileSystems that are working in cluster:
  - CLVM
  - GFS2
  - OCFS2

- Lots of Active/Active Services (including FileSystems) are developed by oracle
- Distributed Lock Manager (DLM) is a mechanism that allows cluster nodes to synchronize their access to shared resources. The main goal of the lock manager is to act as a gatekeeper, controlling the access to the shared resources. DLM is able to communicate between nodes in order to manage lock traffic

---

**7th session: Bonding**

- Bonding is for LB and Failover
- Bonding: a method for aggregating multiple network interfaces into a single logical bonded interface. When bonding interfaces you will see an increase in maximum throughput.
- Mode 0 ⭐ → balance-rr (round robin, will have failover in packets if a channel is failed)
- Mode 1 ⭐ → active-backup (will only do LB)
- Mode 2 → balance-xor
- Mode 3 → broadcast
- Mode 4 ⭐ → link aggregation (IEEE 802.3ad / 802.1ax) (both interfaces connect to same place in order to increase throughput)
- Mode 5 → balance-tlb (transmit load balancing)
- Mode 6 → balance-alb (adaptive load balancing)

- Notice: Never install network-manager package on your servers for installing nmcli and bonding, use netplan instead



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