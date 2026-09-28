#!/usr/bin/env bash
set -euo pipefail

SA_NAME="headlamp-admin"
NAMESPACE="kube-system"
OUTPUT_FILE="headlamp-kubeconfig.yaml"

# 1. Interactively prompt for cluster name
DEFAULT_CLUSTER_NAME="$(kubectl config view --minify -o jsonpath='{.clusters[0].name}' 2>/dev/null || echo 'my-cluster')"
read -r -p "Enter cluster name [$DEFAULT_CLUSTER_NAME]: " INPUT_CLUSTER_NAME
CLUSTER_NAME="${INPUT_CLUSTER_NAME:-$DEFAULT_CLUSTER_NAME}"

# 2. Detect the host IP of the machine running this script
DETECTED_IP="$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}' || hostname -I | awk '{print $1}')"
read -r -p "Enter host IP for Kubernetes API [$DETECTED_IP]: " INPUT_IP
HOST_IP="${INPUT_IP:-$DETECTED_IP}"

# 3. Resolve the server API URL (swap localhost/127.0.0.1 for the actual host IP)
ORIGINAL_SERVER="$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')"
PORT="$(echo "$ORIGINAL_SERVER" | awk -F: '{print $NF}' | tr -d '/')"

if [ -z "$PORT" ] || ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
  PORT="6443"
fi

SERVER="https://${HOST_IP}:${PORT}"
echo "Using API Server URL: $SERVER"

# 4. Ensure ServiceAccount and ClusterRoleBinding exist
echo "Creating/Verifying ServiceAccount and ClusterRoleBinding..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ${SA_NAME}
  namespace: ${NAMESPACE}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: ${SA_NAME}-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: ${SA_NAME}
  namespace: ${NAMESPACE}
EOF

# 5. Create the token Secret
echo "Creating/Verifying token Secret..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: ${SA_NAME}-token
  namespace: ${NAMESPACE}
  annotations:
    kubernetes.io/service-account.name: ${SA_NAME}
type: kubernetes.io/service-account-token
EOF

# 6. Wait for the token controller to populate data
echo "Waiting for token controller to populate secret..."
TOKEN=""
CA_DATA=""

for i in {1..15}; do
  if kubectl get secret "${SA_NAME}-token" -n "${NAMESPACE}" >/dev/null 2>&1; then
    TOKEN_RAW="$(kubectl get secret "${SA_NAME}-token" -n "${NAMESPACE}" -o jsonpath='{.data.token}' 2>/dev/null || true)"
    if [ -n "$TOKEN_RAW" ]; then
      TOKEN="$(echo "$TOKEN_RAW" | base64 --decode)"
      CA_DATA="$(kubectl get secret "${SA_NAME}-token" -n "${NAMESPACE}" -o jsonpath='{.data.ca\.crt}')"
      break
    fi
  fi
  sleep 1
done

if [ -z "$TOKEN" ]; then
  echo "Error: Timed out waiting for token in secret '${SA_NAME}-token'."
  exit 1
fi

# 7. Write the standalone kubeconfig
echo "Writing kubeconfig to $OUTPUT_FILE..."
cat <<EOF > "$OUTPUT_FILE"
apiVersion: v1
kind: Config
clusters:
- name: ${CLUSTER_NAME}
  cluster:
    certificate-authority-data: ${CA_DATA}
    server: ${SERVER}
contexts:
- name: ${CLUSTER_NAME}
  context:
    cluster: ${CLUSTER_NAME}
    user: ${SA_NAME}
current-context: ${CLUSTER_NAME}
users:
- name: ${SA_NAME}
  user:
    token: ${TOKEN}
EOF

chmod 600 "$OUTPUT_FILE"
echo "Success! Kubeconfig written to: $(pwd)/$OUTPUT_FILE"
