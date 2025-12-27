#!/bin/bash

# This script gathers information about your Kubernetes cluster relevant for Rook Ceph integration.
# It assumes you have kubectl access and are running this on a control-plane or a node with admin privileges.
# It uses 'kubectl debug' to run commands on each node (requires Kubernetes 1.23+).
# The debug pods use the 'ubuntu:22.04' image for compatibility with Ubuntu commands.
# Output includes cluster version, node details, storage devices (lsblk), kernel info, RBD module check, LVM check, and other resources.

set -e

echo "=== Cluster Version ==="
kubectl version --short

echo ""
echo "=== Node List (with details) ==="
kubectl get nodes -o wide

echo ""
echo "=== Node Architectures, OS, Kernel, Container Runtime ==="
kubectl get nodes -o custom-columns=NAME:.metadata.name,ARCH:.status.nodeInfo.architecture,OS:.status.nodeInfo.operatingSystem,OS_IMAGE:.status.nodeInfo.osImage,KERNEL:.status.nodeInfo.kernelVersion,RUNTIME:.status.nodeInfo.containerRuntimeVersion

echo ""
echo "=== Detailed Node Information ==="
nodes=$(kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{" "}{end}')
for node in $nodes; do
  echo "Node: $node"
  kubectl describe node "$node" | grep -E 'Roles|Capacity|Allocatable|System Info|Labels|Taints'
  echo ""
done

echo "=== Storage Devices on Each Node (lsblk -f) ==="
# Checks for raw devices without filesystems (important for Rook Ceph OSDs)
for node in $nodes; do
  echo "Node: $node"
  kubectl debug node/"$node" --image=ubuntu:22.04 --quiet -- /bin/bash -c 'apt update -qq && apt install -y --no-install-recommends util-linux && lsblk -f'
  echo ""
done

echo "=== Kernel RBD Module Check on Each Node ==="
# Checks if 'rbd' kernel module is available (required for RBD)
for node in $nodes; do
  echo "Node: $node"
  kubectl debug node/"$node" --image=ubuntu:22.04 --quiet -- /bin/bash -c 'apt update -qq && apt install -y --no-install-recommends kmod && modinfo rbd && echo "RBD module available" || echo "RBD module NOT available"'
  echo ""
done

echo "=== LVM2 Package Check on Each Node ==="
# Checks if lvm2 is installed (required for certain Rook configs like encryption or multiple OSDs per device)
for node in $nodes; do
  echo "Node: $node"
  kubectl debug node/"$node" --image=ubuntu:22.04 --quiet -- /bin/bash -c 'apt update -qq && dpkg -l | grep lvm2 && echo "lvm2 installed" || echo "lvm2 NOT installed"'
  echo ""
done

echo "=== CNI Detection (from kube-system pods) ==="
kubectl get pods -n kube-system -l k8s-app=canal || echo "Canal CNI pods not found (check manually)"

echo ""
echo "=== Storage Classes ==="
kubectl get storageclass

echo ""
echo "=== Persistent Volumes ==="
kubectl get pv

echo ""
echo "=== Persistent Volume Claims (all namespaces) ==="
kubectl get pvc -A

echo ""
echo "=== All Pods (all namespaces) ==="
kubectl get pods -A -o wide

echo ""
echo "=== All Resources in kube-system Namespace ==="
kubectl get all -n kube-system

echo ""
echo "=== Rook/Ceph Check (if already installed) ==="
kubectl get ns | grep rook-ceph || echo "No rook-ceph namespace found"
kubectl get cephcluster -n rook-ceph 2>/dev/null || echo "No CephCluster found"

echo ""
echo "=== Additional Notes for Rook Ceph Integration ==="
echo "- Verify Kubernetes version is between 1.29 and 1.34."
echo "- Ensure nodes are amd64 or arm64."
echo "- Look for raw devices in lsblk output (no FSTYPE)."
echo "- RBD module must be available on all nodes."
echo "- Install lvm2 on storage nodes if using encryption, metadata devices, or osdsPerDevice >1."
echo "- For CephFS RWX, kernel >=4.17 recommended."
echo "- Run this script and review outputs to confirm prerequisites."
echo "- For VLAN, Gateway, Usecase, etc., these are not auto-detectable; update manually based on your table."