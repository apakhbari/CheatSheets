# TOPUP Index Archival — Graylog / OpenSearch on Kubernetes

**Date:** July 25, 2026
**Environment:** Graylog + OpenSearch cluster on Kubernetes (k3s), namespace `graylog`, backed by an NFS-based OpenMediaVault server for snapshot storage
**Objective:** Archive old `topup_N` indices (index set `TOPUP`, Index Time rotation, P1D) off the live OpenSearch cluster to free disk space, using native OpenSearch snapshots to an NFS repository, with future automation.

---

## Table of Contents

1. [Environment Summary](#1-environment-summary)
2. [Strategy Decision](#2-strategy-decision)
3. [NFS Server Setup (OpenMediaVault)](#3-nfs-server-setup-openmediavault)
4. [Kubernetes Configuration Changes](#4-kubernetes-configuration-changes)
5. [Issues Encountered During Rollout](#5-issues-encountered-during-rollout)
6. [Snapshot Repository Registration](#6-snapshot-repository-registration)
7. [Test Snapshot & Validation](#7-test-snapshot--validation)
8. [Full Snapshot of topup_0–topup_10](#8-full-snapshot-of-topup_0topup_10)
9. [Restore Verification Attempt](#9-restore-verification-attempt)
10. [Production Incident: Disk Full / Graylog Down](#10-production-incident-disk-full--graylog-down)
11. [Post-Incident Cleanup](#11-post-incident-cleanup)
12. [Future Automation Plan](#12-future-automation-plan)
13. [Lessons Learned / Recommendations](#13-lessons-learned--recommendations)
14. [Command Reference Appendix](#14-command-reference-appendix)

---

## 1. Environment Summary

| Component | Detail |
|---|---|
| Namespace | `graylog` |
| OpenSearch | 3-node cluster, StatefulSet `opensearch-cluster-master`, image `opensearchproject/opensearch:2.11.0` |
| OpenSearch nodes | `opensearch-cluster-master-0/1/2`, 300Gi PVC each, `nfs-storage` StorageClass |
| Graylog | `graylog-0`, index set `TOPUP`, rotation strategy: Index Time, period P1D |
| K8s nodes | `graylog02` (.151), `graylog03` (.152), `graylog04` (.153) — k3s cluster |
| NFS/backup server | OpenMediaVault, IP `10.10.21.161`, dedicated disk `sdb` (500G), shared folder `opensearch-snapshots`, exported path `/export/opensearch-snapshots` |
| Container registry | Private mirror at `registry.eniac-tech.com` used as fallback for the OpenSearch image (Docker Hub pull issue encountered — see [Section 5](#5-issues-encountered-during-rollout)) |
| Active write index at time of work | `topup_38`–onward range; archived range was `topup_0`–`topup_10` |

---

## 2. Strategy Decision

Two export strategies were considered:

- **Option A — `elasticdump`**: exports raw `_source` documents as JSON, no cluster reconfiguration needed, but slower and loses native index structure (requires reindexing to restore).
- **Option B — OpenSearch native snapshot/restore** *(chosen)*: preserves mappings/settings exactly, restore is a single API call, and is the officially supported mechanism for this kind of archival. Required one-time setup: `path.repo` configuration and a shared filesystem repository accessible from all 3 OpenSearch nodes.

Snapshot/restore was selected since the goal was recurring, ongoing archival (bi-weekly/15-day cadence), not a one-off export.

---

## 3. NFS Server Setup (OpenMediaVault)

- Created a shared folder on OMV: device `/dev/sdb1`, relative path `opensearch-snapshots/`, 500G capacity.
- Enabled the NFS service and added a share for the 3 Kubernetes node IPs (`10.10.21.151`–`.153`).
- Exported path confirmed via `showmount -e 10.10.21.161` → `/export/opensearch-snapshots`.
- **Permission issue encountered:** initial mount succeeded (root could `touch` a test file), but the OpenSearch container (running as **uid 1000**, non-root) got `Permission denied` writing to the same mount.
  - Root cause: NFS export squash settings (`all_squash` remapping client UIDs) and/or ownership on the OMV-side directory not matching uid 1000.
  - Resolved by correcting ownership/squash settings on the OMV export so uid 1000 has write access. Verified via `touch` test executed inside each OpenSearch pod.

---

## 4. Kubernetes Configuration Changes

OpenSearch in this cluster is deployed via **Helm** (chart `opensearch`, release `opensearch`, namespace `graylog`) — confirmed via the `meta.helm.sh/release-name` annotation on the StatefulSet, even though this wasn't known at the start of the exercise.

Changes made directly to the live StatefulSet and its ConfigMap:

**ConfigMap (`opensearch-cluster-master-config`) — added to `opensearch.yml`:**
```yaml
path.repo: ["/usr/share/opensearch/snapshots"]
```

**StatefulSet — added volume:**
```yaml
- name: snapshot-repo
  nfs:
    server: 10.10.21.161
    path: /export/opensearch-snapshots
```

**StatefulSet — added volumeMount (on the `opensearch` container):**
```yaml
- name: snapshot-repo
  mountPath: /usr/share/opensearch/snapshots
```

Rollout was applied via `kubectl rollout restart statefulset/opensearch-cluster-master -n graylog`.

---

## 5. Issues Encountered During Rollout

| Issue | Cause | Resolution |
|---|---|---|
| `mount.nfs: ... No such file or directory` | StatefulSet volume `path` initially set to `/sdb/opensearch-snapshots` (the raw OMV disk path) instead of the actual NFS **export** path | Corrected to `/export/opensearch-snapshots` (verified via `showmount -e`) |
| Stuck pod after path fix | Pod already in `Init` state with the old spec baked in didn't self-heal | `kubectl delete pod opensearch-cluster-master-2 -n graylog` to force recreation with corrected spec |
| `ErrImagePull` — `opensearchproject/opensearch:2.11.0` on Docker Hub | Docker Hub pull failure/rate limiting from that node | Pulled the same image tag from an internal mirror, `registry.eniac-tech.com/opensearchproject/opensearch:2.11.0`; updated the StatefulSet's image reference (both the main `opensearch` container and the `configfile` init container) |
| `touch: Permission denied` on NFS mount from within pods | NFS squash / ownership mismatch vs. container's uid 1000 | Corrected OMV export squash setting and directory ownership (see [Section 3](#3-nfs-server-setup-openmediavault)) |
| `podManagementPolicy: Parallel` risk | This StatefulSet setting could allow all 3 OpenSearch pods to restart simultaneously under `rollout restart`, risking loss of quorum | Noted as a risk; subsequent restarts done one pod at a time (`kubectl delete pod <name>`, waiting for green health between each) as a safer practice going forward |

All three OpenSearch pods reached `1/1 Running` with the NFS mount present, writable, and confirmed via `df -h` + `touch` test after these fixes.

---

## 6. Snapshot Repository Registration

```bash
curl -X PUT "http://localhost:9200/_snapshot/topup_archive" \
  -H 'Content-Type: application/json' -d '{
    "type": "fs",
    "settings": {
      "location": "/usr/share/opensearch/snapshots",
      "compress": true
    }
  }'
```
Repository `topup_archive` registered and confirmed reachable from all 3 nodes.

---

## 7. Test Snapshot & Validation

A single-index test snapshot (`test-snap-1`, index `topup_0`) was run first to validate the full pipeline end-to-end before committing to the real archive:

- Result: `"state": "SUCCESS"`, 1/1 shards successful, ~3.5 minutes.
- Confirmed on the OMV disk: snapshot metadata (`meta-*.dat`, `snap-*.dat`) and index blob directory present under `opensearch-snapshots/`.
- Test snapshot deleted afterward via `DELETE /_snapshot/topup_archive/test-snap-1` (source index untouched).

---

## 8. Full Snapshot of topup_0–topup_10

```bash
nohup kubectl exec -n graylog opensearch-cluster-master-0 -- curl -s -X PUT \
  "http://localhost:9200/_snapshot/topup_archive/topup-manual-$(date +%Y%m%d)?wait_for_completion=true" \
  -H 'Content-Type: application/json' \
  -d '{
    "indices": "topup_0,topup_1,topup_2,topup_3,topup_4,topup_5,topup_6,topup_7,topup_8,topup_9,topup_10",
    "ignore_unavailable": false,
    "include_global_state": false
  }' > /root/opensearch-bk/snapshot-result.json 2>&1 &

echo "started, PID $!"
```

or

```bash
curl -X PUT "http://localhost:9200/_snapshot/topup_archive/topup-manual-20260725?wait_for_completion=true" \
  -H 'Content-Type: application/json' \
  -d '{
    "indices": "topup_0,topup_1,topup_2,topup_3,topup_4,topup_5,topup_6,topup_7,topup_8,topup_9,topup_10",
    "ignore_unavailable": false,
    "include_global_state": false
  }'
```

**Result:**
- `"state": "SUCCESS"`
- 11/11 shards successful, 0 failed
- Duration: ~20.5 minutes (`1,234,811 ms`)
- Snapshot name: `topup-manual-20260725`

**Live document counts at time of snapshot** (for reference / future reconciliation):

| Index | Docs |
|---|---|
| topup_0 | 11,249,100 |
| topup_1 | 15,356,864 |
| topup_2 | 15,182,806 |
| topup_3 | 15,523,950 |
| topup_4 | 13,763,090 |
| topup_5 | 13,520,916 |
| topup_6 | 17,092,594 |
| topup_7 | 16,762,525 |
| topup_8 | 17,610,368 |
| topup_9 | 17,374,368 |
| topup_10 | 13,851,549 |
| **Total** | **~167.3 million docs** |

---

## 9. Restore Verification Attempt

A restore test was attempted on the **live production cluster** by restoring `topup_0`, `topup_5`, `topup_10` under renamed indices (`restore_verify_*`) to confirm the snapshot was genuinely usable, not just reported as successful.

- **Result:** restore did not succeed — `_count` returned `null` for the restored indices, and `_search` against them returned `503 search_phase_execution_exception` with no shards assigned.
- **Cause:** the production cluster's disk was already at/near capacity, so OpenSearch's flood-stage watermark blocked new shard allocation — restoring test copies onto an already-full disk is inherently circular.
- **Recommended (not yet executed) alternative:** validate restorability on a separate, disposable OpenSearch instance pointed at the same NFS repository, so restore testing doesn't compete with production for disk space.

This attempt directly surfaced the disk-full condition described in the next section.

---

## 10. Production Incident: Disk Full / Graylog Down

While investigating the restore-verification failure, it was confirmed that:
- OpenSearch disk usage was at/near the flood-stage watermark.
- Graylog (`graylog-0`) was crash-looping (185+ restarts) and unable to write to OpenSearch.
- Graylog's UI was unavailable, so indices could not be deleted through the normal System → Indices workflow.

**Emergency action taken** (justified by the already-verified `SUCCESS` state and 0 failed shards of the `topup-manual-20260725` snapshot):

```bash
curl -X DELETE "http://localhost:9200/topup_0,topup_1,topup_2,topup_3,topup_4,topup_5,topup_6,topup_7,topup_8,topup_9,topup_10"
```

Followed by clearing the read-only block OpenSearch applies automatically once the flood-stage watermark is crossed:

```bash
curl -X PUT "http://localhost:9200/_all/_settings" \
  -H 'Content-Type: application/json' \
  -d '{"index.blocks.read_only_allow_delete": null}'
```

Graylog's health and pod status were then rechecked, with a pod recreation (`kubectl delete pod graylog-0 -n graylog`) planned if it did not recover once OpenSearch returned to a writable, healthy state.

---

## 11. Post-Incident Cleanup

Because the 11 indices were deleted **directly against OpenSearch** (Graylog's UI was unavailable at the time) rather than through Graylog's own index-deletion workflow, Graylog's internal `index_ranges` metadata (stored in MongoDB) was left out of sync with the actual state of the cluster.

**Follow-up action (once Graylog is confirmed healthy):**
System → Indices → TOPUP index set → **Recalculate index ranges**, to resync Graylog's metadata against what actually exists in OpenSearch.

---

## 12. Future Automation Plan

A cron/systemd-based script (`archive_topup.sh`) was drafted to automate this process going forward, on a **15-day** cadence:

- Auto-detects the active write index (via Graylog API, with a fallback to the highest `topup_N`) so it's never included in the snapshot/delete cycle.
- Selects indices older than `RETAIN_DAYS` (15) by actual `creation_date`, not by index number.
- Names each snapshot using the real creation-date range it covers (e.g. `topup-YYYYMMDD_to_YYYYMMDD-run<timestamp>`).
- Verifies snapshot state == `SUCCESS` before proceeding.
- tar.gz's the snapshot repository onto the NFS `sdb` disk as an additional standalone backup copy.
- Deletes archived indices via the **Graylog API** (not raw OpenSearch `DELETE`) specifically to keep `index_ranges` metadata in sync — the exact problem hit manually in [Section 11](#11-post-incident-cleanup).
- Scheduled via a `systemd` timer (`OnUnitActiveSec=15d`) rather than cron, for an exact rolling interval independent of calendar month boundaries.

Deployment of this automation is a follow-up task, pending: filling in Graylog API token / index-set ID, and a first supervised manual run with the delete step disabled.

---

## 13. Lessons Learned / Recommendations

1. **Always confirm the real NFS export path** via `showmount -e`, don't assume it matches the raw disk path configured in the storage UI.
2. **uid/gid mismatches between containers and NFS exports are a common silent failure** — validate write access with a `touch` test from inside the actual container, not just as root from the host.
3. **`podManagementPolicy: Parallel` is a quorum risk** for StatefulSets during rollouts — prefer manual, one-pod-at-a-time restarts for clusters like OpenSearch that depend on quorum.
4. **Restore-testing on a disk-constrained production cluster is circular** — use a disposable, separate instance against the same repository for genuine restore validation.
5. **Deleting indices directly against OpenSearch (bypassing Graylog) leaves stale metadata** — always follow up with an index-range recalculation if this happens out of necessity.
6. **A private registry mirror is valuable** as a fallback for container images when Docker Hub pulls fail or are rate-limited mid-incident.
7. **Disk-space monitoring/alerting** on the OpenSearch PVCs would have surfaced the capacity issue before it caused a production incident — worth setting up going forward alongside the 15-day archival automation.

---

## 14. Command Reference Appendix

```bash
# Repository registration
curl -X PUT "http://localhost:9200/_snapshot/topup_archive" -H 'Content-Type: application/json' -d '{"type":"fs","settings":{"location":"/usr/share/opensearch/snapshots","compress":true}}'

# Snapshot
curl -X PUT "http://localhost:9200/_snapshot/topup_archive/topup-manual-20260725?wait_for_completion=true" -H 'Content-Type: application/json' -d '{"indices":"topup_0,topup_1,topup_2,topup_3,topup_4,topup_5,topup_6,topup_7,topup_8,topup_9,topup_10","ignore_unavailable":false,"include_global_state":false}'

# Snapshot status check
curl "http://localhost:9200/_snapshot/topup_archive/topup-manual-20260725?pretty"

# Doc count check
curl "http://localhost:9200/topup_0/_count"

# Restore (verification / recovery)
curl -X POST "http://localhost:9200/_snapshot/topup_archive/topup-manual-20260725/_restore" -H 'Content-Type: application/json' -d '{"indices":"topup_0","rename_pattern":"topup_(.+)","rename_replacement":"restore_verify_$1"}'

# Emergency delete (used in the Section 10 incident)
curl -X DELETE "http://localhost:9200/topup_0,topup_1,topup_2,topup_3,topup_4,topup_5,topup_6,topup_7,topup_8,topup_9,topup_10"

# Clear read-only block after freeing disk space
curl -X PUT "http://localhost:9200/_all/_settings" -H 'Content-Type: application/json' -d '{"index.blocks.read_only_allow_delete": null}'

# Cluster/disk health checks
curl "http://localhost:9200/_cluster/health?pretty"
curl "http://localhost:9200/_cat/allocation?v"
curl "http://localhost:9200/_cluster/allocation/explain?pretty"
```