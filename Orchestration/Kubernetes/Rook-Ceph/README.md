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

### Step-by-Step Instructions for Setting Up Rook-Ceph on Your RKE2 Cluster

I'll provide a thorough, step-by-step guide based on your requirements. We're using Rook v1.18.7 (the latest stable patch release as of late 2025) with Ceph v19.2.3 (Squid, the default and compatible Ceph version for this Rook release, ensuring stability and integration without misbehavior). This is compatible with your Kubernetes v1.33.2. The setup uses raw devices (/dev/sdd), tolerates master node taints, enables the Ceph dashboard over HTTP (no SSL), sets up a default storage class for your Graylog + OpenSearch + MongoDB setup, and enables Prometheus monitoring. The design is expandable: you can add nodes or devices later by updating the CephCluster CRD, and the cluster will rebalance data automatically without downtime or data loss (Ceph handles replication and healing).

Since your cluster is air-gapped, all steps assume you perform downloads/pulls on a machine with internet access, then transfer files/images to your air-gapped environment and push to your local registry (https://registry.eniac-tech.com/). Use `docker` (or `podman` if preferred) for image handling. I've listed all required images upfront.

#### Prerequisites
- Ensure LVM is installed on all nodes (since you're using raw devices and may expand later): `sudo apt install -y lvm2` (Ubuntu).
- Your raw devices (/dev/sdd) must be unmounted, unformatted, and available on at least 3 nodes (for Ceph quorum and replication). Assume they're present on all 4 nodes.
- Kernel supports RBD (test with `sudo modprobe rbd` on nodes).
- Your cluster has no existing Rook-Ceph (if it does, uninstall first).
- For expansion: Ceph supports adding devices/nodes dynamically. Set replication to 3 for fault tolerance (data survives 2 node failures).
- Resources: Start minimal (e.g., 1-2GB RAM per OSD/Mon), but monitor and scale as needed for your Graylog logs (~100GB+ indices).

#### Step 1: Prepare Images and Manifests for Air-Gapped Environment
On a **connected machine**:
1. Git clone the Rook repository:
   ```
   git clone --single-branch --branch v1.18.7 https://github.com/rook/rook.git
   cd rook
   ```
2. Pull all required images (these are all the containers used by Rook-Ceph, CSI, and toolbox):
   ```
   docker pull rook/ceph:v1.18.7
   docker pull quay.io/ceph/ceph:v19.2.3
   docker pull quay.io/cephcsi/cephcsi:v3.15.0
   docker pull registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.13.0
   docker pull registry.k8s.io/sig-storage/csi-resizer:v1.13.2
   docker pull registry.k8s.io/sig-storage/csi-provisioner:v5.2.0
   docker pull registry.k8s.io/sig-storage/csi-snapshotter:v8.2.1
   docker pull registry.k8s.io/sig-storage/csi-attacher:v4.8.1
   docker pull quay.io/csiaddons/k8s-sidecar:v0.13.0
   ```
3. Tag and push to your local registry (replace `registry.eniac-tech.com` if needed; use a prefix like `rook/` for organization):
   ```
   docker tag rook/ceph:v1.18.7 registry.eniac-tech.com/rook/ceph:v1.18.7
   docker push registry.eniac-tech.com/rook/ceph:v1.18.7
   # Repeat for all images, e.g.:
   docker tag quay.io/ceph/ceph:v19.2.3 registry.eniac-tech.com/ceph/ceph:v19.2.3
   docker push registry.eniac-tech.com/ceph/ceph:v19.2.3
   # And so on for cephcsi, sig-storage/*, csiaddons.
   ```
4. Download Prometheus-related manifests (for monitoring):
   ```
   wget https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.82.0/bundle.yaml
   ```
   - Extract images from `bundle.yaml` (e.g., quay.io/prometheus-operator/prometheus-operator:v0.82.0, quay.io/prometheus/prometheus:v2.59.0 – check the file), pull/tag/push them similarly.
5. Transfer the `rook/` directory, `bundle.yaml`, and any other downloaded files to your air-gapped machine (e.g., via USB/SCP).
6. On the air-gapped machine, ensure your cluster pulls from the local registry by configuring RKE2's containerd mirrors if not already (edit `/etc/rancher/rke2/config.yaml` and restart agents).

#### Step 2: Install the Rook Operator
On your air-gapped cluster master:
1. Create the Rook namespace and common resources:
   ```
   cd rook/deploy/examples
   kubectl create -f common.yaml
   kubectl create -f common-cluster.yaml  # If using a custom namespace, adjust.
   ```
2. Edit `operator.yaml` to use your local registry:
   - Replace all image references (e.g., `image: rook/ceph:v1.18.7` → `image: registry.eniac-tech.com/rook/ceph:v1.18.7`).
   - Add tolerations if needed here, but main tolerations go in the cluster CR.
3. Apply the operator:
   ```
   kubectl create -f operator.yaml
   ```
4. Verify the operator is running (pods in `rook-ceph` namespace):
   ```
   kubectl -n rook-ceph get pods
   ```
   - Wait for `rook-ceph-operator-*` and `rook-discover-*` to be Ready.

#### Step 3: Create the CephCluster
1. Edit `cluster.yaml` (in `deploy/examples`):
   - Set `cephVersion.image: registry.eniac-tech.com/ceph/ceph:v19.2.3`
   - Under `storage`:
     ```
     useAllNodes: false  # Selective to avoid accidental use
     nodes:
       - name: "graylog02.eniac-tech.com"
         devices:
           - name: "sdd"
       - name: "graylog03.eniac-tech.com"
         devices:
           - name: "sdd"
       - name: "graylog04.eniac-tech.com"
         devices:
           - name: "sdd"
       # Optionally add the worker: graylog05.eniac-tech.com for 4 OSDs
     ```
     - This uses /dev/sdd on 3 masters (minimum for quorum). For expansion, add more nodes/devices here later and apply.
   - Under `placement.all` (to tolerate master taints):
     ```
     tolerations:
       - key: node-role.kubernetes.io/master
         operator: Exists
         effect: NoSchedule
       - key: node-role.kubernetes.io/control-plane
         operator: Exists
         effect: NoSchedule
     ```
     - Repeat under `placement.mgr`, `placement.mon`, `placement.osd` if needed for specific services.
   - Set `dashboard.enabled: true`
   - Set `dashboard.ssl: false` (for HTTP)
   - Set `monitoring.enabled: true` (prepares for Prometheus)
   - Set `network.provider: host` (default for RKE2).
   - For expandability: Set `removeOSDsIfOutAndSafeToRemove: true` (allows safe removal later).
2. Apply:
   ```
   kubectl create -f cluster.yaml
   ```
3. Verify (may take 10-20 min):
   ```
   kubectl -n rook-ceph get pods
   ceph -s  # From toolbox, see Step 7
   ```
   - Ensure HEALTH_OK, 3 mons, OSDs up (at least 3).

#### Step 4: Deploy the Ceph Dashboard (HTTP)
The dashboard is enabled in the cluster CR (Step 3).
1. The service `rook-ceph-mgr-dashboard` will use port 7000 for HTTP (since ssl: false).
2. Expose it (e.g., NodePort for access):
   Create `dashboard-service.yaml`:
   ```
   apiVersion: v1
   kind: Service
   metadata:
     name: rook-ceph-dashboard-external
     namespace: rook-ceph
   spec:
     type: NodePort
     ports:
       - port: 7000
         targetPort: 7000
         nodePort: 30000  # Choose an available port
     selector:
       app: rook-ceph-mgr
       rook_cluster: rook-ceph
   ```
   Apply: `kubectl apply -f dashboard-service.yaml`
3. Access: `http://<node-ip>:30000` (username: admin, password from `kubectl -n rook-ceph get secret rook-ceph-dashboard-password -o jsonpath="{['data']['password']}" | base64 -d`).
   - Overview shows cluster health, OSDs, etc. Use for monitoring/expansion.

#### Step 5: Create Default Storage Class for Graylog
1. Create CephBlockPool (replicated for your logs):
   Create `pool.yaml`:
   ```
   apiVersion: ceph.rook.io/v1
   kind: CephBlockPool
   metadata:
     name: replicapool
     namespace: rook-ceph
   spec:
     failureDomain: host
     replicated:
       size: 3  # Replicas for durability
   ```
   Apply: `kubectl apply -f pool.yaml`
2. Create StorageClass:
   Create `storageclass.yaml`:
   ```
   apiVersion: storage.k8s.io/v1
   kind: StorageClass
   metadata:
     name: rook-ceph-block
     annotations:
       storageclass.kubernetes.io/is-default-class: "true"  # Makes it default
   provisioner: rook-ceph.rbd.csi.ceph.com
   parameters:
     clusterID: rook-ceph
     pool: replicapool
     imageFormat: "2"
     imageFeatures: layering,deep-flatten,exclusive-lock,object-map,fast-diff  # For modern kernels
     csi.storage.k8s.io/fstype: ext4
     csi.storage.k8s.io/provisioner-secret-name: rook-csi-rbd-provisioner
     csi.storage.k8s.io/provisioner-secret-namespace: rook-ceph
     csi.storage.k8s.io/controller-expand-secret-name: rook-csi-rbd-provisioner
     csi.storage.k8s.io/controller-expand-secret-namespace: rook-ceph
     csi.storage.k8s.io/node-stage-secret-name: rook-csi-rbd-node
     csi.storage.k8s.io/node-stage-secret-namespace: rook-ceph
   reclaimPolicy: Delete
   allowVolumeExpansion: true
   ```
   - Edit images in related CSI manifests if needed (from rook/deploy/examples/csi/rbd/), push to local reg, apply `csi-rbdplugin-provisioner.yaml` and `csi-rbdplugin.yaml` after editing for local images.
   Apply: `kubectl apply -f storageclass.yaml`
3. Verify: `kubectl get sc` (should show rook-ceph-block as default).

#### Step 6: Enable Prometheus Monitoring
1. Install Prometheus Operator:
   - Edit `bundle.yaml` for local images (replace quay.io/prometheus-operator/* etc.).
   - Apply: `kubectl create -f bundle.yaml`
   - Verify pod: `kubectl get pods -n default` (prometheus-operator).
2. Apply Rook monitoring manifests (from rook/deploy/examples/monitoring/):
   ```
   kubectl create -f rbac.yaml
   kubectl create -f service-monitor.yaml
   kubectl create -f exporter-service-monitor.yaml
   kubectl create -f prometheus.yaml
   kubectl create -f prometheus-service.yaml
   kubectl create -f localrules.yaml  # For alerts
   ```
3. Access Prometheus: Port-forward `kubectl -n rook-ceph port-forward svc/prometheus-rook-prometheus 9090:9090`, browse `http://localhost:9090`.
   - Ceph metrics (e.g., OSD usage) will appear. For Grafana, import dashboards from rook/deploy/examples/monitoring/grafana/.

#### Step 7: Deploy Rook Toolbox and Test
1. Edit `toolbox.yaml` for local image (`rook/ceph:v1.18.7`).
2. Apply: `kubectl apply -f toolbox.yaml`
3. Exec in: `kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- bash`
4. Run `ceph status`, `ceph osd status` to confirm.

#### Step 8: Integrate with Graylog + OpenSearch + MongoDB
1. Update your deployments/PVCs to use `storageClassName: rook-ceph-block` (or omit for default).
2. For migration from NFS: Create new PVCs on Rook, copy data (e.g., via rsync in a temp pod), then switch.
3. Redeploy Graylog stack. Your index strategy (P1D rotation, 1-year prod retention) is handled in Graylog config, not Rook—Rook provides expandable storage.
4. Monitor resources; expand by adding /dev/sdd to more nodes in cluster.yaml and reapplying (Ceph rebalances online).

If issues, check logs: `kubectl -n rook-ceph logs <pod>`. For future expansion, add HDDs as new devices in cluster.yaml—no data loss.

# acknowledgment
## Contributors
APA 🖖🏻

## Links

## APA, Live long & prosper 🖖
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