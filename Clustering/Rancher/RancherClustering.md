# Rancher-Clustering
```
  _____                  _                       _____ _           _            _             
 |  __ \                | |                     / ____| |         | |          (_)            
 | |__) |__ _ _ __   ___| |__   ___ _ __ ______| |    | |_   _ ___| |_ ___ _ __ _ _ __   __ _ 
 |  _  // _` | '_ \ / __| '_ \ / _ \ '__|______| |    | | | | / __| __/ _ \ '__| | '_ \ / _` |
 | | \ \ (_| | | | | (__| | | |  __/ |         | |____| | |_| \__ \ ||  __/ |  | | | | | (_| |
 |_|  \_\__,_|_| |_|\___|_| |_|\___|_|          \_____|_|\__,_|___/\__\___|_|  |_|_| |_|\__, |
                                                                                         __/ |
                                                                                        |___/ 
```

## Tips & Tricks
- RAncher can be run on anything, K8s cluster, dedicated VM, on Prem machine, Outside of k8s infra.
- As long as Rancher can reach IP Addresses of machines that are k8s nodes, You are good to go.
- Rancher is source of truths for k8s cluster, so make sure its HA + Its Data is persistent
- By default, certificates in RKE2 expire in 12 months. If the certificates are expired or have fewer than 90 days remaining before they expire, the certificates are rotated when RKE2 is restarted.
- 

## Requirements
- Hardware requirementes: https://docs.rke2.io/install/requirements
- Supported Kubernetes Platforms for Rancher Manager: https://www.suse.com/suse-rancher/support-matrix/all-supported-versions/rancher-v2-7-9/

## Implementation
- Note that some tools, such as kubectl, are installed by default into ```/var/lib/rancher/rke2/bin```
- Leverage the KUBECONFIG environment variable:
```
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
kubectl get pods --all-namespaces
helm ls --all-namespaces
```
- Accessing the Cluster from Outside with kubectl: Copy ```/etc/rancher/rke2/rke2.yaml``` on your machine located outside the cluster as ```~/.kube/config``` Then replace 127.0.0.1 with the IP or hostname of your RKE2 server. kubectl can now manage your RKE2 cluster.

# Starting the Server with the Installation Script
The installation script provides units for systemd, but does not enable or start the service by default.

When running with systemd, logs will be created in /var/log/syslog and viewed using journalctl -u rke2-server or journalctl -u rke2-agent.

An example of installing with the install script:
```
curl -sfL https://get.rke2.io | sh -
systemctl enable rke2-server
systemctl start rke2-server
```

## Creating Snapshots
- ```/var/lib/rancher/rke2/server/db/snapshots``` --> The snapshot directory defaults
- In RKE2, snapshots are stored on each etcd node. If you have multiple etcd or etcd + control-plane nodes, you will have multiple copies of local etcd snapshots.
- You can take a snapshot manually while RKE2 is running with the etcd-snapshot subcommand. For example: ```$ rke2 etcd-snapshot save --name pre-upgrade-snapshot```
- By default, Rancher snapshots every 12 hours
- You can list local snapshots with the ```$ etcd-snapshot ls```

## Automatically Deploying Manifests and Helm Charts
- Any Kubernetes manifests found in ```/var/lib/rancher/rke2/server/manifests``` will automatically be deployed to RKE2 in a manner similar to ```$ kubectl apply```
- Manifests deployed in this manner are managed as AddOn custom resources, and can be viewed by running ```$ kubectl get addon -A```
- You will find AddOns for packaged components such as CoreDNS, Nginx-Ingress, etc. AddOns are created automatically by the deploy controller, and are named based on their filename in the manifests directory.

# acknowledgment
## Contributors

APA 🖖🏻

## Links
- Architecture Recommendations:
 https://ranchermanager.docs.rancher.com/reference-guides/rancher-manager-architecture/architecture-recommendations#environment-for-kubernetes-installations
- Setting up a High-availability RKE2 Kubernetes Cluster for Rancher: https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/kubernetes-cluster-setup/rke2-for-rancher
---
- RKE2 High Availability Pre-Deployment & Installation Guide: https://docs.expertflow.com/cx/4.3/rke2-high-availability-pre-deployment-installati-1
---
- Teraform:
- rancher2_cluster_v2 Resource: https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster_v2
- terraform-vsphere-rke2: https://gricad-gitlab.univ-grenoble-alpes.fr/kubernetes-alpes/terraform-vsphere-rke2
---
- Introduction to Rancher: On-prem Kubernetes: https://github.com/marcel-dempers/docker-development-youtube-series/tree/master/kubernetes/rancher
- Title: Setting Up an On-Premises Rancher Cluster with k3s, Helm and Hyper-V Manager(2023): https://medium.com/@saadullahkhanwarsi/title-setting-up-an-on-premise-k3s-cluster-with-rancher-helm-and-hyper-v-manager-cc888edb178c
- Setup local kubernetes multi-node cluster with Rancher Server (2019): https://kwonghung-yip.medium.com/setup-local-kubernetes-multi-node-cluster-with-rancher-server-fdb7a0669b5c
- Setup Kubernetes cluster using Rancher 2.x (2019): https://medium.com/@torkashvand/https-medium-com-setup-kubernetes-cluster-using-rancher-2-x-a70f004de0f5




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
