# Security Concepts and Practices

## Table of Contents
1. Introduction
2. Concepts
3. Commands
4. Tips and Tricks
5. Interview Questions
6. Important Directories
7. Important Syscalls
8. Kernel Parameters
9. Malware
10. Bash Script for Automation
11. Security Classes

---

## 1. Introduction
- Memory vulnerability
- DNF update
- GPG
- LUKS
- OpenSSL
- Firewall
- Iptables
- Nmap
- Firewalld
- SELinux
- SSH Hardening
- OpenVAS
- Securing user accounts
- PAM (Pluggable Authentication Module)
- Suricata
- IPSEC
- USBGuard
- Reset Root Password & Hardening GRUB2
- Securing cron jobs
- FreeIPA

## 2. Concepts 

- **NDA**: قرارداد عدم افشا 
- **IOA** (Indicator Of Attack): flow of attack, it’s a pattern.
- **IOC** (Indicator Of Compromise): addresses of servers that malware send traffic to them.
- **Botnet/Zombie**: an infected system that is going to be used in DoS attack.
- **CDN**: can see all of data decrypted, and can capture data.
- **NOC** (مرکز)
- **SOC** (مرکز)
- **CERT** (مرکز): computer emergency response team.
- **Threat**: رفتار خطر دار.
- **Vulnerability**: آسیب پذیری.
- **Exploit**: بهره‌برداری از آسیب‌پذیری.
- **Payload**: شیوه مانیتور کردن از یک اکسپلویت.
- **Post exploitation**: بهره‌برداری در آینده.
- **Back door**: دسترسی برای آینده.
- **Auxiliary**: tools for scanning, sniffing, fuzzing.
- **Anonymous**: هویت ناشناس، ولی کارها شناسایی پذیر.
- **Footprint**: ردپای عمل انجام شده.
- **Fingerprint**: hash برای ساده‌شدن کار ایجاد شده است.
- **Weakest chain**: the security of a chain is as strong as its weakest part.
- **Core dump**: captured snapshot of memory if system/app/process crashes.
- **Tactic**: Denial Of Service.
- **Technique**: how to execute the tactic, e.g., SYN flood.

## 3. Commands

- `$ strace`: System call trace.
- `$ ltrace`: Library call trace.
- `$ ptrace`: Process trace for debugging and injection.
- `$ strace -p 1`: Show syscalls for PID 1.
- `$ ldd /usr/bin/ls`: List libraries used by a software.
- `$ users`: Display online users currently logged into the system.
- `$ file a.txt`: Show info about `a.txt`.
- `$ ln`: Create hard links.
- `$ lsmod`: List all modules currently running in the kernel.
- `$ &`: Execute command in the background.
- `$ nc -nlvp [port number]`: Open a port.
- `$ netstat -antp`: Show all open ports.
- `$ systemctl list-units --type slice`: Show user units in systemd.
- `$ dd if=/dev/zero of=/dev/null bs=1M &`: Create fake CPU usage for benchmarking.
- `$ cron -e`: Schedule a task.

### Packages
- `$ dnf update`: Update repositories.
- `$ dnf update --security`: Update security-related packages.
- `$ dnf updateinfo`: Show information about available updates.
- `$ dnf updateinfo list updates security`: List updates for security-related packages.
- **Configuration in `/etc/dnf/dnf.conf`:**
  - `skip_if_unavailable=True`
  - `fastestmirror=1`
- `$ dnf update libmodule`: Resolve yaml file missing warnings.

## 4. Tips and Tricks

- **Keyring**: Kernel component caching encrypted keys.
- **Delete important data**: Use `shred -u -z -n 9 -v secret.txt`.
- **Encoded files**: Openable with `less` because it saves the file in memory.
- **PEM Format**:
  ```
  -----BEGIN PUBLIC KEY-----
  [base64 encoded public key]
  -----END PUBLIC KEY-----
  ```
- **Key Generation**: Generate on a desktop with GUI for better entropy.

- **General Tips**:
  - Use `$ echo $?` after commands to check exit status.
  - Free firewalls: pfSense, OPNsense, Firepower.
  - Network Security Monitor: Zeek, Bro.
  - Use Dirbuster to crawl web server directories.
  - Cockpit: Automation and monitoring of systemd services.
  - File formats: PE (Windows), ELF (Linux).
  - **Bash scripts need read permission to execute**; ELF files can execute without it.

- **Post-Installation Security**: Lock `/etc/passwd` using `chattr +i`.

- **SELinux**: After installation on Debian, the first labeling may take significant time.

## 5. Interview Questions

- What to do in heavy DDOS attacks? Tell your Internet Service Provider.
- What does the mask do in systemd? Links a service to `/dev/null`.
- Which kernel process is called when memory is full? OOM (out of memory killer).
- Is it possible to have two files with the same inode? Yes, if they are hard linked.
- Why would a hacker want a reverse shell? To maintain permanent access and bypass firewalls.

## 6. Important Directories

- `cat /proc/sys/kernel/random/entropy_avail`: Check system entropy level.
- `ls /dev/mapper/`: Show LVM, RAID, and LUKS mappings.
- `/proc/net/xt_recent`: Address of iptables' workflow.
- `/lib/systemd/system`: Location of all units.
- `/etc/login.defs`: Password-related settings, some overridden by PAM.
- `/lib/systemd/system/suricata.service`: Location of service files.

## 7. Important Syscalls

- **EXECVE**: Executing binaries.
- **ptrace**: Debugging and process manipulation.
- **memfd**: Binding malicious code to RAM (fileless attack).

## 8. Kernel Parameters

- **NX/XD**: Execute disable feature.
- **ASLR (Address Space Layout Randomization)**: Randomizes memory addresses to enhance security.

## 9. Malware

- **WannaCry**: Sends data to its server.
- **IP Spoofing**: Changing source IP of sent packets.
- **Smurf Attack**: A form of DoS attack by sending packets to all of a network with a victim's IP as the source.

## 10. Bash Script for Automation

- **Check for suspicious UID changes**:
  ```bash
  awk -F ‘($3 == “0”) {print}’ /etc/passwd
  ```

## 11. Security Classes

### 1. Introduction
- Integrity, availability, and confidentiality.
- CVEs: common vulnerabilities and exposures.
- **CVSS3 Score**: Above 7.5 is high risk. CVSS calculator available online.
- 90% of OS problems arise from memory management issues, buffer overflows, and stack overflows.

### 2. System Commands
- Configuration of secure servers for production environments.
- Using SELinux and threat modeling for hardening procedures.

This markdown file provides a structured overview of security concepts, practices, commands, and tips pertinent to cybersecurity, along with insights into effective system and network maintenance.