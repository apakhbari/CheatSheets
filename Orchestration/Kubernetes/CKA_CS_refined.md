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

——————————————————

**Introduction**

——————————————————

**Certified Kubernetes Administrator (CKA): Introduction**

- CNCF (Cloud Native COmputong Foundation) : Is part of linux foundation, offers 4 certificates

- KCNA (Kubernetes and Cloud Native Associate)
- CKAD (Certified Kubernetes Application Developer)
- CKA (Certified Kubernetes Administrator)
- CKS (Certified Kubernetes Security Specialist)

——————————————————

**Module 1: Building a Kubernetes Cluster**

——————————————————

**Lesson 1: Understanding Kubernetes Architecture**

1.1 Vanilla Kubernetes and the Ecosystem

- Vanilla K8s is open-source k8s, installed with kubeadm directly from the kubernetes project Git repository
- A new release of Vanilla k8s is published every 4 months
- It provides core functionality, but does not contain some essential components

- Networking
- Support
- Graphical Dashboard

- To make a completely working environment, additional solutions from the k8s ecosystem are added

- Have a look at [cncf.io](http://cncf.io) > Projects Tab > Graduated —> there are projects that are approved for using in k8s environment

- CNCF (Cloud Native Computing Foundation) hosts many projects related to cloud native computing
- Kubernetes is among the most important projects, but many other projects are offered as well, implementing a wide range of functionality

- Networking
- Dashboard
- Storage
- Observability
- Ingress

- To get a completely working Kubernetes solution, products from the ecosystem need to be installed also
- This can be done manually, or by using a distribution

1.2 Running Kubernetes in Cloud or on Premise

- K8s is a platform for cloud native computing, and as such is commonly used in cloud
- All major cloud providers have their own integrated k8s distribution
- K8s can also be installed on premise, within the secure boundaries of your own datacenter
- And also, there are all-in-one solutions which are perfect for learning kubernetes, like minikube

1.3 Kubernetes Distributions

- K8s distributions add products from the ecosystem to vanilla k8s and provide support
- Normally, distributions run one or two k8s versions behind
- Some distributions are opinionated and integrate multiple products to offer specific solutions
- Other distributions are less opinionated and integrate multiple products to offer specific solutions

Common K8s distributions

- in Cloud

- Amazon Elastic Kubernetes Services (EKS)
- Azure Kubernetes Services (AKS)
- Google Kubernetes Engine (GKE)

- On Premise

- OpenShift
- Google Antos
- Rancher
- Canonical Charmed Kubernetes

- Minimal (learning) Solutions

- Minikube
- K3s

1.4 Kubernetes Node Roles

- The Control plane runs Kubernetes core services, Kubernetes agents, and no user workloads
- The worker plane runs user workloads and Kubernetes agents
- All nodes are configured with a container runtime, which is required for running containerized workloads
- The kubelet systemd service is responsible for running orchestrated containers as Pods on any node

- CRI (Container Runtime Interface) + kubelet: are systemd managed, they start when OS boots
- Scheduler: distributing workloads
- etcd: Heart of k8s cluster which stores all your resources
- Calico: network plugin, runs on control node, scheduler makes sure it's also running on worker node
- What happens when you start my-app using kubectl? It is going to be on control node, it is going to address it to API server, then API server is going to store it on etcd, etcd will bring it to scheduler, and scheduler gets in touch with kubelet of worker nodes, so my-app is now being started
- Control Node is a protected node, user apps are not running there

——————————————————
