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

- keyring is a kernel component, it caches encrypted keys which are kernel level on user space
- for deleting important data : shred -u -z -n 9 -v secret.txt
- why a encoded file is openable with less, but not with cat? because less save file in memory then read it, and therefore can access keyring.
- PEM Format:

—— begin pub key ———

base64 encoded pub key

—— end pub key ———

- key pairs should be generated on a desktop system with gui and personal data, because it has more entropy
- do $ echo $? after EVERYTHING!
- Some free firewalls: pfsense - open sense - firepower
- Check out these NSM (Network Security Monitor): zeek - bro
- Dirbuster for crawling all directories in a web server
- cockpit is a service that auromate and make monitoring of all systemD services easier
- executable file format on windows is PE, on linux is ELF(executable and linkable and libraries format)
- IMPORTANT: bash scripts (and all interpreter scripts and files / not compiler-based) have to had read permission in order to execute. Elf formats are ok if there is no read permission in order to execute
- After you set users up, do this so there could not be changes and hackers can’t add users. Mostly one of first actions a hacker does is creating a user for himself, Users are mostly created by names like mysqld —> chattr +i /etc/passwd
- BLP (bella padolla) is a security model
- after installing SELinux on Debian based systems, after first reboot it took 30-40 mins to label resources
- Hardening should happen, then after that a system/machine go for production. Otherwise there could be rootkits that you’ll never know of.
- Kernel is RO(read only) when system is starting up, why? because if there is a malware, it could be loaded on ram along kernel, which is extremely dangerous.
- for setting line numbers in vim —> :set nu
- for grepping binary files use -a (asci) switch
- for converting epoch time using terminal —> $ date -d @1671122464
- Hardening should be implemented using threat modeling, not best practices! You must create models and analyze environment and do risk assessment before hardening.
- If you are tunneling, you should check for dns leakage (there are even some online sites). it means that you have tunnel, but dns requests are being sent outside of that
- one of ways an anti virus is working is by hashing a file and checking the hash value with its database. one of ways for by passing this is binary padding, it add one bit/byte to file, it could be nops (no operation file, which does nothing) so the hash value would be changed
- for searching in vim use /
- in encryption algorithms : aes256-ctr —> (counter) stream-based bit by bit, aes256-cbc —> cipher block chaining, etc.
- when there is a bash given to a user, all of .sh data inside /etc/profile.d is being read
- for forcing a bash script to re-execute (without restart) you can $ source a.sh
- search engines that hackers use : shodan, censys, binaryage - search what is shadowserver
- POSIX : a UNIX-based standard that is introduced by Richard Stallman to have standardization over all distributions.
- Threads don’t have access to their parent’s heap and stack
- attack on apache : since its thread based, then tools such as slowhttptest (developed by google) causes exploitation, this tool creates threads then start sending data very slowly
- to find syscall using its number : 1- searching in $ vim /usr/include/asm/unistd_64.h 2- $ ausyscall —dump
- install mitre attack navigator on docker
- for systems with very low ram and cpu, use haveged package to create public-private keys
- what is salt in passwords and /etc/shadow? it is a phrase that is being used to if a password was being hashed twice, none of them are looking alike.
- files in directory inheritance access from their parent directory. so if a file is in john’s home directory which had 700 permission and root:root owner, john can force it to change because directory is his.
- if you have written a script, copy it in this directory since there is no inheritance going on (nokte balayi) /usr/local/sbin/
- avml tool is for data dumping RAM
- keyring is a place in kernel where all sessions are being cached. in system if you’ve entered password in last 5 mins then there is no need to enter password again. can be flushed using sudo -k
- .so —> shared object
- after restarting a service, see its status

---

# Interview Questions:

- What to do in heavy DDOS attacks? Tell Internet Service Provider
- What mask does in systemd? Link a service to /dev/null, so another service can’t start it. Should be done after $ systemd stop service
- What kernel process is being called when memory is full? OOM (out of memory clear process)
- What is dot (.) you see in end of files (only red hat distros) after $ ls -l —> -rw———. ? it is linking to acl.c file, you can define access control on it, it is one of SELinux features, dot (.) show that access control is not set on this file and plus (+) show that access control has been set.
- Is it possible that on a system, two files have same inode? Yes, in case they are both hard linked
- Is it possible that on a system, two seperate files have same inode? Yes, in case they are different partitions
- Why a hacker after attack wants to have a reverse shell on system to his system? To have Permanent access - for bypassing firewalls, mostly firewalls of corporates are not good for output traffic, no one actually cares what traffic is going out
- what is difference between service reload / service restart in systemd? in reload HangUp signal will be sent, so config file will be read again but the pid won’t be changed
- what is #!bin/bash ? it show who is interpreter of this file
- Is it possible to have 2 UID=0 (root) in a system? yes, attackers would create a user and change its UID & GID in /etc/passwd to 0:0, in lots of situations this number is being checked so attacker has root level access to lots of things. How to check it? $ awk -F ‘($3 == “0”) {print}’ /etc/passwd
- what is forkbomb :(){ :|: & };: ? a function name : is defined, it is going to : to itself and go to background and then call it. infinite loop
- What is DRDOS (Distributed Reflection Denial of Service attack)? first thing to know is UDP has reflection attacks, this DRDOS means system is infected and being used for attacking somewhere else

---

# Important dir:

- cat /proc/sys/kernel/random/entropy_avail —> to check entropy number of system
- ls /dev/mapper/ —> show lvm and raid and luks mappings
- /proc/net/xt_recent —> address of iptables’ workflow made by Conntrack module
- /lib/systemd/system —> where all units are
- /etc/login.defs —> some password related stuff, some are being override with PAM
- /lib/systemd/system/suricata.service —> all services are here

---

# Important syscall:

- EXECVE : when a binary is being executed, this sys call must be called. all commands that are being executed in terminal call this
- ptrace : for debugging, binding malicsouse code to processes by attacker
- memfd :binding malicsouse code to RAM by attacker, file less attack

---

# kernel parameters:

- NX/XD : a cpu feature in linux, no execute/execute disable. disable user to enter cpu upcode instead of data inside ram. to check it: $dmseg | grep -i nx / or / cat /proc/cpuinfo | grep nx (1-2)
- ASLR (KASLR is better): memory address is random, so hacker has more work to. should be 2. its a kernel parameter.

---

# MalWare:

- wanna cry: send stuff to it server
- IP Spoofing: when attacker changes source ip of packet that it sent
- smurf attack: attacker send packets to all of network and set the source ip to victim’s IP, all of network want to reply that packet, DDOS attack
- UDP Fragmentation

---

# Bash Script for automation:

- $ awk -F ‘($3 == “0”) {print}’ /etc/passwd —> check if attackers would create a user and change its UID & GID in /etc/passwd to 0:0, in lots of situations this number is being checked so attacker has root level access to lots of things.

# Classes

---

## [1- intro, memory vulnerability, dnf update, gpg, luks]

- integrity, availability, confidentiality
- what is CVE: common vulnerability and exposures. شناسه
- cvss3 score: update more than 7.5. in [first.org](http://first.org) —> مرجع رسیدگی به رخدادهای امنیتی جهانی. there is a calculator.
- ۹۰ درصد مشکلات سیستم عامل به خاطر مدیریت حافظه، بافر اورفلو، استک اورفلو و این‌هاست. چون ۹۰ درصد سیستم عامل با c کد خورده است و c می‌تواند مدیریت معماری سطح پایین کند که می‌تواند مشکل آفرین باشد.
- ساختار معماری هنگامی که نرم‌افزاری اجرا می‌شود:
  پایین کد، بعد متغیرهایی که در کد assign شده اند، بعد متغیرهای assign نشده، بعد هیپ که داینامیک مقداردهی می‌شود، بعد استک. استک به صورت خودکار خالی می‌شود ولی هیپ باید توسط دولوپر در برنامه خالی شود.
- asgari machine: user —> root, pass —> qazwsx
- $dhclient —> get ip after machine started up
- $gunzip /etc/yum.repos.d/* —> to enable update on asgari machine
- fileless malware: straightly on ram. using memfd syscall
- segmentation fault —> on ram, you are writing on a sector that you don’t have permission too write on.
- core dump —> will dump all of ram when a crash happens
- executable file format on windows is PE, on linux is ELF(executable and linkable and libraries format)
- what is posix? a standard library for different distributions.
- virtual dynamic share object —> kernel level, for optimizing performance of library

### gpg:

- $ gpg —keyid-format LONG —list-keys —> for showing keyID
- $ gpg —edit-key Ahmadi > trust —> for trusting a public key
- $ gpg —send-keys —keyserver [keyserver.ubunto.com](http://keyserver.ubunto.com) [KeyID] —> send public keys to a key server
- $ gpg —keyserver [keyserver.ubunto.com](http://keyserver.ubunto.com) —search-keys [ahmadi@ahmadi.ir](mailto:ahmadi@ahmadi.ir) —> send public keys to a key server
- pub —> public primary key, sub —> public sub key, it is implemented for the day pub primary key is compromised and you want to revoke it. it is also being used for signing and for encrypting.
- how to encrypt a test directory:
  - $ tar -cvf test.tar test/*
  - $ gpg -c test.tar
- how to decrypt a test encrypted directory:
  - $ gpg -d test.tar.gpg > test.tar
  - $ tar -xvf test.tar

### luks:

- symmetric encryption, kernel space, make hdd slots, then encrypt them, has about 1-3% overhead and less than 20s for first mount. when write a file in it, data isn’t encrypted, blocks of hdd are encrypted. because it has encrypted blocks when mounting, there is no overhead after that. luks interface keeps offsets of encrypted blocks.
- first add hdd, then partition it ($ fdisk /dev/sdb), then $ cryptsetup luksFormat /dev/sdb1, passphrase must have complexity because it will fail at the end if it’s not complex enough, then $ cryptsetup luksOpen /dev/sdb1 secret (for mounting and mapping with name), now filesystem $ mkfs -t ext4 /dev/mapper/secret, make mount point in / dir $ mkdir /secret $ mount /dev/mapper/secret /secret/, now we want to make it somehow that there is no need to enter pass each time system boot $ dd if=/dev/urandom of=/root/key bs=1M count=1, $ ls -lh, $ chmod 600 key, $ ls -lh, now add this key to luks interface $ cryptsetup luksAddkey /dev/sdb1 /root/key, for making these changes permanent after reset $ vim /etc/crypttab, then write this column inside it : secret        /dev/sdb1        /root/key        defaults, now configure fstab $ vim /etc/fstab, and write this column inside it : /dev/mapper/secret        /secret            ext4        defaults               0    0, echo $?,$ reboot
- for unmounting a luks hdd: $ umount /secret, then because hdd’s pass is cached another sudoer can easily see it should do $ cryptsetup luksClose /dev/mapper/secret
- must have two keys set, one spare one primary.

---

## [2- openssl, FireWall, iptables, Nmap, firewallD]

### openssl:

- what is difference between ssl & tls? ssl v1 was not released, ssl v2 was released in 1995 and worked till 2011, had drown attack, ssl v3 was in 2015, had poodle attack. then tls was used instead as an improved version, v1.0 1999-2020 had technical and implementation problems, v1.1, v1.2 2008-2020, v1.3 2018-now
- Diffie Hellman is for symmetric key exchange in TLS triple handshake, It has nothing to do with encryption
- There are different kind of ssl certificates. For example: DV cert —> Domain Validation (classic one), OV cert —> organization validation, EV cert —> both domain and organization, as a result in browser it shows [digital.com](http://digital.com) after ssl lock, wildcard cert —> *.[a.com](http://a.com)
- CSR: certificate signing request, what you send to CA
- PKCS: set of cryptographic standards.
- X.509: data structure of a certificate
- CRL: certification revocation list
- You can get pub key from a private key, but not vice versa. It is being done by modulus & exponent part of private key
- Why set a password on CSR? To disable revocation by a bad/ex-employee
- FIPS: a set of standards by US nist, which a software have to have in order to publish and being used
- testssl.sh ابزار —> scan vulnerabilities on ssl/tls. Find on GitHub. $ ./testssl.sh [lms.anisa.co.ir](http://lms.anisa.co.ir)
- Use let’s encrypt with 3 months timespan certificate, certbot is the tool for automation of it
- $ openssl x509 -pubkey -noout -in cert.crt —> public key from certificate
- $ openssl rsa -in private.key -pubout —> public key from private key
- $ openssl s_client -connect [kernel11.com:443](http://kernel11.com:443) —> show text info of a cert on internet

### iptables:

- In linux, firewall is netfilter. In new OSs it is nftable. It is a kernel-level framework
- Port scan (one of first actions a hacker do)
- What does -j (jump) RETURN does? It is for returning from a newly created chain to another chain (for example INPUT/OUTPUT)
- Use sniff for logging all of body and header of packets.
- Extension modules: ( -m )
  - Multiport
  - IPRange
  - Connlimit : for concurrent connections that are established. It is right now, not last 60 sec for example
  - State [NEW (establishing) - ESTABLISHED - RELATED (recursive establishing request) - INVALID (send inappropriate request, for example for establishing a connection send ack instead of syn)]
  - Conntrack : create flow of established connections and save it in ram (address of flow is /proc/net/xt_recent). It uses a window time
  - Recent : actions based on conntrack flow
- How to refuse SSH Brute Force (fail2ban has better performance): $ iptables -I INPUT -p tcp —sport ssh -m conntrack —ctstate NEW -m recent —set $ iptables -I INPUT -p tcp —sport ssh -m conntrack —ctstate NEW -m recent —update —second 60 —hitcount 10 -j DROP (each 60 sec update flow inside ram, if there were 10 new connections from a specific source, drop 11th and all of next requests)
- How to refuse port scan: create a new chain and then write rules there, because if it’s in default chains, there’s gonna be overhead for each request that comes in. $ iptables -N PORTSCAN $ iptables -A PORTSCAN -p tcp —syn -m limit —limit 2000/hour -j RETURN $ iptables -A PORTSCAN -m limit —limit 1000/minute -j LOG —log-prefix “PORT SCAN DETECTED” $ iptables -A PORTSCAN -j DROP $ iptables -A INPUT -p tcp —syn -j PORTSCAN
- $ iptables -I INPUT -p tcp -m state —state ESTABLISHED,RELATED -j ACCEPT
- Use —number-line for numbering lines

### FirewallD:

- what is format of services and zones of firewallD? xml
- /usr/lib/firewalld/services —> permanent config and zones
- /etc/firewalld —> runtime changes. override /usr/lib/firewalld/services when apply changes in runtime
