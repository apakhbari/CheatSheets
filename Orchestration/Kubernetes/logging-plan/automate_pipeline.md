### D) Graylog: Streams and Indexing — how to split by cluster, project & day

Nice — below is a **practical, step-by-step workflow** to implement **Option A (Pipeline + Lookup Table → O(1) routing)** on your free Graylog (5.2.6). It covers UI and API approaches so you can automate creation of streams and the lookup table, wire up the pipeline rule, and verify everything.

I assume:

* Graylog web UI is at `http://GRAYLOG_HOST:9000`
* I have admin API credentials `ADMIN:ADMINPASS` (replace where needed)
* Catch-all stream name (that receives all logs) is `all_k8s_logs`
* Fluent Bit is already adding `dividing_name` to every message (e.g. `cluster_prod_34:kube-system`)

---

# OVERVIEW (one-liner)

Create a lookup table that maps `dividing_name` → `stream_id`, create streams for each value, then add a single pipeline rule that looks up the target stream id and calls `route_to_stream_id(...)` + `remove_from_default_stream()` — one fast lookup per message, O(1) routing.

---

# STEP 0 — plan & prerequisites

* Ensure I have admin access to Graylog UI and API.
* Decide on naming convention for streams (use the exact `dividing_name` as stream title, or a normalized version).
* Prepare a CSV (or generate via script) mapping `dividing_name` → `stream_title` (or generate stream + capture its `stream_id` via API).

---

# STEP 1 — create streams (UI or API)

Each stream must exist before the pipeline can route messages by `stream_id`. I can create them manually (UI) or via API.

### UI (quick, manual)

1. Graylog → **Streams → Create Stream**.
2. Title = exact `dividing_name` value (e.g. `cluster_prod_34:kube-system`) — or use friendly names.
3. Leave stream rules empty (the pipeline will assign messages), or add a stream rule as fallback.
4. Start the stream.

### API (automatable) — create a stream and get its `id`

Example bash snippet (replace creds and host):

```bash
GRAYLOG="http://GRAYLOG_HOST:9000"
AUTH="-u admin:ADMINPASS"
INDEX_SET_ID="your_index_set_id"   # get from Graylog UI: System → Indices

create_stream() {
  title="$1"
  description="$2"
  payload=$(jq -n --arg t "$title" --arg d "$description" --arg i "$INDEX_SET_ID" '{
    "title": $t, "description": $d, "index_set_id": $i, "matching_type": "AND"
  }')
  curl $AUTH -s -H "Content-Type: application/json" "$GRAYLOG/api/streams" -d "$payload"
}

# Example:
create_stream "cluster_prod_34:kube-system" "Stream for kube-system" | jq .
```

The API response contains `"id": "000000000000000000000000"`. Save that `id` (we need it for lookup table).

---

# Step 2 - mount lookup-table.csv file to your Graylog pod using ConfigMap

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

```yaml
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


# STEP 3 — create a CSV lookup data adapter and a lookup table (UI or API)

I recommend using a CSV lookup adapter because it’s easy to update (upload new CSV).


### Option A — UI (easiest)

1. Graylog → **System → Lookup Tables → Data Adapters**.
2. Create Data Adapter:

   * Type: **CSV** (or Key-Value file)
   * Name: `dividing_name_csv_adapter`
   * Upload CSV format: 2 columns: `key, value` where key=`dividing_name`, value=`<stream_id>`
   dividing_name_csv_adapter (CSV File)
   * Description: dividing_name_csv_adapter
   * File path: /etc/graylog/lookup-table.csv
   * Separator: ,
   * Quote character: "
   * Key column: stream
   * Value column: stream_id
   * Check interval: 60 seconds
   * Case-insensitive lookup: yes
   * CIDR lookup: no

3. Then **create a Lookup Table**:

   * Graylog → System → Lookup Tables → Create Lookup Table
   * Name: `stream_lookup`
   * Data adapter: select `dividing_name_csv_adapter`
   * Clear cache TTL as desired.

### Option B — API (automatable)

Create a CSV data adapter and lookup table via API. This is more involved; example minimal flow:

1. Create a cache (optional) — `POST /api/system/lookup/cache/<name>` (or Graylog will create one)
2. Create the CSV data adapter:

   * Endpoint: `POST /api/lookup/datamap`? (Graylog API names vary slightly; UI is easiest)
3. Upload CSV file — for many entries script a CSV then configure adapter to point to it (or use other adapter types like MongoDB if many records).

> **Important:** The lookup must map `dividing_name` → `stream_id` (not stream title). The pipeline will `lookup_value("stream_lookup", dividing_name)` and receive a stream id string.

---

# STEP 4 — populate lookup with mapping dividing_name → stream_id

If I created streams via API in Step 1, I have their `id`s. Build a CSV like:

```
dividing_name,stream_id
cluster_prod_34:kube-system,00000000-0000-0000-0000-000000000001
cluster_prod_34:argocd,00000000-0000-0000-0000-000000000002
cluster_prod_34:acs-prod,00000000-0000-0000-0000-000000000003
...
```

Upload this CSV to the CSV adapter in Graylog (UI) or point the adapter at the file.

If you prefer a dynamic script to create streams and build CSV: I can supply one.

---

# STEP 5 — create the pipeline rule (only one rule)

Go to **System → Pipelines → Manage Rules → Create Rule**. Use this rule (exact PipeScript syntax):

```pseudocode
rule "route_by_dividing_name_lookup"
when
  has_field("dividing_name")
then
  // Lookup returns stream_id (string) or null if not found
  let target_id = lookup_value("stream_lookup", to_string($message.dividing_name));

  // If lookup returned a valid stream id, route and remove from Default stream
  // Note: route_to_stream_id expects a string id literal; using variable is allowed in Graylog's lookup/route model
  if (target_id != null && target_id != "") {
      route_to_stream_id(to_string(target_id));
      remove_from_default_stream();
  }
end
```

**Important notes:**

* `lookup_value("stream_lookup", key)` — `stream_lookup` is the lookup table name in Graylog.
* `route_to_stream_id(stream_id)` routes to the stream by ID (fast).
* `remove_from_default_stream()` prevents duplication in Default Stream.
* This rule executes quickly: 1 lookup per message.

---

# STEP 6 — create the pipeline and connect to the catch-all stream

1. Graylog → **System → Pipelines → Create Pipeline**; name it e.g. `route_by_dividing_name`.
2. Add the rule `route_by_dividing_name_lookup` to the pipeline and set it at stage 0 (or stage 1).
3. Connect the pipeline to the catch-all stream `all_k8s_logs`:

   * In Pipeline Connections, add attachment: Stream = `all_k8s_logs`, Pipeline = `route_by_dividing_name`, Stage = 0.

Now every message entering `all_k8s_logs` will be processed by the pipeline rule.

---

# STEP 7 — verify and test

### 7.1. Quick live test via Graylog web UI

* Send a test message with dividing_name via `nc` or curl (GELF TCP) or generate via Fluent Bit:

  ```
  echo -ne '{"version":"1.1","host":"test","short_message":"hello","dividing_name":"cluster_prod_34:kube-system"}\0' | nc <GRAYLOG_NODE_IP> 31220
  ```
* In Graylog → **Search** → set query `dividing_name:cluster_prod_34:kube-system` → check messages.
* Check `Streams` → open stream `cluster_prod_34:kube-system` → verify messages arrive.
* Confirm message is **removed from Default stream** (Default Stream search should not include it).

### 7.2. Test the lookup

* In Graylog UI → System → Lookup Tables → Test lookup with key `cluster_prod_34:kube-system` → verify it returns expected `stream_id`.

### 7.3. Monitor performance

* Check Graylog metrics: System → Overview → Processing buffer and Output buffer.
* Check pipeline throughput and tailing errors.

---

# STEP 8 — automation & maintenance tips

* **Automate stream creation**: script to read unique `dividing_name` values from existing logs (via search API), create streams via API, capture IDs, and update CSV lookup.
* **Hot update lookup**: for CSV adapter, upload a new CSV file and reload adapter (or use a DB-backed adapter for dynamic updates).
* **Index sets & retention**: attach streams to appropriate index sets or assign the streams to index sets via their `index_set_id` if different retention is needed.
* **Cache TTL**: configure lookup table caching (short TTL) if the lookup source changes often.
* **Fallback**: in the pipeline rule, if `lookup` is null, optionally route to a fallback stream:

  ```pseudocode
  if (target_id == null) {
     route_to_stream("unmatched");
     remove_from_default_stream();
  }
  ```

---

# Example: Fully automated script outline (create streams + build CSV)

(High-level idea — I can produce a full script if needed)

1. Query Graylog for unique dividing_name values (via API search).
2. For each dividing_name:

   * Create stream via `POST /api/streams` (title = dividing_name).
   * Capture returned `id`.
   * Append `dividing_name,stream_id` to CSV.
3. Upload CSV to Graylog CSV adapter (or put file on disk if using adapter file).
4. Update lookup table to use new adapter (if needed).

I can provide an actual bash script using `curl` + `jq` if the user wants.

---

# Extra: REST API snippets you can reuse

**Get index sets** (need `index_set_id` when creating stream):

```bash
curl -s -u admin:ADMINPASS 'http://GRAYLOG_HOST:9000/api/system/indices/index_sets' | jq .
```

**Create stream** (replace INDEX_SET_ID):

```bash
curl -u admin:ADMINPASS -X POST 'http://GRAYLOG_HOST:9000/api/streams' \
 -H 'Content-Type: application/json' \
 -d '{"title":"cluster_prod_34:kube-system","description":"auto","index_set_id":"INDEX_SET_ID","matching_type":"AND"}' | jq .
```

**Create pipeline rule** (UI is easier; API endpoint exists `/api/plugins/org.graylog.plugins.pipelineprocessor/rules`).

**Attach pipeline to stream** (UI recommended).

---

# Final checklist before enabling in production

* [ ] Streams created & `stream_id` recorded for all dividing_name values (or at least the important ones)
* [ ] Lookup table present and returns correct stream IDs
* [ ] Pipeline rule deployed and attached to `all_k8s_logs`
* [ ] `remove_from_default_stream()` works as expected (no duplicate messages)
* [ ] Index sets configured for retention + daily rotation
* [ ] Monitor CPU/Memory and pipeline processing buffer after rollout
