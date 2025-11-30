#!/bin/bash
# Complete Fluent Bit setup script
# Run this to deploy/update Fluent Bit

echo "=== Deploying Fluent Bit for Kubernetes Logging to Graylog ==="

# 1. Create ServiceAccount and RBAC
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: fluent-bit
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: fluent-bit-read
rules:
- apiGroups: [""]
  resources:
  - namespaces
  - pods
  - pods/logs
  verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: fluent-bit-read
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: fluent-bit-read
subjects:
- kind: ServiceAccount
  name: fluent-bit
  namespace: kube-system
EOF

# 2. Create Lua Scripts ConfigMap
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluent-bit-lua-scripts
  namespace: kube-system
  labels:
    app.kubernetes.io/name: fluent-bit
data:
  combine_fields.lua: |
    function add_dividing_name(tag, timestamp, record)
        local ns = record["kubernetes"]["namespace_name"] or "unknown"
        record["dividing_name"] = "cluster_prod_50:" .. ns
        return 1, timestamp, record
    end
EOF

# 3. Create Fluent Bit ConfigMap
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluent-bit-config
  namespace: kube-system
  labels:
    app.kubernetes.io/name: fluent-bit
data:
  fluent-bit.conf: |
    [SERVICE]
        Flush        5
        Daemon       Off
        Log_Level    info
        Parsers_File parsers.conf
        storage.path /var/fluent-bit/state

    @INCLUDE input-kubernetes.conf
    @INCLUDE filters.conf
    @INCLUDE output-gelf.conf

  input-kubernetes.conf: |
    [INPUT]
        Name              tail
        Path              /var/log/pods/*/*/*.log
        Exclude_Path      /var/log/pods/kube-system_*/*/*.log,/var/log/pods/kube-public_*/*/*.log
        Parser            docker
        Tag               kube.*
        Mem_Buf_Limit     50MB
        Skip_Long_Lines   On
        Refresh_Interval  10
        Read_from_Head    False
        storage.type      filesystem
        DB                /var/fluent-bit/state/flb-kube.db
        DB.locking        true

  filters.conf: |
    [FILTER]
        Name                kubernetes
        Match               kube.*
        Kube_URL            https://kubernetes.default.svc:443
        Kube_CA_File        /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        Kube_Token_File     /var/run/secrets/kubernetes.io/serviceaccount/token
        Kube_Tag_Prefix     kube.var.log.pods.
        Merge_Log           On
        Keep_Log            On
        K8S-Logging.Parser  On
        K8S-Logging.Exclude On
        Labels              On
        Annotations         Off

    [FILTER]
        Name         modify
        Match        *
        Add          cluster_name cluster_prod_50

    [FILTER]
        Name         modify
        Match        *
        Remove       stream
        Remove       kubernetes.container_hash

    [FILTER]
        Name   lua
        Match  kube.*
        script /fluent-bit/scripts/combine_fields.lua
        call   add_dividing_name

  output-gelf.conf: |
    [OUTPUT]
        Name          gelf
        Match         *
        Host          10.10.21.151
        Port          31220
        Mode          tcp
        Gelf_Short_Message_Key   log
        Gelf_Timestamp_Key       @timestamp
        Gelf_Host_Key            host
        Gelf_Level_Key           level

  parsers.conf: |
    [PARSER]
        Name        docker
        Format      json
        Time_Key    time
        Time_Format %Y-%m-%dT%H:%M:%S.%L%z
        Time_Keep   On
EOF

# 4. Deploy DaemonSet
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluent-bit
  namespace: kube-system
  labels:
    k8s-app: fluent-bit
spec:
  selector:
    matchLabels:
      k8s-app: fluent-bit
  template:
    metadata:
      labels:
        k8s-app: fluent-bit
    spec:
      serviceAccountName: fluent-bit
      tolerations:
      - operator: Exists
        effect: NoSchedule
      - operator: Exists
        effect: NoExecute
      containers:
      - name: fluent-bit
        image: fluent/fluent-bit:3.0
        imagePullPolicy: Always
        resources:
          limits:
            memory: 200Mi
          requests:
            cpu: 100m
            memory: 100Mi
        volumeMounts:
        - name: varlog
          mountPath: /var/log
        - name: config
          mountPath: /fluent-bit/etc/
        - name: fluentbit-state
          mountPath: /var/fluent-bit/state
        - name: lua-scripts
          mountPath: /fluent-bit/scripts/
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
      - name: config
        configMap:
          name: fluent-bit-config
      - name: fluentbit-state
        hostPath:
          path: /var/fluent-bit/state
          type: DirectoryOrCreate
      - name: lua-scripts
        configMap:
          name: fluent-bit-lua-scripts
EOF

echo ""
echo "=== Deployment complete! ==="
echo "Waiting for pods to be ready..."
sleep 5

echo ""
echo "=== Fluent Bit Pod Status ==="
kubectl get pods -n kube-system -l k8s-app=fluent-bit -o wide

echo ""
echo "=== Recent Logs from Fluent Bit ==="
kubectl logs -n kube-system -l k8s-app=fluent-bit --tail=30 --prefix=true

echo ""
echo "=== To follow logs in real-time, run: ==="
echo "kubectl logs -n kube-system -l k8s-app=fluent-bit -f"