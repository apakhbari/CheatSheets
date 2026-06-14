
# NTP
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







# TIMEZONE

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





# QUICK FIX FOR tzdata
**The issue is with your system's timezone rules (tzdata database), not NTP.**  

Your server’s UTC time is correct (from the NTP/org server — `System clock synchronized: yes`), but the **local time offset is wrong**: it’s using `+04:30` (the old Iran Daylight Time / IRDT that used to apply in April).  

Iran **permanently abolished DST in September 2022** and now stays on **Iran Standard Time (IRST = UTC+03:30) year-round**. Your Ubuntu’s tzdata is outdated (or the timezone config is still applying the pre-2022 rules), so in April it still thinks DST is active and adds the extra hour → your clock is **1 hour fast**.

That matches what you’re seeing (13:18 local vs. what should be ~12:18).

### Quick fix (run these commands)

```bash
# 1. Update and reinstall the latest timezone database
sudo apt update
sudo apt install --reinstall tzdata

# 2. Set the correct timezone (this is the proper name)
sudo timedatectl set-timezone Asia/Tehran

# 3. Verify
timedatectl status
date
```

After step 2 you should immediately see:
- Time zone: Asia/Tehran (+0330, +0330)  ← note the 0330
- Local time ≈ 1 hour earlier than before

### Optional extra steps (if it doesn’t update immediately)

```bash
sudo dpkg-reconfigure tzdata
# → Choose "Asia" → "Tehran"

# Or force a reload
sudo systemctl restart systemd-timesyncd   # if you are using it
```

### About NTP you installed

`NTP service: n/a` just means you installed the classic `ntp`/`ntpd` package instead of letting systemd handle it. Since `System clock synchronized: yes`, your time is already being kept in sync via NTP (probably systemd-timesyncd or your org server). You don’t need to do anything unless you want to clean it up.

That’s it — after the commands above your server time should match real Iran time perfectly. Let me know what `timedatectl status` shows after you run them if it’s still off!




# Set DTS
The `IranFixed` name failed because `timedatectl` only recognizes timezones that are properly installed in the standard zoneinfo directory structure (or listed via `timedatectl list-timezones`). A custom-compiled file in `/usr/share/zoneinfo.custom` isn't automatically picked up unless we place it correctly.

Here is the **most reliable offline method** that works on many older Ubuntu systems with outdated tzdata (including appliances and air-gapped servers):

### Step-by-step (run exactly in order)

```bash
# 1. Create a minimal fixed +03:30 zone source (no DST rules)
sudo nano /tmp/iran-fixed
```

**Paste exactly these two lines** (use Tab or spaces consistently):

```
# Permanent Iran Standard Time +03:30, no DST
Zone    IranFixed       3:30:00 -       IRST
```

Save & exit (Ctrl+O → Enter → Ctrl+X).

```bash
# 2. Compile it directly into the main zoneinfo directory (this is the key)
sudo zic -d /usr/share/zoneinfo /tmp/iran-fixed
```

```bash
# 3. Link it as the active localtime and update the text file
sudo ln -sf /usr/share/zoneinfo/IranFixed /etc/localtime
echo "IranFixed" | sudo tee /etc/timezone
```

```bash
# 4. Refresh the system view
sudo timedatectl set-timezone UTC
sudo timedatectl set-timezone IranFixed
```

### 5. Verify the fix

```bash
timedatectl status
date
```

You should now see:

- **Time zone: IranFixed (+0330, +0330)**
- Local time ≈ 1 hour **earlier** than the previous 13:xx reading (correct for April 2026 in Iran)

If it still shows +0430, run these and paste the full output:

```bash
ls -l /etc/localtime
file /usr/share/zoneinfo/IranFixed
zdump IranFixed
```

### Even simpler alternative (no zic at all – try this if the above fails)

Use one of the built-in fixed-offset zones that already exists in every tzdata installation:

```bash
sudo ln -sf /usr/share/zoneinfo/Etc/GMT-3:30 /etc/localtime
echo "Etc/GMT-3:30" | sudo tee /etc/timezone

sudo timedatectl set-timezone UTC
sudo timedatectl set-timezone Etc/GMT-3:30
```

(Note: The name `GMT-3:30` means **+03:30** local time — the sign is reversed in POSIX naming.)

Then check again with `timedatectl status` and `date`.

This `Etc/GMT-3:30` method often succeeds immediately because the file already exists on your system.

Your **Universal time (UTC)** is still correct thanks to your organization's NTP server, so only the displayed local time will shift back by 1 hour once the offset becomes +0330.

Try the first method (with `zic -d /usr/share/zoneinfo`). If you get any error during `zic`, paste the exact error message. We'll get it fixed.