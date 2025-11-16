# Logging Plan on Kubernetes clusters
```
 ___   _   _____   _______        ___      _______  _______  _______  ___   __    _  _______ 
|   | | | |  _  | |       |      |   |    |       ||       ||       ||   | |  |  | ||       |
|   |_| | | |_| | |  _____|      |   |    |   _   ||    ___||    ___||   | |   |_| ||    ___|
|      _||   _   || |_____       |   |    |  | |  ||   | __ |   | __ |   | |       ||   | __ 
|     |_ |  | |  ||_____  |      |   |___ |  |_|  ||   ||  ||   ||  ||   | |  _    ||   ||  |
|    _  ||  |_|  | _____| |      |       ||       ||   |_| ||   |_| ||   | | | |   ||   |_| |
|___| |_||_______||_______|      |_______||_______||_______||_______||___| |_|  |__||_______|
```
## Table of contents


## Overview
## TL;DR (one-line plan)

Run a node-level log collector (DaemonSet — e.g. Fluent Bit) on the source cluster that enriches logs with Kubernetes metadata and ships them to a single Graylog GELF input. In Graylog use streams (or pipelines routing) keyed on the Kubernetes namespace field to separate projects, and set your index set rotation to daily to keep per-day indices.


### Why DaemonSet (recommended) vs sidecar per-pod

- DaemonSet collector (one pod per node) reads container logs from the node (e.g. /var/log/containers/*.log), enriches them with k8s metadata and ships them centrally. This is lightweight, simpler to manage, and scales automatically with nodes. Many production setups use Fluent Bit/Fluentd as DaemonSets to centralize K8s logs. 

- Sidecar per-pod forwards only that pod’s logs. Pros: isolation per-app; cons: huge operational overhead (every pod spec must include the sidecar), higher resource usage, complexity when pods are many/short-lived. Use sidecars only for very special per-pod transformations or security/isolation requirements.

### What to run on the collector
- Fluent Bit (lightweight, great for k8s) — it has a GELF output plugin to send to Graylog. 

- Alternatives: Fluentd, Filebeat, or Vector — all workable; Graylog accepts GELF/Beats/HTTP. Graylog supports Beats input and GELF HTTP/TCP/UDP inputs. 

## Step-by-step Hands-on
### A) Prepare Graylog (first)
1. Create a GELF input in Graylog:
    - `Graylog UI → System → Inputs` → choose GELF TCP or GELF HTTP (TCP is common and reliable; HTTP is firewall-friendly). Launch it on a port (e.g. 12201). Graylog’s GELF inputs accept standard container/app GELF messages. 

2. Optionally create a Beats input if you plan to use Filebeat/Winlogbeat. Graylog’s Beats input expects Beats/Logstash protocol (TCP). 

3. Ensure Graylog is reachable from your source Kubernetes cluster (network, DNS, TLS). If production, enable TLS on the input (use TLS termination or put Graylog behind a TLS LB).

### B) Deploy Fluent Bit as a DaemonSet (collector)
#### Production-Ready
- **a full production-ready Fluent Bit DaemonSet** for Kubernetes, specifically tuned
    - Collect pod logs from /var/log/containers/*.log
    - Enrich logs with Kubernetes metadata (namespace, pod, container, labels)
    - Forward logs to Graylog via GELF TCP
    - Includes RBAC, ServiceAccount, ConfigMap, DaemonSet, and TLS placeholders
    
1. Service Account + RBAC
2. ConfigMap (Main Fluent Bit Config + Parsers)
    - Update the `Host` value inside `[OUTPUT]` to your Graylog hostname or IP.
3. DaemonSet (main Fluent Bit pod)
4. (Optional) TLS secret example. Only if using TLS for GELF input:

##### What This Setup Achieves
- ✔ Collects logs from all pods on every node: (via DaemonSet + hostPath to /var/log/containers)

- ✔ Enriches logs with Kubernetes metadata: (namespace, pod, container, labels)

- ✔ Sends logs to Graylog using GELF: (the native format Graylog loves)

- ✔ Fully production-ready: RBAC, TLS placeholder, resource limits, state DB, skip long lines, etc.

#####  Your logs will now arrive in Graylog like this:
Fields you can filter/stream on:
- `kubernetes.namespace_name`
- `kubernetes.pod_name`
- `kubernetes.container_name`
- `kubernetes.labels.app`
- `kubernetes.docker_id`
- `stream (stdout/stderr)`
- `log`
- `timestamp`

This is perfect for creating Streams per project (namespace) and daily index rotation.

#### Minimal
- a minimal example (ConfigMap + DaemonSet). You’ll adapt image versions, resources, securityContext, and TLS to your environment.

1. ConfigMap (fluent-bit config) — key ideas:
- Tail container logs (/var/log/containers/*.log)
- Add Kubernetes metadata (kubernetes filter)
- Output using the gelf plugin to Graylog host:port

2. DaemonSet (mount container logs + config) — simplified:

- Apply
```
kubectl apply -f fluent-bit-configmap.yaml
kubectl apply -f fluent-bit-daemonset.yaml
```

- Notes: The kubernetes filter will attach kubernetes.namespace_name, kubernetes.pod_name, kubernetes.labels, etc, to each record. Use those fields in Graylog streams.

### C) What fields to expect in Graylog
- When Fluent Bit/Fluentd sends GELF, it typically includes fields like:

- `message` (the log line)
- `timestamp` (event time)
- `_kubernetes_namespace_name` or `kubernetes['namespace_name']` — how fields are named depends on the collector; commonly you get kubernetes.namespace_name or kube_namespace. Check a sample message in Graylog’s “All messages” to see field names. Use those exact field names when creating stream rules.


### D) Graylog: Streams and Indexing — how to split by project & day
#### 1) Use Streams to separate projects (namespaces)
- Create a Stream per project/namespace (or create a small number of streams grouped by project type).
    - ` System → Streams → Create stream `
    - Add a stream rule: field `kubernetes.namespace_name` (or `kube_namespace`) `match exactly` → `your-namespace`. Start the stream.
- Streams let you route only matching messages to that stream. You may attach pipelines to further enrich/transform messages.

##### Design decision:
- If you have a small and stable number of namespaces (projects), create one stream per namespace (each stream can be attached to its own index set if you want different retention).

- If you have many dynamic namespaces, create streams for the important projects and use tags/fields for others; you can also use pipelines + lookup tables to map namespaces to higher-level project buckets.

##### 2) Index sets & daily separation (per-day indices)
- Graylog stores messages into index sets. Each index set has a rotation strategy (time-based, size-based, or the new data-tiering optimizing strategy). You can configure rotation to rotate every day (ISO8601 P1D) so new indices are created per day. That achieves your “divide logs by day” requirement. Then retention policy deletes old indices after your retention window. 

How to set daily rotation:
- `System → Indices` → edit your index set (or create a new index set) → Rotation & Retention → choose rotation strategy Index Time (or Data Tiering with a daily period) and set rotation period to `P1D`. Set retention strategy to `Delete` and `max number of indices` to keep N days. Example: keep 30 daily indices → keeps ~30 days.

### E) Enrichment & routing (pipelines)
- Use pipeline rules to normalize fields (e.g., rename `_kubernetes_namespace_name` to `namespace`) or to `route_to_stream("project-foo")` by logic. Graylog docs recommend pipelines for richer transformations (and will deprecate some stream rule patterns in future). Use pipelines for complex routing/enrichment. 

- Example pipeline snippet to route on `kubernetes.namespace_name`:
```
rule "route_by_namespace"
when
  has_field("kubernetes") && to_string($message.kubernetes.namespace_name) == "payments"
then
  route_to_stream("Payments Stream ID");
end
```

## Practical checklist
1. On Graylog:
    - Create GELF TCP (port 12201) or GELF HTTP. Ensure reachable. 
    - Create index set: configure rotation P1D and retention (keep N indices/days). 
    - Create Streams for the namespaces you care about; use the exact k8s field name you see in messages. Start streams. 
2. On source K8s cluster:
    - Deploy Fluent Bit DaemonSet + ConfigMap (example above) with GELF output to Graylog host:12201. Verify logs appear in Graylog “All messages”. 
    - If you need TLS, configure Fluent Bit TLS settings and Graylog’s input for TLS.
3. Verify:
- In Graylog, open “All messages”, run a search for a recent pod log, check fields (namespace/pod). Use those exact field names to create stream rules.
- Check stream counts and that messages appear in the intended stream.
- Check System → Indices to see daily indices being created per rotation.


## Notes, pitfalls & suggestions
- Field names matter. Different collectors may send slightly different field names (kubernetes.namespace_name, kube_namespace, _kubernetes_namespace_name). Inspect incoming messages before building stream rules. 
Stackademic
- Volume & indices count. If you create one index set per namespace and you have many namespaces, you’ll create many indices — that can stress Elasticsearch/OpenSearch. Prefer grouping low-importance namespaces into shared index sets with a common retention policy. 
- Performance / TLS. For production, use TCP+TLS + authentication and monitor Graylog/ES cluster health.
- Testing tip: start by sending a few test logs via curl to your GELF HTTP input (Graylog docs show examples) to confirm input configuration before deploying the DaemonSet. 
go2docs.graylog.org

# acknowledgment
## Contributors
- APA 🖖🏻

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