# Ceph
```
 _______  _______  _______  __   __ 
|       ||       ||       ||  | |  |
|       ||    ___||    _  ||  |_|  |
|       ||   |___ |   |_| ||       |
|      _||    ___||    ___||       |
|     |_ |   |___ |   |    |   _   |
|_______||_______||___|    |__| |__|
```

## tips & Tricks
- when we initialize our Ceph Cluster, only components that is going to exist is our MON
- It is possible to have all of Ceph components in one node 

## Ceph Components
### Ceph monitors (MON)
- track the health of the entire cluster by keeping a map of the cluster state. contains a seperate map for each component which includes an OSD map, MON map, PG map, and CRUSH map. All cluster nodes report to monitor nodes and share information about every change in their state. The monitor does not store actual data; this is the job of OSD

### Ceph Object Storage Device (OSD)
- data saves here in the form of objects

### Ceph Metadata Server (MDS)
- keeps track of file hierarchy and stores metadata only for CephFS filesystem. Ceph block device and RADOS gateway do not require metadata, hence they don not need the Ceph MDS daemon.

### Ceph Manager
- Ceph Manager daemon (ceph-mgr) was introduced in the Kraken release, and it runs alongside monitor daemons to provide additional monitoringn and interfaces to external monitoring and management systems
- Used for external monitoring like prometeus, Zabbix

### RADOS Block Devices (RBDs)
- RBDs, which are now know as Ceph Block Device, provide persistent block storage, which is thin-provisioned, resizable, and stores data striped over multiple OSDs. The RBD service has been built as a native interface on top of librados.

### RADOS gateway interface (RGW)
- provides object storage service. It uses libgrw (Rados Gateway Library) and librados, allowing apps to establish connections with the Ceph Object Storage

## Ceph Storage inside k8s cluster
- Ceph is a software defined storage
 
- File storage: Is like FileSystem (Like NFS), needs formating storage before usage, needs mounting in system. For backup, archiving. Can be shared between multiple systems.
- Block Storage: without formating disk, directly using disk from its ` /dev ` address. needs mounting. Its good for speed but hard for using. DBs usually use it. can be used in programming. Cna be used for VMs. Can not be shared among multiple systems.
- Object Storage: is fast, is API-based, does not need mounting

- CephFS = file Storage
- CephRBD = Block Storage

- In k8s when we create PVC, when we assign type: FS then we can't share it cross multiple nodes. Even if we are using CephRBD
- usually Block Storage usecase is for DBs

## ROOK Ceph
- Rook is an open source cloud-native storage orchestrator, providing the platform, framework, and support for Ceph storage to natively integrate with k8s
- Rook automates deployment and management of Ceph to provide self-managing, self-scaling and self-healing storage services
- Rook operator does this by building on k8s cluster resources to deploy, configure, provision, scale, upgrade and monitor Cephs


## Links

# acknowledgment
## Contributors

APA 🖖🏻


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