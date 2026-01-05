# ROOK-CEPH
```
 ______    _______  _______  ___   _         _______  _______  _______  __   __ 
|    _ |  |       ||       ||   | | |       |       ||       ||       ||  | |  |
|   | ||  |   _   ||   _   ||   |_| | ____  |       ||    ___||    _  ||  |_|  |
|   |_||_ |  | |  ||  | |  ||      _||____| |       ||   |___ |   |_| ||       |
|    __  ||  |_|  ||  |_|  ||     |_        |      _||    ___||    ___||       |
|   |  | ||       ||       ||    _  |       |     |_ |   |___ |   |    |   _   |
|___|  |_||_______||_______||___| |_|       |_______||_______||___|    |__| |__|
```
## What I have
- I have an rke2 cluster (without UI Dashboard). I want this cluster for a dedicated logging setup with Graylog and OpenSearch. for reference:
```
NAME                       STATUS   ROLES                       AGE    VERSION       
graylog02.eniac-tech.com   Ready    control-plane,etcd,master   144d   v1.33.2+rke2r1
graylog03.eniac-tech.com   Ready    control-plane,etcd,master   144d   v1.33.2+rke2r1
graylog04.eniac-tech.com   Ready    control-plane,etcd,master   144d   v1.33.2+rke2r1
graylog05.eniac-tech.com   Ready    <none>                      144d   v1.33.2+rke2r1
```

- I deployed my Graylog + OpenSearch + mongodb with NFS storage class as test. Now I want to make this architecture operational using Rook-Ceph as my default storage class
- I have RAW devices on my ubuntu servers /dev/sdd . unmounted, no filesystem
- A reference for my current test setup (Note that this is logs of 80% of my production, stage/dev enviornments are not added to graylog yet):
```
$ curl -X GET "localhost:31101/_cat/indices/graylog_*?h=index,docs.count,store.size,pri,rep&s=index"
graylog_60 31782438  6.3gb 1 0
graylog_61 37114675  9.2gb 1 0
graylog_62 41451445 10.4gb 1 0
graylog_63 42278359 15.8gb 1 0
graylog_64 16773819 15.4gb 1 0
graylog_65 18172278 15.6gb 1 0
graylog_66 20367832   18gb 1 0
graylog_67  9634847  8.6gb 1 0
```

- (My plan for future) My Index rotation strategy:Index Time & Rotation period: P1D, 1 day, a day. I want to keep my production logs for 1 year, and my stage/development logs for 1 week
- Although it is not best practice to do so, but I want to tolerate taints of my master nodes, so i can deploy my Rook-ceph cluster (I only have 4 nodes, i think i need 3 nodes for my rook-ceph, am i right?)
- my RKE2 cluster is air-gapped. So everything I want (Including helm charts & docker or quay images & CSI sidecars & Prerequisites & maybe even Rook-toolbox ), must be downloaded/pulled first and pushed to my organizations local Image/Artifact repository with address https://registry.eniac-tech.com/
- IMPORTANT: I want to use a stabel, compatible version for all componenets of my Rook-Ceph, be cautious to give me image versions that are well-integrated together, so there is no Misbehaviour
- I don't have lots of resources to add to my cluster HDD right now. But I can extend it in future. Give me a solution that is expandabale in future without data loss & cluster can remain operational during this process


## What I want
- give me step-by-step thourough instruction on how to make my Rook-Ceph cluster up and running + deploy Rook-ceph's UI Dashboard without using SSL (http) +  define Default storage class for my Graylog setup + Enable Prometheus in Rook

## Prerqusisits
- If integrating Rook Ceph (as mentioned in your prior query), ensure nodes have raw SSDs, RBD module loaded, and lvm2 installed for advanced features. Test in staging before production. For custom setups, consult RKE2 config reference.

### Overview of Recommendations
Your 4-node RKE2 cluster (3 control-plane/master/etcd nodes and 1 worker) is well-suited for a dedicated logging setup with Graylog and OpenSearch, given its HA configuration and Ubuntu base. With 20 GB of daily logs and a 1-year retention goal, focus on efficient storage, high availability, and automated retention policies to manage costs and performance. This is a relatively low ingest rate (roughly 200-500 events per second, assuming average log sizes of 500-1KB), so you don't need massive scaling—aim for simplicity and reliability.

Key assumptions:
- Your nodes have sufficient CPU/RAM (recommend at least 8-16 cores and 32-64 GB RAM per node for production; verify with `kubectl top nodes` or `htop` on hosts).
- Extra disks are available for storage (e.g., SSDs for performance); use the earlier script's `lsblk` output to confirm raw devices.
- Logs compress well (common in OpenSearch), but plan conservatively for indexing overhead.

I'll break down storage sizing, cluster configuration, deployment steps, and best practices.

### Storage Sizing and Requirements
For 20 GB/day over 1 year:
- **Raw data estimate**: 20 GB × 365 days = 7.3 TB.
- **OpenSearch overhead**: Indexing adds 20-50% more space due to metadata and analysis. Compression (built-in) can reduce this by 30-70%, but net size is often 1-2× raw. Conservative planning: 10-15 TB for primary data.
- **Replication**: For HA, use 1 replica (2 copies total), doubling to 20-30 TB.
- **Additional buffers**: 10% for overhead (e.g., snapshots, logs), plus 20% free space for OpenSearch to avoid write blocks. Total recommended: 25-40 TB across the cluster.
- **Shard sizing**: Aim for 20-50 GB per shard (Graylog/OpenSearch sweet spot for performance). With daily indices, this means rolling over indices every 1-2 days.
- **Disk types**: Use SSDs for OpenSearch data paths (low latency, high IOPS). Avoid HDDs for hot data. If using Rook Ceph, dedicate raw disks (no filesystem) for OSDs.

If your logs are highly compressible (e.g., text-heavy), you might get away with 15-20 TB total. Test with a sample ingest. For cost savings, tier storage: hot (recent logs) on fast SSDs, warm/cold (older) on cheaper HDDs via OpenSearch's Index State Management (ISM).

### Recommended Storage Solution: Rook Ceph Integration
Since you mentioned Rook Ceph, it's ideal for this setup—provides distributed block storage for OpenSearch PVs, with built-in replication and snapshots. It fits RKE2 well and handles your scale without external dependencies.

- **Why Rook Ceph?** Self-healing, scales with nodes, supports replication for HA. For logging, use block devices (RBD) for OpenSearch data volumes. Avoid local storage to prevent data loss on node failures.
- **Configuration Suggestions**:
  - **CephCluster CR**: Deploy a single Ceph cluster across all 4 nodes. Set replication factor to 3 (min for HA; needs at least 3 nodes). Example YAML snippet (apply after installing Rook operator):
    ```yaml
    apiVersion: ceph.rook.io/v1
    kind: CephCluster
    metadata:
      name: rook-ceph
      namespace: rook-ceph
    spec:
      cephVersion:
        image: quay.io/ceph/ceph:v18.2.2  # Latest stable
      mon:
        count: 3  # On your 3 control-plane nodes
      storage:
        useAllNodes: true
        useAllDevices: false  # Select specific devices
        deviceFilter: ^sd[b-z]  # e.g., use /dev/sdb, etc.; check lsblk
      network:
        provider: host  # Use host networking for performance
      healthCheck:
        daemonHealth:
          mon:
            interval: 10s
      ```
    Tune via Ceph CLI from Rook toolbox pod (e.g., `ceph config set global osd_pool_default_size 3`).
  - **Block Pool and StorageClass**: Create a replicated pool for OpenSearch PVs.
    ```yaml
    apiVersion: ceph.rook.io/v1
    kind: CephBlockPool
    metadata:
      name: logging-pool
      namespace: rook-ceph
    spec:
      failureDomain: host
      replicated:
        size: 3
    ---
    apiVersion: storage.k8s.io/v1
    kind: StorageClass
    metadata:
      name: ceph-rbd
    provisioner: rook-ceph.rbd.csi.ceph.com
    parameters:
      pool: logging-pool
      csi.storage.k8s.io/provisioner-secret-name: rook-csi-rbd-provisioner
      csi.storage.k8s.io/provisioner-secret-namespace: rook-ceph
    reclaimPolicy: Retain
    ```
  - **Raw Capacity Needed**: For 25-40 TB usable, provide 75-120 TB raw disks (with replication 3). Spread across nodes (e.g., 20-30 TB per node). Monitor with Ceph Dashboard.
- **Installation Steps**:
  1. Install Rook operator: `helm install rook-ceph rook-release/rook-ceph -n rook-ceph --create-namespace`.
  2. Apply CephCluster CR.
  3. Verify: `kubectl get cephcluster -n rook-ceph`.
  4. Enable RBD kernel module if needed (check with script).

### Graylog + OpenSearch Deployment
Deploy as StatefulSets for persistence. Use operators for ease.

- **OpenSearch Cluster**:
  - **Nodes**: 3 data nodes (on graylog02-04) for HA; use graylog05 as coordinating/ingest node. Set master-eligible on 3 nodes.
  - **Resources**: 4-8 vCPU, 16-32 GB RAM per data node (heap: 8-16 GB). PV size: 8-15 TB per node (using ceph-rbd StorageClass).
  - **Install**: Use OpenSearch Kubernetes Operator (helm: `opensearch-operator`). Example StatefulSet config: Set `OPENSEARCH_JAVA_OPTS="-Xms8g -Xmx8g"`.
  - **Retention**: Use ISM policies to rollover indices daily (e.g., after 20 GB), transition to warm after 30 days, delete after 365 days. Example policy:
    ```json
    {
      "policy_id": "log_retention",
      "description": "1-year log retention",
      "states": [
        {"name": "hot", "actions": [{"rollover": {"min_size": "20gb"}}]},
        {"name": "delete", "actions": [{"delete": {}}], "transitions": [{"min_index_age": "365d"}]}
      ]
    }
    ```
- **Graylog**:
  - **Nodes**: 2-3 replicas for HA (stateless-ish, but use MongoDB for config). Resources: 4 vCPU, 16 GB RAM per pod.
  - **Install**: Helm chart or Deployment. Connect to OpenSearch via env var `GRAYLOG_ELASTICSEARCH_HOSTS`. Use MongoDB (single pod or replicaSet) with small PV (1-5 GB).
  - **Inputs**: Configure for your log sources (e.g., Fluent Bit from other clusters).
- **RKE2-Specific Tweaks**: Ensure Canal CNI allows Ceph traffic (default OK). Use hostPath or extra mounts if needed, but prefer Ceph PVs.

### Best Practices and Monitoring
- **HA and Scaling**: Label nodes (e.g., `kubectl label node graylog05 role=ingest`). Start small, scale OpenSearch replicas if ingest grows.
- **Backups**: Enable OpenSearch snapshots to S3-compatible (or Ceph Object Gateway). Daily backups with 7-day retention.
- **Monitoring**: Install Prometheus + Grafana; monitor Ceph with Rook's exporter, OpenSearch metrics (heap, shards). Alerts for >80% disk usage.
- **Testing**: Ingest sample logs, verify retention with ISM. Upgrade RKE2 carefully (sequential nodes).
- **Alternatives if Ceph Overkill**: Use Longhorn for simpler distributed storage, or NFS if no HA needed.

This setup should handle your needs reliably. If you share node hardware specs or `lsblk` output, I can refine further.


### Rook Ceph Extensibility for Storage Expansion

Yes, Rook Ceph is highly extendable for future growth, which aligns well with your situation of limited current resources but plans to add more later. Ceph (the underlying storage system) is designed for scalability, allowing both horizontal expansion (adding more nodes, devices, or OSDs) and, to a degree, vertical expansion (resizing existing devices). Since your setup appears to involve raw devices (e.g., /dev/sdd as a 1 TB SSD, likely a virtual disk in vCenter), resizing an existing disk is possible, but it requires specific steps to ensure the change is recognized without data loss. The cluster can remain operational during this process if you have sufficient redundancy (e.g., replication factor of 3 across your 4 nodes), though the affected OSD will temporarily go offline.

I'll break this down based on reliable sources from Rook's documentation, community discussions, and practical guides. Note that while "online" expansion is supported with minimal downtime, it's not fully zero-downtime for the resized OSD—expect a brief outage for that component while the rest of the cluster handles traffic.

#### Key Concepts for Expansion in Rook Ceph
- **Horizontal Scaling (Easiest and Recommended for Future Growth)**: This is the primary way to extend storage without touching existing devices. You can:
  - Add new raw devices (e.g., attach another SSD via vCenter) to existing nodes and let Rook automatically provision new OSDs (Object Storage Daemons).
  - Add more nodes to the cluster and include their storage devices in the CephCluster CR (Custom Resource).
  - Increase OSD count in your CephCluster spec (e.g., add more `deviceSets` or set `useAllDevices: true` with filters).
  This is non-disruptive and can be done while the cluster is running, as Ceph rebalances data automatically.

- **Vertical Scaling (Resizing Existing Devices like Your 1 TB /dev/sdd)**: This is feasible for raw devices in a vCenter/VMware environment, but it's more involved than horizontal scaling. Ceph uses BlueStore (default backend) for OSDs, which supports device expansion. However, the OSD won't automatically detect the change without intervention. If your OSDs are on PVCs (e.g., if using vSphere CSI), it's even simpler with auto-grow scripts, but based on your description ("sdd storage under rookCeph provisioning"), I'll assume raw devices.

#### Steps to Resize an Existing Disk (e.g., from 1 TB to 2 TB) While the Cluster is Running
The process involves extending the virtual disk in vCenter, rescanning in the VM, and then making Rook/Ceph recognize the new size. There are two main approaches: a simple restart-based method (faster but may not always fully reclaim space) or a full remove/re-add method (more reliable for raw devices, with temporary OSD outage). Do this one node/OSD at a time to maintain cluster availability.

1. **Extend the Virtual Disk in vCenter**:
   - Edit the VM settings for the node (e.g., graylog02).
   - Increase the size of the hard disk corresponding to /dev/sdd (from 1 TB to 2 TB). This can often be done hot (online) for SCSI disks in VMware, without powering off the VM.
   - Save changes.

2. **Rescan the Device in the VM**:
   - SSH into the node or use `kubectl debug` (as in your earlier script).
   - Rescan the block device to make the OS see the new size:
     ```
     echo 1 > /sys/class/block/sdd/device/rescan
     ```
   - Verify with `lsblk` or `fdisk -l /dev/sdd`—the size should now show 2 TB.

3. **Make Rook Ceph Recognize the New Size**:
   - **Option 1: Simple Pod Restart (Lower Downtime, for Raw Devices)**:
     - The OSD pod includes an init container that runs `ceph-bluestore-tool bluefs-bdev-expand` to expand BlueStore.
     - Delete the OSD pod to force a restart (replace `osd-id` with your actual OSD number, e.g., from `ceph osd ls`):
       ```
       kubectl -n rook-ceph delete pod rook-ceph-osd-<osd-id>
       ```
     - Rook will recreate the pod, detect the larger device, and update the capacity. Monitor with `ceph osd df` or `ceph -s`.
     - Downtime: ~1-5 minutes per OSD for rebalancing; cluster stays up if you have replicas.
     - Caveat: In some cases, the "used" space may increase instead of "available," requiring further troubleshooting (e.g., manual BlueStore repair).

   - **Option 2: Full OSD Remove and Re-Add (More Reliable, Higher Temporary Impact)**:
     - This ensures a clean expansion, especially if the simple restart doesn't fully work.
     - Scale down the Rook operator temporarily:
       ```
       kubectl -n rook-ceph scale deployment rook-ceph-operator --replicas=0
       ```
     - Delete the OSD deployment(s) for the affected disk(s):
       ```
       kubectl -n rook-ceph delete deployment rook-ceph-osd-<osd-id>
       ```
     - Mark the OSD out and remove it from Ceph (run from Rook toolbox pod, e.g., `kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- bash`):
       ```
       ceph osd out <osd-id>
       ceph osd crush remove osd.<osd-id>
       ceph auth del osd.<osd-id>
       ceph osd down osd.<osd-id>
       ceph osd rm osd.<osd-id>
       ```
     - Wait for rebalancing (`ceph -w` until PGs are `active+clean`).
     - Wipe the extended device (to clear old data):
       ```
       sgdisk --zap-all /dev/sdd
       dd if=/dev/zero of=/dev/sdd bs=1M count=100 oflag=direct,dsync
       partprobe /dev/sdd
       ```
     - Scale up the operator:
       ```
       kubectl -n rook-ceph scale deployment rook-ceph-operator --replicas=1
       ```
     - Rook will auto-provision a new OSD on the larger device. Verify with `ceph osd df tree`.
     - Downtime: 10-30+ minutes per OSD (depending on data size and rebalancing); do one at a time.

4. **Post-Expansion Verification**:
   - Check cluster health: `ceph -s` (should return `HEALTH_OK`).
   - Monitor storage: `ceph df` or Ceph Dashboard.
   - If using PVC-based OSDs (not raw), Rook provides an auto-grow script for easier handling—edit your CephCluster to enable it if applicable.

#### Considerations and Best Practices
- **Downtime and Risks**: The cluster remains "up and running" overall, but expect temporary reduced capacity during rebalancing. With your 4-node setup and replication=3, it should handle one OSD offline without issues. Test in a non-prod environment first.
- **If Using LVM**: Extra steps like `lvextend` may be needed before rescanning; avoid if possible, as raw mode is simpler for expansion.
- **Alternatives if Resizing is Too Risky**: Prioritize adding new disks/nodes for growth—it's less disruptive. If your logs grow beyond current capacity, consider offloading cold data to cheaper external storage (e.g., S3 via Ceph Object Gateway).
- **Resources**: Your current 4-node RKE2 cluster is sufficient for starting small. Monitor disk usage with Prometheus and plan expansions proactively.

If you share more details (e.g., `lsblk` output from nodes or your CephCluster YAML), I can refine this further. Always back up critical data before changes!

# acknowledgment
## Contributors
APA 🖖🏻

## Links


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