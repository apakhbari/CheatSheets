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

### Step 3: Update Graylog Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
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

### Step 4: Apply the changes
```bash
kubectl apply -f graylog-deployment.yaml
```

### Step 5: Verify the file is mounted
```bash
kubectl exec -it deployment/graylog -n graylog -- ls -la /etc/graylog/lookup-table.csv
kubectl exec -it deployment/graylog -n graylog -- cat /etc/graylog/lookup-table.csv
```

## Recommendations:

- **Use ConfigMap** for static configuration files that don't change often
- **Use Secret** for files containing sensitive information
- **Use PersistentVolume** for large files or files that need to be updated frequently
- **Use initContainer** for files that need to be downloaded or generated at startup

Choose the method that best fits your use case!