Deploying a 3-master High-Availability (HA) RKE2 cluster in an air-gapped environment requires a bit of prep work, as we have to manually provide all the binaries and container images that the installation script would normally pull from the internet.

Here is your complete, step-by-step guide to getting this architecture deployed on your Ubuntu servers.

---

### **Phase 1: Download Artifacts (Internet-Connected Machine)**

First, you need to download the necessary files from the [RKE2 GitHub Releases page](https://github.com/rancher/rke2/releases). Choose the latest stable release (e.g., `v1.30.x+rke2r1`).

Create a folder named `rke2-artifacts` on your local machine and download the following into it:

1. **The Installation Script:** `curl -sfL https://get.rke2.io -o install.sh`
2. **The RKE2 Binary:** `rke2.linux-amd64.tar.gz`
3. **The Core Images:** `rke2-images.linux-amd64.tar.zst` (Zstandard compression is the modern default and loads faster).
4. **The Checksum File:** `sha256sum-amd64.txt`

---

### **Phase 2: Prepare the Air-Gapped Ubuntu Servers**

Transfer the `rke2-artifacts` folder to all three of your Ubuntu master nodes (e.g., using a USB drive or SCP over an internal network). Place the folder in a known directory, such as `/root/rke2-artifacts`.

On **all three nodes**, perform the following base system preparations:

**1. Open Required Ports**
If you are using UFW (Ubuntu's default firewall), you must open the necessary ports for master nodes to communicate:

```bash
sudo ufw allow 6443/tcp   # Kubernetes API
sudo ufw allow 9345/tcp   # RKE2 Registration/Supervisor API
sudo ufw allow 2379:2381/tcp # etcd client/peer/metrics
sudo ufw allow 10250/tcp  # Kubelet metrics
sudo ufw allow 8472/udp   # Canal CNI VXLAN
sudo ufw allow 30000:32767/tcp # NodePort range

```

**2. Place the Images in the Agent Directory**
RKE2 will automatically load images upon startup if they are placed in a specific directory.

```bash
sudo mkdir -p /var/lib/rancher/rke2/agent/images/
sudo cp /root/rke2-artifacts/rke2-images.linux-amd64.tar.zst /var/lib/rancher/rke2/agent/images/

```

---

### **Phase 3: Deploy Master Node 1 (The Initializer)**

We must start the first node entirely on its own to initialize the `etcd` database before the other nodes can join.

**1. Create the Configuration File**

```bash
sudo mkdir -p /etc/rancher/rke2
sudo nano /etc/rancher/rke2/config.yaml

```

Paste the following configuration. Replace the IP addresses with your actual server IPs, and choose a strong, secure string for the token.

```yaml
token: "your-super-secret-cluster-token"
tls-san:
  - "<load-balancer-dns-or-ip>" # If you have a front-facing Load Balancer
  - "<node1-ip>"
  - "<node2-ip>"
  - "<node3-ip>"

```

> **Note:** The `tls-san` array ensures that the Kubernetes API server certificates are valid for all node IPs and any load balancers you might put in front of them later.

**2. Install and Start RKE2**
Run the install script, pointing it to your offline artifacts:

```bash
cd /root/rke2-artifacts
sudo chmod +x install.sh
sudo INSTALL_RKE2_ARTIFACT_PATH=$(pwd) sh install.sh

```

Enable and start the service. (This will take a few minutes as it unpacks the `.zst` images and initializes etcd).

```bash
sudo systemctl enable rke2-server.service
sudo systemctl start rke2-server.service

```

---

### **Phase 4: Deploy Master Nodes 2 & 3 (The Joiners)**

Once Master 1 is fully active (you can verify by running `sudo journalctl -u rke2-server -f` on Node 1 and watching for "Node controller sync successful"), proceed to Nodes 2 and 3.

**1. Create the Configuration File**

```bash
sudo mkdir -p /etc/rancher/rke2
sudo nano /etc/rancher/rke2/config.yaml

```

The configuration here requires the `server` parameter so these nodes know they are joining an existing cluster, rather than starting a new one.

```yaml
server: "https://<node1-ip>:9345"
token: "your-super-secret-cluster-token" # Must match Node 1 exactly
tls-san:
  - "<load-balancer-dns-or-ip>"
  - "<node1-ip>"
  - "<node2-ip>"
  - "<node3-ip>"

```

**2. Install and Start RKE2**
Run the exact same installation command on Nodes 2 and 3:

```bash
cd /root/rke2-artifacts
sudo chmod +x install.sh
sudo INSTALL_RKE2_ARTIFACT_PATH=$(pwd) sh install.sh

sudo systemctl enable rke2-server.service
sudo systemctl start rke2-server.service

```

---

### **Phase 5: Verification & Access**

RKE2 installs `kubectl` automatically, but you need to set up your environment to use it. Run this on any of your master nodes to easily interact with your cluster:

```bash
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
export PATH=$PATH:/var/lib/rancher/rke2/bin

kubectl get nodes

```

You should see all three nodes listed with the `Ready` status and the `control-plane,etcd,master` roles.

Since you are running this entirely on master nodes with no dedicated workers, workloads will schedule directly onto these three machines. Will you be placing a TCP Load Balancer (like HAProxy or NGINX) in front of these three nodes to route external API requests (`TCP 6443`), or are you planning to access the cluster directly via their individual IPs?