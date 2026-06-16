Here's a comprehensive, production-grade Prometheus monitoring stack YAML. Let me build this for you:Here's what's included in this production-grade stack — everything in a single `kubectl apply -f` file:

**Namespace & Identity**
- Dedicated `monitoring` namespace with labels
- Separate `ServiceAccount` for Prometheus, kube-state-metrics, and Alertmanager

**RBAC**
- `ClusterRole` + `ClusterRoleBinding` for Prometheus — covers nodes, pods, services, endpoints, ingresses, HPA, PDB, storage classes, and non-resource URLs (`/metrics`, `/healthz`)
- Separate `ClusterRole` + `ClusterRoleBinding` for kube-state-metrics with its own permissions

**Core Components**
- **Prometheus** — Deployment with 30-day retention, 45GB size cap, JSON logging, hot-reload enabled
- **Node Exporter** — DaemonSet that runs on every node (including tainted ones), exposes host CPU/memory/disk/network metrics
- **kube-state-metrics** — Exposes Kubernetes object state (deployments, pods, HPA, PDB, etc.)
- **Alertmanager** — Pre-wired to Prometheus, with routing and inhibition rules ready

**Auto-Discovery**
- Pods/services annotated with `prometheus.io/scrape: "true"` are automatically picked up — no config changes needed per workload

**Alert Rules** (built-in)
- Node down, high CPU (>85%), high memory (>85%), disk pressure (<15% free)
- Pod crash-looping, pods not ready, deployment replica mismatch, HPA maxed out
- API server down / high error rate
- Prometheus self-monitoring (config reload failure, TSDB issues, scrape failures)

**Production Hardening**
- `readOnlyRootFilesystem`, dropped capabilities, `runAsNonRoot`, `seccompProfile: RuntimeDefault`
- Resource requests/limits on all containers
- Liveness + readiness probes on all workloads
- `PodDisruptionBudget` to prevent Prometheus going down during node drains
- `NetworkPolicy` scoping ingress/egress tightly
- `ResourceQuota` + `LimitRange` on the namespace
- 50Gi PVC for metrics persistence

**To deploy:**
```bash
kubectl apply -f prometheus-production-stack.yaml
```

**Before deploying, review:**
1. `storageClassName` in the PVC — uncomment the line matching your cloud provider (gp2, premium-rwo, etc.)
2. Alertmanager `receivers` — add your Slack webhook, PagerDuty key, or SMTP config
3. Image versions — pinned to stable releases, bump if you need newer ones