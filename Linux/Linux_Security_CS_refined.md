**———————————————**

1- intro, memory vulenrability, dnf update, gpg, luks

2- openssl, FireWall, iptables, Nmap, firewallD

3- SELinux - SSH Hardening

4- ssh hardening

6- t’atil shod

7- audit - dns security - OpenScap

8- OpenVAS, Securing user accounts, PAM, Suricata

9- IPSEC, USBGuard, Reset Root Password & hardening GRUB2, Securing cronjob, FreeIPA

**———————————————**

# Concepts:

- NDA: قرارداد عدم افشا
- IOA (Indicator Of Attack): flow of attack, it’s a pattern.
- IOC (Indicator Of Compromise): addresses of servers that malware send traffic to them.
- Botnet/zombie: an infected system that is going to be used in dos attack.
- CDN see all of data decrypted, and can capture data.
- NOC (مرکز)
- SOC (مرکز)
- CERT (مرکز): computer emergency response team.
- Threat: رفتار خطر دار
- vulnerability: آسیب پذیری
- exploit: بهره‌برداری از آسیب‌پذیری
- payload: شیوه مانیتور کردن از یک اکسپلویت
- post exploitation: بهره‌برداری در‌ آینده
- back door: دسترسی برای آینده
- auxiliary: tools for scanning, sniffing, fuzzing
- Anonymous: هویت ناشناس، ولی کارها شناسایی پذیر. یعنی وقتی عملکردت ردیابی شد، نتونن بفهمن کی پشت قضیه بوده. در اینترنت مهاجمین دنبال این هستند. به عنوان یک پالیسی در نظر گرفته می‌شود.
- footprint: ردپای عمل انجام شده. هنر حمله کننده، پاک کردن رد پاست.
- fingerprint: hash برای ساده‌شدن کار ایجاد شده است.
- weakest chain: security of a chain is as much of it’s weakest part.
- Core dump: if something went wrong and system/app/process crashes, if the ability is enabled, then it is going to take a dump (snapshot) of memory. You can use GDB (a debugger) to later on troubleshoot, it is systemd’s responsibility to do so. Core dumps are being saved in directory of /var/lib/systemd/coredump.
- Tactic: Denial Of Service.
- Technique: how to operate tactic, SYN flood.

---

# Commands:

- [TAB] [TAB] —> see recommendations
- $strace —> sys call trace, $ltrace —> library call trace, $ptrace —> process trace for debugging and injection
- $strace -p 1 —> what syscalls pid 1 is using
- $ldd /usr/bin/ls —> see what libs a software is using
- $ users —> online users logged in system, right now
- $ file a.txt —> show info about a.txt
- $ ln —> hard linking
- $ lsmod —> list all modules that are running on kernel
- $ & (flag) —> in background
- $ nc -nlvp [port number] —> open port
- $ netstat -antp —> show all open ports
- $ systemctl list-units —type slice —> show users unit in systemd
- $ dd if=/dev/zero of=/dev/null bs=1M & —> fake cpu usage for benchmarking
- $ cron -e —> do something on schedule that i am telling you
- $ namectl set-hostname ASGHAR, $ bash —> change name and re-open terminal
- $ jobs -l —> list all jobs on the system; active, stopped, or otherwise
- $ kill -9 [PID]
- $ cp -p /home/john/fosh.txt —> don’t change any attributes and timestamp of file when copied
- $ grep -i pwquality \* —> search for pwquality in all files of this directory

---

# Packages:

- $dnf update —> update repos
- $ dnf update -security —> just update security related packages
- $ dnf updateinfo —> showing info about packages with their updates.
- $ dnf updateinfo list updates security —> showing info about packages with their updates.
- because of recent filtering situation and better performance of package managers.
- 1- $ vim /etc/dnf/dnf.conf
  - skip_if_unavailable=True
  - fastestmirror=1
- 2- $ dnf update libmodule —> when encountered yaml file missing warnings.

---

# Tips and Tricks:
