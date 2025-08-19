# Ceph

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

## ROOK Ceph
- Rook is an open source cloud-native storage orchestrator, providing the platform, framework, and support for Ceph storage to natively integrate with k8s
- Rook automates deployment and management of Ceph to provide self-managing, self-scaling and self-healing storage services
- Rook operator does this by building on k8s cluster resources to deploy, configure, provision, scale, upgrade and monitor Cephs