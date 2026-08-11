#!/usr/bin/env bash
#
# cleanup_fields_queue.sh
#
# Processes a range of indices (default topup_33 .. topup_50) with a fixed
# concurrency (default 2 at a time). As soon as one job finishes, the next
# index in the queue is started, keeping N jobs running until the queue
# is empty. Logs everything to console + a logfile so you can walk away
# and check progress later.
#
# USAGE:
#   ./cleanup_fields_queue.sh
#   START_IDX=33 END_IDX=50 CONCURRENCY=2 ./cleanup_fields_queue.sh
#   INDICES="topup_33 topup_34 topup_40 topup_41" ./cleanup_fields_queue.sh   # explicit list instead of a range
#
# ENV VARS:
#   OS_HOST         OpenSearch endpoint (default: http://localhost:31101)
#   INDEX_PREFIX    Prefix for range mode (default: topup_)
#   START_IDX       First index number in range (default: 33)
#   END_IDX         Last index number in range, inclusive (default: 50)
#   INDICES         Space-separated explicit index list; overrides range mode if set
#   CONCURRENCY     How many indices to process at once (default: 2)
#   MAX_DISK_PCT    Refuse to launch new jobs if any node >= this % (default: 88)
#   POLL_INTERVAL   Seconds between status polls (default: 20)
#   SCROLL_SIZE     Docs per scroll batch (default: 500 -- lower reduces circuit-breaker risk)
#   AUTO_CLEAR_BLOCK  "1" to auto-clear index.blocks.write if present (default: 1)
#   LOG_FILE        Path to logfile (default: ./cleanup_fields_queue.log)
#   PID_FILE        Path to pidfile (default: ./cleanup_fields_queue.pid)
#   BACKGROUND      "1" (default) to auto-detach into the background and survive SSH
#                    disconnects; set to "0" to run in the foreground of the current shell.
#
# CONTROL COMMANDS (run the script with these as the first argument):
#   ./cleanup_fields_queue.sh status    # is a run currently active? show last log lines
#   ./cleanup_fields_queue.sh stop      # stop the currently running background job
#   ./cleanup_fields_queue.sh tail      # tail -f the logfile
#
# NOTE ON STOPPING: "stop" kills the *local* queue-management loop (i.e. it stops
# launching new indices), but any update_by_query job already dispatched to
# OpenSearch keeps running server-side -- that's normal and safe. To cancel an
# in-flight OpenSearch task itself:
#   curl -s -X POST "http://localhost:31101/_tasks/<task_id>/_cancel"

set -uo pipefail

OS_HOST="${OS_HOST:-http://localhost:31101}"
INDEX_PREFIX="${INDEX_PREFIX:-topup_}"
START_IDX="${START_IDX:-33}"
END_IDX="${END_IDX:-50}"
CONCURRENCY="${CONCURRENCY:-2}"
MAX_DISK_PCT="${MAX_DISK_PCT:-88}"
POLL_INTERVAL="${POLL_INTERVAL:-20}"
SCROLL_SIZE="${SCROLL_SIZE:-500}"
AUTO_CLEAR_BLOCK="${AUTO_CLEAR_BLOCK:-1}"
LOG_FILE="${LOG_FILE:-./cleanup_fields_queue.log}"
PID_FILE="${PID_FILE:-./cleanup_fields_queue.pid}"
BACKGROUND="${BACKGROUND:-1}"

for bin in curl jq bc; do
  command -v "$bin" >/dev/null 2>&1 || { echo "ERROR: '$bin' is required but not installed."; exit 1; }
done

# ---------------------------------------------------------------------------
# Control-command mode: status / stop / tail
# ---------------------------------------------------------------------------
cmd="${1:-}"
if [[ "$cmd" == "status" ]]; then
  if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
    echo "Running. PID=$(cat "$PID_FILE")"
  else
    echo "Not running (no live process for PID file: ${PID_FILE})."
  fi
  echo
  echo "--- last 20 log lines (${LOG_FILE}) ---"
  tail -n 20 "$LOG_FILE" 2>/dev/null || echo "(no log file yet)"
  exit 0
fi

if [[ "$cmd" == "stop" ]]; then
  if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
    pid=$(cat "$PID_FILE")
    echo "Stopping queue manager (PID=${pid})..."
    kill "$pid"
    rm -f "$PID_FILE"
    echo "Stopped. NOTE: any OpenSearch update_by_query tasks already dispatched"
    echo "keep running server-side. Cancel individually if needed:"
    echo "  curl -s '${OS_HOST}/_tasks?actions=*byquery&detailed=true&pretty'"
    echo "  curl -s -X POST '${OS_HOST}/_tasks/<task_id>/_cancel'"
  else
    echo "Not running (no live process for PID file: ${PID_FILE})."
  fi
  exit 0
fi

if [[ "$cmd" == "tail" ]]; then
  tail -f "$LOG_FILE"
  exit 0
fi

# ---------------------------------------------------------------------------
# Prevent starting a second run while one is already active
# ---------------------------------------------------------------------------
if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
  echo "!! A queue run is already active (PID=$(cat "$PID_FILE"))."
  echo "   Use '$0 status' or '$0 stop' first."
  exit 1
fi

# ---------------------------------------------------------------------------
# Self-detach into the background (survives SSH disconnects) unless BACKGROUND=0
# or we're already the detached child (_QUEUE_DETACHED=1).
# ---------------------------------------------------------------------------
if [[ "$BACKGROUND" == "1" && "${_QUEUE_DETACHED:-0}" != "1" ]]; then
  echo "Launching in the background. Log: ${LOG_FILE}  PID file: ${PID_FILE}"
  export _QUEUE_DETACHED=1
  nohup setsid "$0" "$@" >>"${LOG_FILE}" 2>&1 &
  disown
  echo "$!" > "$PID_FILE"
  echo "Started. PID=$! (survives SSH disconnect)"
  echo "  Check progress : $0 status"
  echo "  Follow live    : $0 tail    (or: tail -f ${LOG_FILE})"
  echo "  Stop it        : $0 stop"
  exit 0
fi

# from here on we are either the detached background process, or BACKGROUND=0
echo $$ > "$PID_FILE"
trap 'rm -f "$PID_FILE"' EXIT

# ---------------------------------------------------------------------------
# Build the index queue
# ---------------------------------------------------------------------------
if [[ -n "${INDICES:-}" ]]; then
  read -r -a QUEUE <<< "$INDICES"
else
  QUEUE=()
  for ((n=START_IDX; n<=END_IDX; n++)); do
    QUEUE+=("${INDEX_PREFIX}${n}")
  done
fi

FIELDS=(
  kubernetes_annotations_cni_projectcalico_org_containerID
  kubernetes_annotations_cni_projectcalico_org_podIP
  kubernetes_annotations_cni_projectcalico_org_podIPs
  kubernetes_annotations_prometheus_io_path
  kubernetes_annotations_prometheus_io_port
  kubernetes_annotations_prometheus_io_scrape
  kubernetes_container_hash
  kubernetes_container_image
  kubernetes_docker_id
  kubernetes_container_name
  kubernetes_labels_app_kubernetes_io_name
  "kubernetes_labels_pod-template-hash"
  kubernetes_pod_id
  source
)

SCRIPT_SRC=""
for f in "${FIELDS[@]}"; do
  SCRIPT_SRC+="if (ctx._source.containsKey('${f}')) { ctx._source.remove('${f}'); } "
done
SCRIPT_JSON=$(printf '%s' "$SCRIPT_SRC" | jq -Rs .)
BODY=$(cat <<EOF
{
  "script": { "lang": "painless", "source": ${SCRIPT_JSON} },
  "query": { "match_all": {} }
}
EOF
)

# ---------------------------------------------------------------------------
# logging helper -- prints to console AND appends to LOG_FILE
# ---------------------------------------------------------------------------
log() {
  local msg="[$(date '+%Y-%m-%d %H:%M:%S')] $*"
  echo "$msg" | tee -a "$LOG_FILE"
}

log "==================================================================="
log "Queue run starting. Host=${OS_HOST} Concurrency=${CONCURRENCY} ScrollSize=${SCROLL_SIZE}"
log "Queue (${#QUEUE[@]} indices): ${QUEUE[*]}"
log "Log file: ${LOG_FILE}"
log "==================================================================="

# ---------------------------------------------------------------------------
# Pre-flight: cluster health
# ---------------------------------------------------------------------------
HEALTH=$(curl -s "${OS_HOST}/_cluster/health?pretty")
STATUS=$(echo "$HEALTH" | jq -r '.status')
log "Cluster status: ${STATUS}"
if [[ "$STATUS" == "red" ]]; then
  log "!! Cluster is RED. Refusing to start. Check _cluster/allocation/explain."
  exit 1
fi

check_disk_ok() {
  local alloc max_pct
  alloc=$(curl -s "${OS_HOST}/_cat/allocation?v")
  max_pct=$(echo "$alloc" | awk 'NR>1 && $6 ~ /^[0-9]+$/ {print $6}' | sort -n | tail -1)
  if [[ -n "$max_pct" && "$max_pct" -ge "$MAX_DISK_PCT" ]]; then
    log "!! Disk usage at ${max_pct}% (limit ${MAX_DISK_PCT}%) -- pausing new launches."
    return 1
  fi
  return 0
}

# ---------------------------------------------------------------------------
# Launch one index's update_by_query job. Prints task id to stdout on success.
# ---------------------------------------------------------------------------
launch_job() {
  local idx="$1"

  local blocks
  blocks=$(curl -s "${OS_HOST}/${idx}/_settings" 2>/dev/null | jq -r ".\"${idx}\".settings.index.blocks.write // \"false\"" 2>/dev/null)
  if [[ "$blocks" == "true" ]]; then
    if [[ "$AUTO_CLEAR_BLOCK" == "1" ]]; then
      log "[$idx] index.blocks.write=true -- clearing."
      curl -s -X PUT "${OS_HOST}/${idx}/_settings" -H 'Content-Type: application/json' \
        -d '{"index.blocks.write": null}' >/dev/null
    else
      log "[$idx] !! write-blocked and AUTO_CLEAR_BLOCK=0 -- SKIPPING."
      echo ""
      return
    fi
  fi

  local docs
  docs=$(curl -s "${OS_HOST}/${idx}/_count" 2>/dev/null | jq -r '.count // "unknown"')
  log "[$idx] doc count: ${docs}"

  local resp tid
  resp=$(curl -s -X POST \
    "${OS_HOST}/${idx}/_update_by_query?conflicts=proceed&wait_for_completion=false&slices=auto&scroll_size=${SCROLL_SIZE}" \
    -H 'Content-Type: application/json' -d "${BODY}")
  tid=$(echo "$resp" | jq -r '.task // empty')

  if [[ -z "$tid" ]]; then
    log "[$idx] !! FAILED TO START: $(echo "$resp" | jq -c .)"
    echo ""
    return
  fi

  log "[$idx] STARTED task=${tid} (scroll_size=${SCROLL_SIZE})"
  echo "$tid"
}

# ---------------------------------------------------------------------------
# Main queue loop: keep CONCURRENCY jobs running until queue is drained
# ---------------------------------------------------------------------------
declare -A ACTIVE_TASK      # idx -> task_id
declare -A ACTIVE_START     # idx -> epoch start time
declare -a SUCCESS_LIST=()
declare -a FAILED_LIST=()
declare -a SKIPPED_LIST=()

QUEUE_POS=0
TOTAL_QUEUED=${#QUEUE[@]}

fill_slots() {
  while [[ ${#ACTIVE_TASK[@]} -lt "$CONCURRENCY" && $QUEUE_POS -lt $TOTAL_QUEUED ]]; do
    if ! check_disk_ok; then
      log "Holding off on launching new jobs until disk usage drops below ${MAX_DISK_PCT}%."
      break
    fi
    local idx="${QUEUE[$QUEUE_POS]}"
    QUEUE_POS=$((QUEUE_POS+1))
    local tid
    tid=$(launch_job "$idx")
    if [[ -n "$tid" ]]; then
      ACTIVE_TASK[$idx]="$tid"
      ACTIVE_START[$idx]=$(date +%s)
    else
      SKIPPED_LIST+=("$idx")
    fi
  done
}

fill_slots

while [[ ${#ACTIVE_TASK[@]} -gt 0 || $QUEUE_POS -lt $TOTAL_QUEUED ]]; do
  sleep "${POLL_INTERVAL}"

  log "--- status: $((${#SUCCESS_LIST[@]})) done, $((${#FAILED_LIST[@]})) failed, ${#ACTIVE_TASK[@]} active, $((TOTAL_QUEUED - QUEUE_POS)) queued ---"

  for idx in "${!ACTIVE_TASK[@]}"; do
    tid="${ACTIVE_TASK[$idx]}"
    resp=$(curl -s "${OS_HOST}/_tasks/${tid}")
    completed=$(echo "$resp" | jq -r '.completed // empty')

    if [[ -z "$completed" ]]; then
      log "[$idx] task lookup failed this cycle (will retry) -- possible .tasks index hiccup."
      continue
    fi

    updated=$(echo "$resp" | jq -r '.task.status.updated // .response.updated // 0')
    total=$(echo "$resp" | jq -r '.task.status.total // .response.total // 0')
    runtime_ns=$(echo "$resp" | jq -r '.task.running_time_in_nanos // 0')
    runtime_sec=$(echo "scale=2; ${runtime_ns}/1000000000" | bc)

    if [[ "$completed" == "true" ]]; then
      elapsed=$(( $(date +%s) - ${ACTIVE_START[$idx]} ))
      elapsed_h=$((elapsed/3600)); elapsed_m=$(((elapsed%3600)/60))
      error=$(echo "$resp" | jq -r '.error.type // empty')
      failcount=$(echo "$resp" | jq -r '.response.failures | length // 0' 2>/dev/null || echo 0)

      if [[ -n "$error" ]]; then
        log "[$idx] !! ERROR after ${elapsed_h}h${elapsed_m}m -- ${error}: $(echo "$resp" | jq -r '.error.reason // "" ' | head -c 200)"
        FAILED_LIST+=("$idx")
      elif [[ "$failcount" != "0" && "$failcount" != "null" ]]; then
        log "[$idx] !! COMPLETED WITH ${failcount} DOC FAILURES after ${elapsed_h}h${elapsed_m}m (updated=${updated}/${total})"
        FAILED_LIST+=("$idx")
      else
        log "[$idx] SUCCESS -- updated=${updated}/${total} in ${elapsed_h}h${elapsed_m}m"
        SUCCESS_LIST+=("$idx")
      fi

      unset 'ACTIVE_TASK[$idx]'
      unset 'ACTIVE_START[$idx]'
    else
      rate="0"; eta="n/a"; pct="0"
      if (( $(echo "$runtime_sec > 0" | bc -l) )); then
        rate=$(echo "scale=1; ${updated}/${runtime_sec}" | bc)
        if (( $(echo "$rate > 0" | bc -l) )); then
          remain=$(( total - updated ))
          eta_sec=$(echo "scale=0; ${remain}/${rate}" | bc)
          eta=$(printf '%dh%02dm' $((eta_sec/3600)) $(((eta_sec%3600)/60)))
        fi
      fi
      if [[ "$total" != "0" ]]; then
        pct=$(echo "scale=1; ${updated}*100/${total}" | bc)
      fi
      log "[$idx] running -- ${updated}/${total} (${pct}%) rate=${rate}/s ETA=${eta}"
    fi
  done

  # top up any freed slots with the next queued index/indices
  fill_slots
done

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
log "==================================================================="
log "QUEUE COMPLETE"
log "  Success (${#SUCCESS_LIST[@]}): ${SUCCESS_LIST[*]:-none}"
log "  Failed  (${#FAILED_LIST[@]}): ${FAILED_LIST[*]:-none}"
log "  Skipped (${#SKIPPED_LIST[@]}): ${SKIPPED_LIST[*]:-none}"
log "==================================================================="

if [[ ${#FAILED_LIST[@]} -gt 0 ]]; then
  log "To retry failed indices (jobs are idempotent -- safe to rerun):"
  log "  INDICES=\"${FAILED_LIST[*]}\" $0"
fi

log "Spot-check a doc per completed index, e.g.:"
for idx in "${SUCCESS_LIST[@]:-}"; do
  [[ -n "$idx" ]] && log "  curl -s '${OS_HOST}/${idx}/_search?size=1&pretty' | jq '._source | keys'"
done