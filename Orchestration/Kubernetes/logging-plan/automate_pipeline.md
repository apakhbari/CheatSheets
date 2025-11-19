## Complete Example with ConfigMap to mount a file to your Graylog pod

### Step 1: Create the CSV file
```bash
# Create a sample lookup table
echo "id,name,value
1,server1,production
2,server2,development
3,server3,staging" > lookup-table.csv
```

### Step 2: Create ConfigMap
```bash
kubectl create configmap graylog-lookup-table --from-file=lookup-table.csv=./lookup-table.csv -n graylog
```

or 

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: graylog-lookup-table
  namespace: graylog
data:
  lookup-table.csv: |
    uster_prod_34:kube-system,691c45d75c03777e128ef457
    cluster_prod_34:argocd,691c45e25c03777e128ef4ae
    cluster_prod_34:acs-prod,691c42cc5c03777e128edf1d
```

### Step 3: Update Graylog StatefulSet
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: graylog
  namespace: graylog
spec:
  replicas: 1
  selector:
    matchLabels:
      app: graylog
  template:
    metadata:
      labels:
        app: graylog
    spec:
      containers:
      - name: graylog
        image: graylog/graylog:5.1
        env:
        - name: GRAYLOG_HTTP_EXTERNAL_URI
          value: "http://graylog.example.com:9000/"
        ports:
        - containerPort: 9000
        volumeMounts:
        - name: lookup-table-volume
          mountPath: /etc/graylog/lookup-table.csv
          subPath: lookup-table.csv
          readOnly: true
      volumes:
      - name: lookup-table-volume
        configMap:
          name: graylog-lookup-table
          defaultMode: 0644
```

- then Apply the changes
```bash
kubectl apply -f graylog-StatefulSet.yaml
```

or

```
kubectl edit statefulset  graylog -n graylog

# Under spec.template.spec.containers[0]:
volumeMounts:
- name: lookup-table-volume
  mountPath: /etc/graylog/lookup-table.csv
  subPath: lookup-table.csv
  readOnly: true

# Under spec.template.spec:
volumes:
- name: lookup-table-volume
  configMap:
    name: graylog-lookup-table
    defaultMode: 0644
```

### Step 4: Verify the file is mounted
```bash
kubectl exec -it statefulset/graylog -n graylog -- ls -la /etc/graylog/lookup-table.csv
kubectl exec -it statefulset/graylog -n graylog -- cat /etc/graylog/lookup-table.csv
```