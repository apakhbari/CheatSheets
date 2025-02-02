# CKA (Certified Kubernetes Administrator) - 3rd Edition

---

## Table of Contents

- Introduction
- Module 1: Building a Kubernetes Cluster
    - Lesson 1: Understanding Kubernetes Architecture
    - Lesson 2: Creating a Kubernetes Cluster with kubeadm
- Module 2: Running Applications
    - Lesson 3: Deploying Kubernetes Applications
    - Lesson 4: Managing Storage
    - Lesson 5: Managing Application Access
- Module 3: Managing Kubernetes Clusters
    - Lesson 6: Managing Clusters
    - Lesson 7: Performing Node Maintenance Tasks
    - Lesson 8: Managing Scheduling
    - Lesson 9: Networking
    - Lesson 10: Managing Security Settings
    - Lesson 11: Logging, Monitoring, and Troubleshooting
- Module 4: Practice Exams
    - Lesson 12: Practice CKA Exam 1
    - Lesson 13: Practice CKA Exam 2
- Summary

---

## Introduction

### Certified Kubernetes Administrator (CKA): Introduction

- CNCF (Cloud Native Computing Foundation): Part of the Linux Foundation, offers 4 certificates:
  - KCNA (Kubernetes and Cloud Native Associate)
  - CKAD (Certified Kubernetes Application Developer)
  - CKA (Certified Kubernetes Administrator)
  - CKS (Certified Kubernetes Security Specialist)

---

## Module 1: Building a Kubernetes Cluster

### Lesson 1: Understanding Kubernetes Architecture

#### 1.1 Vanilla Kubernetes and the Ecosystem

- Vanilla K8s is open-source Kubernetes, installed with `kubeadm` directly from the Kubernetes project Git repository.
- A new release of Vanilla K8s is published every 4 months.
- It provides core functionality but does not contain some essential components:
  - Networking
  - Support
  - Graphical Dashboard
- To create a fully functional environment, additional solutions from the Kubernetes ecosystem are added.
- Visit [CNCF.io](https://cncf.io) > Projects Tab > Graduated for a list of CNCF-approved projects.
- CNCF hosts many cloud-native projects beyond Kubernetes, including:
  - Networking
  - Dashboard
  - Storage
  - Observability
  - Ingress

#### 1.2 Running Kubernetes in Cloud or On-Premise

- Kubernetes is widely used in the cloud and on-premise environments.
- Major cloud providers have integrated Kubernetes distributions:
  - **Cloud**:
    - Amazon Elastic Kubernetes Services (EKS)
    - Azure Kubernetes Services (AKS)
    - Google Kubernetes Engine (GKE)
  - **On-Premise**:
    - OpenShift
    - Google Anthos
    - Rancher
    - Canonical Charmed Kubernetes
  - **Minimal Solutions (for Learning)**:
    - Minikube
    - K3s

#### 1.3 Kubernetes Distributions

- Kubernetes distributions integrate additional products with Vanilla Kubernetes and provide support.
- They usually run one or two versions behind upstream Kubernetes.
- **Cloud Distributions**:
  - EKS, AKS, GKE
- **On-Premise Distributions**:
  - OpenShift, Anthos, Rancher, Canonical Charmed Kubernetes
- **Minimal (Learning) Distributions**:
  - Minikube, K3s

#### 1.4 Kubernetes Node Roles

- **Control Plane**: Runs core Kubernetes services, agents, and does not run user workloads.
- **Worker Nodes**: Run user workloads and Kubernetes agents.
- **Container Runtime**: Required to run containerized workloads.
- **Kubelet**: Manages Pods on a node.

---

### Lesson 2: Creating a Kubernetes Cluster with kubeadm

#### 2.1 Understanding Cluster Node Requirements

- To install a Kubernetes cluster using `kubeadm`, you need:
  - A recent version of Ubuntu or CentOS.
  - At least 2GB RAM.
  - At least 2 CPUs for control-plane nodes.
  - A container runtime (e.g., `containerd`, `CRI-O`, `Docker`).

#### 2.2 Understanding Node Networking Requirements

- Kubernetes uses different types of network communication:
  - Node Communication
  - Pod-to-Pod Communication
  - Pod-to-Service Communication
  - External-to-Service Communication
- Common network add-ons:
  - **Calico**: Supports all relevant features.
  - **Flannel**: No NetworkPolicy support.
  - **Multus**: Default in OpenShift.
  - **Weave**: Common with NetworkPolicy support.

#### 2.3 Understanding Cluster Initialization

- Running `$ kubeadm init` executes multiple phases:
  - **Preflight**: Validates system requirements.
  - **Certificates**: Generates Kubernetes CA and certificates.
  - **Kubeconfig**: Creates configuration files.
  - **Control Plane**: Deploys API server, scheduler, etcd, and controller manager.
  - **Add-ons**: Installs CoreDNS and `kube-proxy`.

#### 2.4 Installing the Cluster

```sh
sudo kubeadm init
mkdir ~/.kube
sudo cp -i /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

#### 2.5 Using `kubeadm init`

- Key flags:
  - `--apiserver-advertise-address`
  - `--config`
  - `--dry-run`
  - `--pod-network-cidr`

#### 2.6 Adding Nodes to the Kubernetes Cluster

- Join nodes using:
  ```sh
  sudo kubeadm join <join-token>
  ```
- If the token is lost, regenerate it:
  ```sh
  sudo kubeadm token create --print-join-command
  ```

---

## Module 2: Running Applications

### Lesson 3: Deploying Kubernetes Applications

#### 3.1 Using Deployments

- Deployments manage scalable Pods and offer rolling updates.
- Example:
  ```sh
  kubectl create deploy myapp --image=nginx
  ```

#### 3.2 Running Agents with DaemonSets

- DaemonSets ensure one instance runs on each node.
- Common for networking components like `calico-node` and `kube-proxy`.

#### 3.3 Using StatefulSets

- Used for applications requiring:
  - Stable and unique network identifiers.
  - Stable persistent storage.
  - Ordered scaling and updates.

#### 3.4 Managing Pod Initialization

- Use **Init Containers** for pre-execution setup.
- Example:
  ```yaml
  initContainers:
    - name: init-script
      image: busybox
      command: ['sh', '-c', 'echo Preparing...']
  ```

---

### Lesson 4: Managing Storage

#### 4.1 Understanding Kubernetes Storage Options

- Storage in Kubernetes:
  - **Pod Volumes**: Attached to Pods but ephemeral.
  - **PersistentVolumes (PV)**: Long-term storage provisioned for the cluster.
  - **PersistentVolumeClaims (PVC)**: Requests storage for Pods.

#### 4.2 Accessing Storage Through Pod Volumes

- Use `emptyDir`, `hostPath`, or ConfigMaps.
- Example:
  ```yaml
  volumes:
    - name: shared-data
      emptyDir: {}
  ```

#### 4.3 Configuring Persistent Volume (PV) Storage

- PVs are storage resources independent of any Pod.
- Example:
  ```yaml
  apiVersion: v1
  kind: PersistentVolume
  metadata:
    name: my-pv
  spec:
    capacity:
      storage: 1Gi
    accessModes:
      - ReadWriteOnce
    persistentVolumeReclaimPolicy: Retain
  ```

#### 4.4 Configuring PVCs

- PVCs request PVs dynamically or manually.
- Example:
  ```yaml
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: my-pvc
  spec:
    accessModes:
      - ReadWriteOnce
    resources:
      requests:
        storage: 1Gi
  ```

---

## Summary

This guide provides a structured approach to understanding Kubernetes administration. It covers setting up clusters, deploying applications, and managing storage, networking, and security.

```

This `.md` file properly formats your content with Markdown syntax, making it readable in any markdown viewer. Let me know if you need further refinements! 🚀