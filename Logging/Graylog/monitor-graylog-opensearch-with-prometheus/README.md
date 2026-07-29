Great, this is enough info to make everything concrete. Here's the full path:

## Step 1 — OpenSearch exporter (no auth, simple case)

```yaml
# opensearch-exporter.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: opensearch-exporter
  namespace: graylog
spec:
  replicas: 1
  selector:
    matchLabels:
      app: opensearch-exporter
  template:
    metadata:
      labels:
        app: opensearch-exporter
    spec:
      containers:
        - name: opensearch-exporter
          image: quay.io/prometheuscommunity/elasticsearch-exporter:v1.7.0
          args:
            - "--es.uri=http://opensearch-cluster-master:9200"
            - "--es.all"
            - "--es.indices"
            - "--es.indices_settings"
            - "--es.shards"
            - "--collector.snapshots"
            - "--collector.clustersettings"
            - "--web.listen-address=:9114"
          ports:
            - containerPort: 9114
              name: metrics
---
apiVersion: v1
kind: Service
metadata:
  name: opensearch-exporter
  namespace: graylog
  labels:
    app: opensearch-exporter
spec:
  selector:
    app: opensearch-exporter
  ports:
    - name: metrics
      port: 9114
      targetPort: 9114
```

```bash
kubectl apply -f opensearch-exporter.yaml
kubectl port-forward -n graylog svc/opensearch-exporter 9114:9114 &
curl localhost:9114/metrics | head -20   # sanity check
```

---

## Step 2 — Enable Graylog's built-in exporter

Your `graylog-0` pod has label `app.kubernetes.io/name=graylog` (from the Helm chart it's running under, even if you don't manage it via `helm`), so use that for the Service selector.

Patch the StatefulSet to add the env vars:

```bash
kubectl patch statefulset graylog -n graylog --type='json' -p='[
  {"op":"add","path":"/spec/template/spec/containers/0/env/-","value":{"name":"GRAYLOG_PROMETHEUS_EXPORTER_ENABLED","value":"true"}},
  {"op":"add","path":"/spec/template/spec/containers/0/env/-","value":{"name":"GRAYLOG_PROMETHEUS_EXPORTER_BIND_ADDRESS","value":"0.0.0.0:9833"}}
]'
```

This triggers a rolling restart of `graylog-0` — expect a few minutes of downtime for that single node. Watch it come back:

```bash
kubectl get pods -n graylog -w
```

> Since you're on chart `graylog-2.4.1`, if you ever rebuild this StatefulSet from the same Helm release without persisting these values in your `values.yaml`, the patch will be lost. Worth adding it to your chart values under whatever key exposes `extraEnv` — check with `helm get values graylog -n graylog` if a release named `graylog` exists, or `helm list -A` if unsure of the release name.

Now expose the metrics port:

```yaml
# graylog-metrics-svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: graylog-metrics
  namespace: graylog
  labels:
    app.kubernetes.io/name: graylog
spec:
  selector:
    app.kubernetes.io/name: graylog
    app.kubernetes.io/instance: graylog
  ports:
    - name: metrics
      port: 9833
      targetPort: 9833
```

```bash
kubectl apply -f graylog-metrics-svc.yaml
kubectl port-forward -n graylog svc/graylog-metrics 9833:9833 &
curl localhost:9833/metrics | head -20   # should show gl_... metrics
```

---

## Step 3 — ServiceMonitors for kube-prometheus-stack

Your release is `prometheus-stack` in namespace `monitoring`. Confirm the label selector kube-prometheus-stack's Prometheus CR expects:

```bash
kubectl get prometheus -n monitoring -o jsonpath='{.items[0].spec.serviceMonitorSelector}'
```

By default this chart uses `release: prometheus-stack` and watches **all namespaces**, so a ServiceMonitor created in `graylog` will be picked up automatically.

```yaml
# servicemonitors.yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: opensearch-exporter
  namespace: graylog
  labels:
    release: prometheus-stack
spec:
  selector:
    matchLabels:
      app: opensearch-exporter
  namespaceSelector:
    matchNames: ["graylog"]
  endpoints:
    - port: metrics
      interval: 30s
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: graylog-metrics
  namespace: graylog
  labels:
    release: prometheus-stack
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: graylog
  namespaceSelector:
    matchNames: ["graylog"]
  endpoints:
    - port: metrics
      interval: 30s
```

```bash
kubectl apply -f servicemonitors.yaml
```

Verify: port-forward to Prometheus and check **Status → Targets**:

```bash
kubectl port-forward -n monitoring svc/prometheus-operated 9090:9090
# open http://localhost:9090/targets, look for graylog/opensearch-exporter and graylog/graylog-metrics, both should be "UP"
```

---

## Step 4 — Getting this into the external Grafana

Since your Prometheus lives in-cluster and the team's Grafana is outside it, the cleanest option is to **expose this Prometheus so their Grafana can reach it as a new datasource** — you don't need to touch their Grafana instance yourself, just hand them a URL.

Expose it (pick whichever matches your cluster's existing pattern — your Graylog services use NodePort, so that's the path of least surprise):

```yaml
# prometheus-external.yaml
apiVersion: v1
kind: Service
metadata:
  name: prometheus-external
  namespace: monitoring
spec:
  type: NodePort
  selector:
    app.kubernetes.io/name: prometheus
    prometheus: prometheus-stack-kube-prom-prometheus
  ports:
    - name: web
      port: 9090
      targetPort: 9090
      nodePort: 30900   # pick any free port in the 30000-32767 range
```

```bash
kubectl apply -f prometheus-external.yaml
kubectl get pods -n monitoring -l app.kubernetes.io/name=prometheus --show-labels   # confirm selector labels match
```

Then give your monitoring team: `http://<any-cluster-node-ip>:30900` to add as a **Prometheus** datasource in their Grafana (Connections → Data sources → Add → Prometheus → URL). If that node IP isn't reachable from their network, you'll need an Ingress with TLS instead, or a firewall rule opened for that NodePort — let me know which applies and I'll give you that manifest instead.

(If your org has a shared long-term-storage layer like Thanos or Mimir that Grafana already points to, `remote_write` from this Prometheus into that would be the more "correct" long-term answer — worth asking your monitoring team if that exists before committing to the NodePort route.)

---

## Step 5 — Pre-made dashboards

**OpenSearch**: Grafana → Dashboards → New → Import → enter ID **14191** (Elasticsearch Exporter dashboard, metric names match 1:1 since OpenSearch is wire-compatible) or **19504** (OpenSearch-specific variant). Point it at your new Prometheus datasource; if the job label filter defaults to `elasticsearch`, change it to `opensearch` (or whatever `job_name` you used in the ServiceMonitor — Prometheus auto-assigns the job name from the ServiceMonitor's name, so it'll be `opensearch-exporter`).

**Graylog**: honestly, there isn't a solid maintained community dashboard for Graylog's *native* `gl_*` Prometheus metrics (the ones on grafana.com target an older third-party exporter with different metric names, so they won't just work). I'd build you a small custom one — panels for journal size/utilization, buffer usage %, throughput, and JVM heap. Want me to generate that as a ready-to-import JSON now that you have real `gl_*` metrics flowing?