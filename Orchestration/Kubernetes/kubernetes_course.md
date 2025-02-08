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
```
kubectl get all --all-namespaces
======
kubectl create -f pod.yaml
kubectl describe pod nginx-pod
===
apiVersion: v1
kind: Pod
metadata:
  name: pod-nginx
  labels:
    app: nginx
    type: frontend
spec:
  containers:
    - name: nginx-container
      image: nginx:1.21
======
apiVersion: v1
kind: Pod
metadata:
  name: pod-nginx
  labels:
    app: nginx
    type: frontend
spec:
  containers:
    - name: nginx-container
      image: nginx:1.20
  restartPolicy: Never
  ====
  nerdcl -n k8s.io kill <container_name>
  ========
  kubectl delete -f  "path/name.yaml"
  ====
  kubectl edit pod <pod_name>
  ====
kubectl run nginx-pod --image nginx:1.21
===
kubectl get pod nginx-pod -o yaml > pod-nginx.yaml
 ====== 
 apiVersion: v1
kind: Pod
metadata:
  name: pod-nginx
  labels:
    app: nginx
    type: frontend
spec:
  containers:
    - name: nginx-container
      image: nginx:1.20
      imagePullPolicy: Never
=======
kubectl run nginx-pod  --image nginx:1.21
====
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-replicaset
  labels:
    app: nginx
    type: frontend
spec:
  replicas: 5
  selector:
    matchLabels:
        course: kubernetes
  template:
    metadata: 
      labels:
        anisa: devops
        course: kubernetes
    spec:    
      containers:
        - name: nginx-container
          image: nginx:1.21     
====kubectl get all --all-namespaces
======
kubectl create -f pod.yaml
kubectl describe pod nginx-pod
===
apiVersion: v1
kind: Pod
metadata:
  name: pod-nginx
  labels:
    app: nginx
    type: frontend
spec:
  containers:
    - name: nginx-container
      image: nginx:1.21
======
apiVersion: v1
kind: Pod
metadata:
  name: pod-nginx
  labels:
    app: nginx
    type: frontend
spec:
  containers:
    - name: nginx-container
      image: nginx:1.20
  restartPolicy: Never
  ====
  nerdcl -n k8s.io kill <container_name>
  ========
  kubectl delete -f  "path/name.yaml"
  ====
  kubectl edit pod <pod_name>
  ====
kubectl run nginx-pod --image nginx:1.21
===
kubectl get pod nginx-pod -o yaml > pod-nginx.yaml
 ====== 
 apiVersion: v1
kind: Pod
metadata:
  name: pod-nginx
  labels:
    app: nginx
    type: frontend
spec:
  containers:
    - name: nginx-container
      image: nginx:1.20
      imagePullPolicy: Never
=======
kubectl run nginx-pod  --image nginx:1.21
====
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-replicaset
  labels:
    app: nginx
    type: frontend
spec:
  replicas: 5
  selector:
    matchLabels:
        course: kubernetes
  template:
    metadata: 
      labels:
        anisa: devops
        course: kubernetes
    spec:    
      containers:
        - name: nginx-container
          image: nginx:1.21     
====
```

## Session 5
```
apiVersion: apps/v1
kind: v
metadata:
  name: nginx-deployment
  labels:
    app: nginx-anisa
spec:   
  replicas: 6
  selector: 
    matchLabels:
      anisa: kubernetes
  template: 
    metadata:
      labels:
        anisa: kubernetes
    spec:
      containers:
        - name: nginx-container
          image: docker.arvancloud.ir/nginx:1.21  ====
kubectl config set-context kubernetes-admin@kubernetes --namespace=dev
====
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: dev
  labels:
    app: nginx-anisa
spec:   
  replicas: 6
  selector: 
    matchLabels:
      anisa: kubernetes
  template: 
    metadata:
      labels:
        anisa: kubernetes
    spec:
      containers:
        - name: nginx-container
          image: docker.arvancloud.ir/nginx:1.21  
          resources:
            requests:
              cpu: "10m"
              memory: "10M"
            limits:
              cpu: "2"
              memory: "512M" 
==========
apiVersion: v1
kind: ResourceQuota
metadata:
  name: dev-quota
  namespace: dev 
spec:
  hard: 
    pods: "10"
    count/deployments.apps: "2"
    cpu: "100m"
    memory: "100M"
    =====
    apiVersion: v1
kind: Service
metadata:
  name: nginx
  namespace: dev
spec:
  type: NodePort
  ports:
    - targetPort: 80
      port: 8080
          nodePort: 31457
  selector:
    app: nginx
====
```

## Session 6 (7 on classes)
```

apiVersion: v1
kind: Service
metadata:
  name: nginx-internal
  namespace: dev
spec:
  type: ClusterIP
  ports:
    - targetPort: 80
      port: 8080
  selector:
    app: nginx
====
kubectl -n default run debugger --image alpine --command -- sleep infinity
====
alpine: apk add curl
=====
curl http://nginx-internal.dev.svc.cluster.local:8080
curl http://nginx-internal.dev:8080
==========
apiVersion: v1
kind: Service
metadata:
  name: nginx
  namespace: dev
spec:
  type: LoadBalancer
  ports:
    - targetPort: 80
      port: 8080
  selector:
    app: nginx
=======
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
  nodeName: master1
====
Label and selector:
kubectl get node --show-labels
kubectl get pod --show-labels
kubectl get deployment --show-labels
kubectl get pod --selector app=nginx -o wide
========
kubectl create deployment web-server --image docker.arvancloud.ir/nginx:1.21 --replicas 5
====
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: dev
  labels:
    app: nginx-anisa
spec:   
  replicas: 8
  selector: 
    matchLabels:
      anisa: kubernetes
  template: 
    metadata:
      labels:
        anisa: kubernetes
    spec:
      containers:
        - name: nginx-container
          image: docker.arvancloud.ir/nginx:1.21 
      tolerations:
        - key: "anisa"
          operator: "Equal"
          value: "kubernetes"
          effect: "NoSchedule"
    =====
    kubectl taint node worker1 anisa-
========
kubectl taint node worker1 anisa=kubernetes:NoSchedule-
=======
kubectl taint node worker1 anisa=kubernetes:NoSchedule
====
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: dev
  labels:
    app: nginx-anisa
spec:   
  replicas: 8
  selector: 
    matchLabels:
      anisa: kubernetes
  template: 
    metadata:
      labels:
        anisa: kubernetes
    spec:
      containers:
        - name: nginx-container
          image: docker.arvancloud.ir/nginx:1.21 
      tolerations:
        - key: "node-role.kubernetes.io/control-plane"
          operator: "Exists"
====
kubectl taint node worker2 app=nginx:PreferNoSchedule
=======
kubectl taint node worker1 app=nginx:NoExecute
=====
```

## Session 7 (8 on classes)
```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: nginx
  namespace: dev
spec:
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx
==========
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  namespace: dev
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.21
      nodeSelector:
        size: small
========
kubectl label node kubeworker-2 size=small
=====
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  namespace: dev
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.18
      affinity:
        nodeAffinity:
                  requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
              - matchExpressions:
                 - key: "size"
                   operator: "In"
                   values:
                     - "large"
                     - "small"
============
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: dev
  labels:
    app: nginx
spec:
  replicas: 10
  selector:
    matchLabels:
      type: frontend
  template:
    metadata:
      labels:
        type: frontend
    spec:
      containers:
        - name: nginx-container
          image: nginx:1.20
      affinity:
        nodeAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
            - weight: 1
              preference:
                matchExpressions:
                  - key: color
                    operator: In
                    values:
                      - blue
==========
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-red
  namespace: dev
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
              - matchExpressions:
                - key: "color"
                  operator: "In"
                  values:
                    - red
      tolerations:
        - key: "color"
          operator: "Equal"
          value: "red"
          effect: "NoSchedule"
      containers:
        - name: nginx
          image: nginx
========       

```


## Session 8 (9 on classes)

## Session 9 (11 on classes)
```
apiVersion: v1
kind: Pod
metadata:
  name: alpine-pod
  namespace: default
spec:
  containers:
    - name: alpine-container
      image: registry.docker.ir/alpine
      command:
        - sleep
        - infinity
      env:
        - name: WORDPRESS_DB_NAME
          value: "anisa"
        - name: WORDPRESS_DB_USER
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: DB_USER
=====
kubectl create configmap config --from-env-file=.env
======
kubectl -n dev create secret docker-registry ckatestaccount --docker-username=burux --docker-password=@nis@12345678 --dry-run=client -o yaml > docker-registry-secret.yaml
======
apiVersion: v1
kind: Pod
metadata:
  name: pod-multi
  namespace: default
  labels:
    app: nginx
spec:
  volumes:
    - name: myvol
      emptyDir:
        sizeLimit: 10Mi
  initContainers:
    - name: config-creator
      image: registry.docker.ir/alpine
      volumeMounts:
        - name: myvol
          mountPath: /mnt/vol
      command:
        - /bin/sh
        - -c
        - |
          echo "$(date) here is your Config" > /mnt/vol/init1.txt
          sleep 5
    - name: git-cloner
      image: registry.docker.ir/alpine
      volumeMounts:
        - name: myvol
          mountPath: /mnt/vol
      command:
        - /bin/sh
        - -c
        - |
          echo "$(date) here is your git repository" > /mnt/vol/init2.txt
  containers:
    - name: nginx-container
      image: registry.docker.ir/nginx:1.21
      volumeMounts:
        - name: myvol
          mountPath: /mnt/vol
======

```

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
