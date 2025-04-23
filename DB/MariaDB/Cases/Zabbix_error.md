Q:
- I have a problem with my Databases on my ubuntu server. I have Galera clusters and am using MariaDB. I am getting below Zabbix alert several times per day for different databases, the problem is solved after 3-5 minutes after arising. I have Zabbix-Agent-2 on my databases servers. Databases are seem to be working fine and I don't know where/how to start troubleshooting what may cause this issue. Give me some ways to further troubleshoot my problem.
```
This is my zabbix alert:
MySQL: Service is down
{EVENT.TIME}-{EVENT.DATE} --> 12:56:57-2025.04.19
{EVENT.NAME} --> MySQL: Service is down
{HOST.NAME}
{EVENT.SEVERITY} --> High
{EVENT.OPDATA} --> Down (0)
{EVENT.ID} --> 45829343
```

A:

Below is a structured “cook‑book” you can run through the next time the alarm fires.  
Treat it as a funnel: start with the easy, observational checks at the top and work downward until you find a culprit.

---

## 1  Confirm whether MariaDB was *really* down

| What to do | How | Why |
|------------|-----|-----|
| **Ping the socket/port immediately** | `mysqladmin --defaults-file=/root/.my.cnf ping` or `zabbix_get -s <host-ip> -k mysql.ping` | Proves whether the server was unreachable *for Zabbix* or truly offline. |
| **Look at systemd state** | `systemctl status mariadb` | Shows if systemd restarted it, how long it has been **active (running)**, and the last exit code. |
| **Check the MariaDB error log** | `journalctl -u mariadb -S -10m` (last 10 min) or open `/var/log/mysql/error.log` | Any crash, SST/IST, “WSREP: declaring cluster unsafe”, or OOM event is usually logged here. |

*If these three checks show the server was alive the whole time, you are hunting a “false positive” on the Zabbix side; if they show crashes/restarts, skip to §3.*

---

## 2  Rule out Zabbix false‑positives

1. **Find the exact trigger logic**  
   *Template DB MySQL* ships a trigger like  
   ```
   {mysql.ping.last()}=0
   or
   {mysql.ping.nodata(300)}=1
   ```  
   – A busy node that takes >5 s to answer *mysql.ping* (defaults in agent2) will evaluate as “0”.

2. **Check the item’s execution time**  
   In *Monitoring → Latest data* pick **mysql.ping** → *History* → see if the value occasionally turns “0” or simply disappears (no data).

3. **Increase the timeout just for that item**  
   *Configuration → Hosts → Items* → **mysql.ping** → *Advanced* → set *Timeout (in seconds)* to “10” or “15”.  
   (Agent 2 obeys the per‑item Timeout even if `Timeout=` in `zabbix_agent2.conf` is shorter.)

4. **Compare with node load**  
   In the same 3‑5 min window, overlay CPU‑steal, disk I/O wait and network latency.  
   If the ping gaps match spikes, it is simply a performance hiccup, not a DB failure.

5. **Network blips**  
   Because Galera typically listens on `3306`/`4444`/`4567`, a short network partition can make only *one* node unreachable while the cluster continues.  
   - Run `mtr -r -w <db-host>`, see if packet loss creeps in.  
   - If you virtualise, look at the hypervisor’s vSwitch or SD‑WAN logs.

---

## 3  If the server *did* restart/crash

| Suspect | Check | Typical evidence |
|---------|-------|------------------|
| **Out‑of‑Memory killer** | `journalctl -k -S "1h ago" | grep -B2 -A3 "Killed process"` | Lines like `Killed process 12345 (mysqld) total-vm:...` |
| **Galera SST / IST** (state transfer) | error log shows `WSREP_SST:` lines, large rsync, node in **Donor/Desynced** state | Cluster size temporarily drops; `wsrep_local_state_comment` = **State transfer** |
| **Crash in wsrep provider** | Look for `SIGABRT`, `Assertion failure`, or `segfault` in error log | Sudden exit, followed by systemd restart |
| **Disk / I/O stall** | `dmesg | grep -i "blk_update_request"` or smartctl errors | MariaDB aborts due to `InnoDB: Unable to read/write data` |
| **Kernel / libc upgrade with unattended‑upgrades** | `/var/log/apt/history.log` shows an upgrade a few minutes earlier | Ubuntu may auto‑restart services post‑upgrade |

*When you find a suspect above, focus investigation on that subsystem, e.g. memory sizing, SST method, hardware health, etc.*

---

## 4  Galera‑specific health probes to run **after** an incident

```bash
mysql -e "SHOW GLOBAL STATUS LIKE 'wsrep_%'\G"
mysql -e "SELECT VARIABLE_VALUE FROM performance_schema.global_status WHERE VARIABLE_NAME IN ('Threads_running','Uptime')\G"
```

Key fields:

| Name | Healthy value |
|------|---------------|
| `wsrep_cluster_size` | Full node count |
| `wsrep_cluster_status` | **Primary** | 
| `wsrep_local_state_comment` | **Synced** |
| `wsrep_flow_control_paused` | 0.0 or very small fraction |

Log the output to a file after every alert; over a day or two you’ll see whether the cluster is shrinking, stalling (flow‑control), or simply fine.

---

## 5  Hardening & long‑term monitoring improvements

1. **Move DB checks to the loopback interface**  
   Create a `UserParameter=mysql.local_ping,/usr/bin/mysqladmin ping` item that talks to `127.0.0.1`. Network jitter between Zabbix‑server and node then won’t trip the trigger.

2. **Enable the built‑in MariaDB *connection_health_check* plugin** (MariaDB 10.6+)   
   Adds a lightweight “heartbeat” you can scrape:  
   ```sql
   INSTALL SONAME 'connection_health_check';
   SELECT CONNECTION_ID(), INFO FROM INFORMATION_SCHEMA.PROCESSLIST WHERE INFO LIKE '/* Health check ping %';
   ```

3. **Graceful trigger** – require 2 consecutive failures  
   Change the trigger to:  
   ```
   {mysql.ping.last()}=0 and
   {mysql.ping.prev(,#2)}=0
   ```  
   (fires only if two polls are bad, cutting one‑off false alerts).

4. **Bundle a post‑failure evidence script**  
   Place `/usr/local/bin/db-snapshot.sh`:

   ```bash
   #!/bin/bash
   ts=$(date +%F_%T)
   mysql -e "SHOW GLOBAL STATUS INTO OUTFILE '/tmp/status_$ts.txt'"
   systemctl status mariadb > /tmp/mariadb_status_$ts.txt
   journalctl -u mariadb -S -2min > /tmp/mariadb_journal_$ts.txt
   tar czf /tmp/db_incident_$ts.tgz /tmp/*_$ts.txt
   ```
   Run it via Zabbix “Remote command” whenever the trigger fires; you’ll always have artefacts even if the node recovers.

---

## 6  When to widen the investigation

- If *all* nodes in the cluster alert at the **same second** ⇒ look at network core, firewall, or Zabbix‑server overload.  
- If only one node alerts repeatedly ⇒ likely local resource or guest‑host networking problem.  
- If alerts happen **just after midnight** (or your backup window) ⇒ check dump/backup scripts, LVM snapshots, Percona XtraBackup throttling.

---

### Quick Checklist

- [ ] Capture *mysql.ping* history around each alert.  
- [ ] Verify service uptime vs. alert time (`systemctl`, `journalctl`).  
- [ ] Look for OOM or kernel errors.  
- [ ] Grep MariaDB error log for crashes or SSTs.  
- [ ] Record `wsrep_%` status immediately after recovery.  
- [ ] If it’s a false positive, lengthen the item timeout or soften the trigger.  

Run through the list the next time the alert appears; within a day or two you should see whether this is a monitoring artefact or a real—but transient—database outage.
