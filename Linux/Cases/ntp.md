Here are the ways to force your Ubuntu server to sync time immediately:

## 1. Force Sync with `ntpd` (if using classic NTP)

```bash
# Stop the NTP service first
sudo systemctl stop ntp

# Force a one-time sync
sudo ntpd -gq

# Restart the service
sudo systemctl start ntp
```

The `-g` flag allows large time corrections, and `-q` quits after syncing.

---

## 2. Use `ntpdate` for an Immediate Sync

```bash
sudo ntpdate -u pool.ntp.org
```

Or point to a specific server:

```bash
sudo ntpdate -u 0.ubuntu.pool.ntp.org
```

> **Note:** `ntpdate` may be deprecated on newer Ubuntu. Install it with `sudo apt install ntpdate` if missing.

---

## 3. Check & Fix with `timedatectl` (systemd-timesyncd)

If your system uses `systemd-timesyncd` alongside or instead of NTP:

```bash
# Check current sync status
timedatectl status

# Restart the timesyncd service to trigger a sync
sudo systemctl restart systemd-timesyncd

# Verify sync
timedatectl timesync-status
```

---

## Diagnose Why It's Not Syncing

```bash
# Check NTP service status
sudo systemctl status ntp

# View NTP peers and their status
ntpq -p

# Check for firewall blocking UDP port 123
sudo ufw status
sudo iptables -L -n | grep 123
```

**Common culprits:**
- **UDP port 123** is blocked by a firewall
- Wrong NTP server addresses in `/etc/ntp.conf`
- Both `ntpd` and `systemd-timesyncd` running simultaneously and conflicting
- DNS not resolving pool hostnames

---

## Verify Your `/etc/ntp.conf`

Make sure you have valid pool entries:

```
pool 0.ubuntu.pool.ntp.org iburst
pool 1.ubuntu.pool.ntp.org iburst
pool 2.ubuntu.pool.ntp.org iburst
pool 3.ubuntu.pool.ntp.org iburst
```

The `iburst` option speeds up initial synchronization significantly. After any config change, run `sudo systemctl restart ntp`.







## TIMEZONE

Your current timezone is `Asia/Tehran` which is correct for Iran, but the `+0430` offset means **Iran Daylight Saving Time (IRST+DST)** is currently active. Iran observes DST, shifting from +0330 to +0430 in summer.

However, if you want to **force +0330 permanently**, here are your options:

---

## Option 1: Check Available Timezones

```bash
timedatectl list-timezones | grep -i iran
# or
timedatectl list-timezones | grep Asia/Tehran
```

---

## Option 2: Set a Fixed +0330 Offset (No DST)

If you want +0330 **permanently regardless of DST**, use a fixed offset zone:

```bash
sudo timedatectl set-timezone Asia/Tehran
```

> `Asia/Tehran` already is the correct zone — but DST is the reason you see +0430 right now. If you truly want to **disable DST** and stay on +0330, use a manual offset:

```bash
# Create a fixed offset timezone with no DST
sudo timedatectl set-timezone Etc/GMT-3.5
```

> ⚠️ Note: `Etc/GMT` signs are **inverted** — `Etc/GMT-3.5` actually gives you **+0330**. However, half-hour offsets may not be available in `Etc/GMT`. In that case, use Option 3.

---

## Option 3: Create a Custom Fixed +0330 Timezone

```bash
# Create a custom timezone file with no DST
sudo bash -c "echo 'IST-3:30' > /etc/timezone"

# Or use posix string directly
sudo ln -sf /usr/share/zoneinfo/posix/Asia/Tehran /etc/localtime

# Set via timedatectl
sudo timedatectl set-timezone Asia/Tehran
```

---

## Option 4: Disable DST System-Wide (Recommended)

The cleanest approach — keep `Asia/Tehran` but tell the system to not observe DST:

```bash
# Check current state
timedatectl status

# If using systemd, you can't disable DST directly via timedatectl
# Instead, use a TZ environment variable override in /etc/environment
echo "TZ=IRST-3:30" | sudo tee -a /etc/environment

# Apply without reboot
source /etc/environment
export TZ=IRST-3:30
```

---

## Verify the Change

```bash
timedatectl status
date
```

---

## Important Note

Since today is **April 5, 2026**, and Iran's DST typically starts in **late March**, the `+0430` you're seeing is expected system behavior for `Asia/Tehran`. If your use case is a **server that needs a consistent fixed offset** (e.g., for logging, databases, or applications), Option 3 with a POSIX TZ string is the most reliable approach.