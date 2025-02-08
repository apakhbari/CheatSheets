# Kubernetes Course
```
 ___   _   _____   _______ 
|   | | | |  _  | |       |
|   |_| | | |_| | |  _____|
|      _||   _   || |_____ 
|     |_ |  | |  ||_____  |
|    _  ||  |_|  | _____| |
|___| |_||_______||_______|
```

# Table of contents
- Tips & Tricks
- Directories
- Ports
- Commands
- Kubernetes Course
- Advanced Kubernetes Course

## Tips & Tricks
## Directories
## Ports
## Commands

# Kubernetes Course
# Sessions
## Session 1
## Session 2
```
https://gist.github.com/ishad0w/788555191c7037e249a439542c53e170#file-sources-list
=====
containerd config default | tee /etc/containerd/config.toml
=============
https://github.com/containernetworking/plugins/
=================
https://github.com/containernetworking/plugins/releases/download/v1.4.1/cni-plugins-linux-amd64-v1.4.1.tgz
=========
plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc
============
SystemdCgroup = true
================
# sysctl params required by setup, params persist across rebootscat <<EOF | sudo tee /etc/sysctl.d/k8s.confnet.ipv4.ip_forward = 1EOF# Apply sysctl params without rebootsudo sysctl --system
=============
https://kubernetes.io/releases/
===========
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
==================
apt install kubelet=1.27.12-1.1 kubeadm=1.27.12-1.1 kubectl=1.27.12-1.1 -y
==================
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system
=====
https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart
=======
kubectl label node worker2 kubernetes.io/role=worker-2-B
=========
kubectl get node 
kubectl get ns
kubectl get pod
kubectl get pod -o wide
kubectl get pod -n kube-system
===========
kubeadm token list
kubeadm token create --print-join-command --ttl 2h
==============
source <(kubectl completion bash) --> kubectl auto complete
echo 'source <(kubectl completion bash)' >> ~/.bashrc
===========
kubectl version
kubeadm version
kubectl cluster-info
/opt/cni/bin => network driver
=================
https://github.com/containerd/nerdctl
===========
https://github.com/containerd/nerdctl/blob/main/docs/command-reference.md
==========
https://github.com/containerd/nerdctl/releases/download/v1.7.6/nerdctl-full-1.7.6-linux-amd64.tar.gz
===========
server = "https://registry-1.docker.io"
host."https://registry.dokcer.ir".capabilities = ["pull", "resolve"]
========
plugins."io.containerd.grpc.v1.cri".registry
========

```

## Session 3
```
kubectl -n kube-system exec -it etcd-master1 -- etcdctl get / --cert="/etc/kubernetes/pki/etcd/server.crt" --cacert="/etc/kubernetes/pki/etcd/ca.crt" --key="/etc/kubernetes/pki/etcd/server.key" --prefix --keys-only
======
```


## Session 4
## Session 5
## Session 6
## Session 7
## Session 8
## Session 9
## Session 10
## Session 11
## Session 12


# Advanced Kubernetes Course
# Sessions
## Session 1
## Session 2
- Master node resources:

  - Minimum: 8 GB Ram + 4 core CPU
  - on average: 16 GB Ram + 12 core CPU

- Worker node resources:
  - Minimum: 16 GB Ram + 16 core CPU
## Session 3
## Session 4
## Session 5
## Session 6
## Session 7
## Session 8
## Session 9
## Session 10
## Session 11
## Session 12

# Session2 - HA Master Nodes

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
