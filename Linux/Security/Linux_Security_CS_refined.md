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

———————————————

# 3- SELinux, SSH Hardening

## SELinux:

- Make all of os to subject and objects, and then will check if a subject has access to object. which is a labeling/contexting tool.
- DAC: is on all OSs, read write execute permissions, is not great for specified access controls.
- MAC: upper than DAC. SELinux is in this level.
- LSM Framework is built-in in all of distributions, security implementations are in it. SELinux is in this level. AppArmor is another LSM which is built-in for ubuntu, Tomoyo is another one.
- Tip: after configuring SELinux on a machine, it should work for a good amount of time for staging and testing purposes, then goes for production. In this testing time, SELinux must work on permissive mode and work with it 1 week.
- Extended regular DAC:

  - Acl is file-system level, it overrides permissions.
  - `$ setfacl $ getfacl`
  - What is dot (.) you see in end of files (only red hat distros) after `$ ls -l` → `-rw———.`? it is linking to acl.c file, you can define access control on it, it is one of SELinux features, dot (.) show that access control is not set on this file and plus (+) show that access control has been set.
  - What is mask in facl? It is maximum permission for a file. Implementation is on group.
  - `$ setfacl -m u(User)|g(Group):username|groupname:Perm(rwx|7) file_name` → example: `$ setfacl -m u:hacker:rwx a.txt`
  - `$ setfacl -x g:wheel a.txt` → delete wheel group access control
  - `$ setfacl -b a.txt` → removes flag related to facl. (+) turns to (.).
  
- EA (Extra Attribute) —> at first it was implemented for ext family file system.

  - `$ Lsattr a.txt` → see attributes of a file, `$ chattr a.txt` → change attributes of a file.
  - A (append) —> users and processes can only append to a file. `$ chattr +a a.txt $ chattr -a a.txt` will remove -a attribute.
  - I (immutable) —> all changes in file system level is discarded. modify move and remove are not allowed.
  - S (secure delet)
  - C (compress during writing on hdd)
  
- SELinux is based on two main things: 1-context 2-Boolean
- SELinux has three modes: disabled, permissive (just log), enforcing (is active). `$ setenforce enforceing(1)|permissive(0)` changes the mode, you can’t setenforce to disable, `$ get enforce` shows the mode
- `$ sestatus` —> show status of selinux.

- SELinuxfs mount —> mount file system on another part so that it is integrated with more security. It is common to do this, since FS is virtual.
- SELinux root directory —> where the config files are.
- Loaded policy name —> minimum, targeted (300-400 scopes, users, sockets, processes, services, and apps have built-in profiles and monitoring is on them), MLS/MCS (Multi Level Security, Multi Category Security. it has multi-level security for who can what access to which resource. it uses bella padolla model. tuning MLS takes lots of time.)
- current mode —> current run-time sestatus
- Mode from config file —> config file is in `$ vim /etc/selinux/config`. for permanently making it disabled, should change this config file. there is another softlink to this file in `$ vim /etc/sysconfig/selinux`
- Policy MLS status —> enabled means there are some profile for users, for really enabling it should install third-party packages.
- Policy deny_unknown status —> in case a process hasn’t profile, can I deny some of its requests / syscalls were not ok for me, can I deny it access?
- Memory protection checking —> can SELinux protect Memory? (man mprotect 2)
- Max kernel policy version —> version of SELinux

- SELinux context: User:Role:Type:Level
- in targeted mode, every users are Unconfined, every roles are object_r, every levels are s0
- `-Z` switch is for contexts of SELinux. for example ls, ps, mkdir, cp, etc. `$ ls -lZ`
- `$ echo salam > /var/www/html/a.html, $ ls -lZ` —> Type of file is httpd_sys_content, because it belongs to httpd domain and SELinux has contexted it rightly. this categorizing is efficient for security, only certain processes can access certain contexts
- For mapping groups, should map to roles not users.
- A SELinux User is different from a Linux user. Can view all 8 SELinux Users by `$ seinfo —user :`
  
  - root: root user
  - staff_u: sysadm_u but they can only `$sudo` and can’t use `$su`
  - sysadm_u: all administrator users
  - system_u: systematic users
  - unconfined_u: un-labeled users
  - user_u: unprivileged users
  - guest_u: 
  - xguest_u: have graphics and firefox 

- Scenario: Create a guest_u user and try to establish a ssh connection (although in targeted mode it is not that much meaningful): `$ useradd -Z guest_u alex` (took time because there are labeling happening in background), `$ passwd alex`, `su - alex`, reset system and login with alex user, `$ id -Z`, now let’s test, `$ su - root` (failed), sudo cat /etc/shadow (failed), ping 8.8.8.8 (failed), could be changed `$ usermod -Z staff_u`
- `$ semanage login -l` —> show all user mappings of system
- `$ seinfo —role :` (15 roles)

  - auditadm_r
  - dbadm_r
  - guest_r
  - logadm_r
  - nx_server_r
  - object_r
  - secadm_r
  - staff_r
  - sysadm_r
  - system_r
  - unconfined_r
  - user_r
  - webadm_r
  - xguest_r

- `$ seinfo —type | nl` —> 4932 types
- Booleans are policies that are watching system for security. Combining with contexts, it’s another layer for security (Defence in depth)
- `$ semanage boolean -l | nl` —> 338 booleans. (on : runtime , on : permanent)
- `$ getsebool httpd_enable_cgi` (runtime) | `$ getsebool -P httpd_enable_cgi` (permanent)
- `$ setsebool httpd_enable_cgi 0` (runtime) | `$ getsebool -P httpd_enable_cgi 0` (permanent)
- if an attacker could attack and get root permission, first thing he’d do is set selinux to permissive mode because he cannot disable it, since it needs reboot and makes lots of noise
- `$ setsebool secure_mode_policyload 1` —> after all configurations done, do this so no one (even root) can’t change SELinux to permissive mode. If done this Permanently and in runtime and you want to change it, should disable SELinux, then change it, then enable it again.
- `$ setsebool secure_mode_insmode 1` —> most of complex linux attacks are module-based. hackers insert modules into kernel, so their codes are being run in kernel space. to disable any further a do, we secure insmode, after making it true, no modules could be added or inserted by process/user. If this is on, wireless could have problems, because it has to load multiple modules
- `$ setsebool deny_ptrace 1` —> attackers inject some malicious activity to processes. they do so by injecting to the process 1 for example, it is almost impossible to find some of binded process injections. one of tools to do so is by ptrace (which is a tool for debugging software that a developer developed)
- `$ setsebool deny_execmem 1` —> Don’t let a user/process execute code directly from RAM
- `$ vim /etc/selinux/targeted/contexts/files/file_contexts` —> all of labels for contexts. there are lots of regexes set there. should be noticed that latter rule overrides first one
- `$ vim /etc/selinux/targeted/contexts/files/file_contexts.local` —> all of labels for contexts that are added by sysadmin
- for managing file system labeling:

  - `$ chcon` —> Temporary Change (run time). [could use -R for recursive changes] `$ chcon -t ssh_home_t a.txt`
  - `$ semanage fcontext` —> Persistent Change. [could use -R for recursive changes]. `$ semanage fcontext -a -t ssh_home_t /etc/z.txt` —> add this rule to config file: any time a z.txt created in etc, type of it will be ssh_home_t. `$ semanage fcontext -d -t ssh_home_t /etc/z.txt` —> delete this rule from config file
  - `$ restorecon` —> relabel run time configs to persistent configs. [could use -R for recursive changes]. `$ restorecon -v /etc/z.txt` —> relabel using verbose. `$ restorecon -n -v /etc/z.txt` —> simulate relabeling without actually changing context.

- Scenario: set a new DocumentRoot for apache: open config file of apache `$ vim /etc/httpd/conf/httpd.conf`, change document root to “/web”, change line number 122 and 134, `$ mkdir /web`, `echo New Page > /web/index.html`, `$ systemctl restart httpd`, `$ curl 127.0.0.1/index.html` [403 Error forbidden], first step is setting DAC then MAC, `$ ls -ld /web/`, `$ chown -R (recursively) apache:apache /web`, `$ ls -ld /web/`, now let’s set MAC, `$ ls -ldZ /web/`, solution 1 for finding right type to be given : `ls -lZ /var/www/html/` —> type is httpd_sys_content_t, solution 2 : `vim /etc/selinux/targeted/contexts/files/file_contexts` and then search in vim `/www`, now let's give it the proper type `$ semanage fcontext -a -t httpd_sys_context_t "/web(/.*)?",` `$ restorecon -R -v /web`

---

# 4- SSH Hardening, Fail2ban, TCP Wrapper, NGINX, Kernel Parameters Hardening

## SSH Hardening:

- metasploit is a tool for offenssing ssh. 
  - `$ msfconsole`
  - `$ search mikrotik`
  - `$ search ssh_login`
  - `$ use auxiliary/scanner/ssh/ssh_login`
  - `$ show options`
  - RHOST means remote host address, RPORT means remote port.
  - `$ set RHOSTS 127.0.0.1`
  - `$ set user_file ~/user.txt`
  - `$ set password ~/pass.txt`
  - `$ set verbose true`
  - To run you can use `$ run` OR `$ exploit`. This way you can brute force.

- Scenario: SSH using public key:

  1. Generate key pairs:
     - `$ ssh-keygen -t rsa -b 4096`
     - Default place to save this key pair is `/home/hacker/.ssh/id_rsa`
     - It will ask for a passphrase which is for the private key.
     - Check out key randomart:
       - `$ ssh-keygen -l` (viewing fingerprint)
       - `$ ssh-keygen -v` (visualized randomart)
       - `$ ssh-keygen -f id_rsa.pub`
  
  2. Transfer public key to host:
     - `$ ssh-copy-id hacker@127.0.0.1`
     - First time you connect to a machine via SSH, it will show the fingerprint of it with its algorithm for verification.

  3. The private key is used to sign a challenge and generate a message.

  4. The message is transferred to the host PC.

  5. The message authenticity is verified using the public key, and access is granted.

- The fingerprint of the machines we want to connect to is saved in `/home/hacker/.ssh/known_hosts`.

- The public key of users that can connect to the machine via SSH is saved in `/home/hacker/.ssh/authorized_keys`.

- Disabling weak SSH encryption algorithms:

  - Ciphers: Symmetric algorithms (AES, 3DES)
  - HostKeyAlgorithms: Public key algorithms for authentication between machines (RSA, ECDSA)
  - KexAlgorithm: Method of exchanging symmetric keys after HostKeyAlgorithms did their job (Diffie Hellman)
  - MAC: Hashing, for integrity purposes

- To configure SSH settings:

  - `$ vim /etc/ssh/sshd_config`

  - Line 48: `PublicKeyAuthentication yes`
  - `PasswordAuthentication no` — Better than commenting, write `no` to improve openSCAP score.
  - Line 43: `PermitRootLogin no`
  - For adding ciphers:
    - Line 28: `Ciphers aes256-cbc,aes256-ctr`
  - For adding KexAlgorithms:
    - Line 29: `KexAlgorithms ecdh-sha2-nistp384`
  - `X11Forwarding no`

- SSH tunneling:
  - Line 105: `AllowTcpForwarding no`
  - Line 106: `GateWayPorts no`
  - Line 125: `PermitTunnel no`
  - `AllowStreamLocalForwarding no`
  - Port 37000

- To check all SSH algorithms a machine supports:
  - `$ nmap --script ssh2-enum-algos -sV -p 22 127.0.0.1`

- For disabling weak algorithms, configure `crypto-policies`:
  - `$ vim /lib/systemd/system/sshd.service`
  - `$ /etc/crypto-policies/back-ends/opensshserver.config`
  - Delete undesired algorithms.

- Setting a whitelist in the SSH config file:

  - `DenyUsers`: All have access except the one I declare.
  - Line 147, `AllowUsers`: No one has access except the ones I declare — `AllowUsers root john`.

- Automatic Logout:
  - `$ vim /etc/profile.d/logout.sh`
  - `#!bin/bash`
  - `TMOUT=20` (timeout in seconds)
  - `readonly TMOUT`
  - `export TMOUT`

- Setting Banner on server:
  - Line 130: `Banner /etc/ssh/banner.txt`

- Mitigation of DOS attack:
  - Line 124: `MaxStartups 10:30:60` (number of unauthenticated concurrent connections before dropping, percentage chance of dropping when reaching 10, maximum concurrent connections to start dropping).
  - `MaxStartups 2000` (on 2000 concurrent connections, start dropping everything).

## Fail2Ban:

- Fail2Ban is a service that works on authentication-based services such as SSH, and can stop unauthorized access attempts.
- The config file is `/etc/fail2ban/fail2ban.conf`, but don’t touch it. Any changes should be made inside `/etc/fail2ban/jail.d`.
  
  To configure Fail2Ban:

  - `$ vim /etc/fail2ban/jail.d/ssh.local`
  
  - `[sshd]`
  - `enabled = true`
  - `port = ssh,22000`
  - `banaction = iptables-multiport` (if using firewalld, use `firewallcmd-ipset`)
  - `logpath = /var/log/secure`
  - `maxretry = 4` (ban the IP after 5 unsuccessful tries)
  - `bantime = 120` (ban duration in seconds)

- To restart Fail2Ban:
  - `$ systemctl restart fail2ban.service`
  - `$ systemctl status fail2ban.service` — Ensure it is active (running).
  - `$ fail2ban-client banned` — Show banned IPs.
  - `$ fail2ban-client unban 192.168.56.1` — Unban this IP.

## TCP Wrapper:

- TCP Wrapper is deprecated by RedHat 8; libwrap is the dynamic shared library behind it. RedHat recommends implementing this via Firewall, but Debian still supports it.
- To check if the SSH module supports it:
  - `$ ldd /usr/sbin/sshd | grep libwrap`
  
  First implement `allow` then `deny`. No need to reload or reboot.

  - `$ vim /etc/hosts.deny`:
    - `SSHD: ALL`

## NGINX:

- Apache is thread-based, while NGINX is worker-based. It handles 10K concurrent connections (C10K).
- NGINX architecture:
  - Master Process → Child Process (on RAM) → Workers (as many as CPU cores). Workers have shared memory since they handle sessions. Each worker has:
    - 1 Cache Manager
    - 2 Cache Loader
  
- NGINX on SELinux:
  - Set `execmem` boolean to true and enable `http_setrlimit`.
- NGINX considers each connection an open file.

- To monitor NGINX processes:
  - `$ ps -aux | grep nginx` — Shows master and worker processes. The master process runs as root (for privileged ports), and the worker process runs as nginx.

- To check the server's response:
  - `$ curl -I anisa.co.ir` — This returns the header. If it is not hardened, the NGINX version will be visible.

- If compiling NGINX from source and want to hide the version:
  - `$ vim /root/nginx/src/ngx_http_header_filter_module.c` (look at lines 49-51)
  - `$ vim /root/nginx/src/core/nginx.h` (change NGINX to IIS or another name)

- NGINX configuration:
  - `$ vim /etc/nginx/nginx.conf`
    - Line 14: `events { worker_connections 4096; }`
    - Line 23: `http { server_tokens off; }`

- Controlling buffer overflow attacks:
  - ```nginx
    http {
      client_body_buffer_size 128k;
      client_header_buffer_size 2k;
      large_client_header_buffers 4 8k;
    }
    ```

- To test the NGINX configuration for syntax errors:
  - `$ nginx -t`

- Timeouts to improve server performance:
  - `client_body_timeout 30s`
  - `client_header_timeout 30s`
  - `keepalive_timeout 45s`

- Limiting concurrent connections from a specific IP:
  - ```nginx
    http {
      limit_conn_zone $binary_remote_addr zone=one: 10m;
      server {
        limit_conn one 40;
      }
    }
    ```

- Limiting the request rate:
  - ```nginx
    http {
      limit_req_zone $binary_remote_addr zone=two: 10m rate=250r/s;
      location / {
        limit_req zone=two;
      }
    }
    ```

- Limiting request methods:
  - ```nginx
    location / {
      limit_except HEAD POST {
        deny all;
      }
    }
    ```

- Limiting user agents:
  - ```nginx
    location / {
      if ($http_user_agent ~_ (wget|curl|acunetix|mirai|nessus)) {
        return 444;
      }
    }
    ```

- To check a user agent:
  - `$ curl --user-agent "jafar" -X GET 127.0.0.1`

- Avoid clickjacking by disabling `<iframe>`:
  - ```nginx
    http {
      add_header X-Frame-Options SAMEORIGIN;
      add_header X-Content-Type_Options nosniff;
      add_header X-XSS-Protection "1; mode=block";
    }
    ```

- HSTS (HTTP Strict Transport Security) to enforce SSL:
  - `add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload";`

# Kernel Hardening & Process Isolation

- Kernel has 4 jobs:
  1. Memory Management
  2. Process Management
  3. Device Drivers
  4. System Calls & Security
- There is no information about it anywhere.
- There are 3 ways to modify these parameters:
  1. When building the kernel: in the kernel’s config file.
  2. When starting the kernel: using command line parameters, through a boot loader.
  3. At runtime: through the files in `/proc/sys/` —> 
     - `vm`: virtual memory
     - `net`: network
     - `kernel`
     - `fs`: file system
     - `dev`: devices
     - `crypto`: cryptographic
     - `abi`: application binary interface

- `$ cat /proc/sys/vm/swappiness` —> 30 (means on 70% of memory goes to swap)
- For changing, there are 2 ways: 
  - `$ echo 10 > /proc/sys/vm/swappiness`
- Notice that sometimes when installing new apps, the app might need sudoer access and change lots of kernel parameters.

---

# Kernel Parameters Hardening, Lynis, Process Isolation & Limits, Control Groups, FireJail, Malware Detection

## Kernel Parameters Hardening

- `$ sysctl Tunable_Class.Parameter` —> `$ sysctl vm.swappiness` : For viewing Kernel Parameters.
- `$ sysctl -w (write) Tunable_Class.Parameter=value` —> `$ sysctl -w vm.swappiness=20` : For changing Kernel Parameters Temporarily.
- `$ sysctl -a (all)` : Show all parameters.
- For changing parameters permanently, note that there is a `sysctl.conf` file, but it's best practice to write in the `sysctl.d` file instead: 
  - `$ vim /etc/sysctl.conf`
  - `$ sysctl -w vm.swappiness=30 >> /etc/sysctl.conf`
  - Best practice: `$ sysctl -w vm.swappiness=30 >> /etc/sysctl.d/parameters.conf` and then set it immediately (not after reboot) via `$ sysctl -p /etc/sysctl.d/parameters.conf`
  
- Check out [sysctl-explorer.net](http://sysctl-explorer.net) for all parameters with details.

### Parameters:

1. `kernel.kptr_restrict=2` —> List of all virtual memory offsets that are loaded on RAM during runtime. If `=1`, the list of all is available but mapping to memory is not shown. If `=0`, the restriction is disabled and all pointers are visible to everyone. If `=2`, only UID=0 (root) can see it. These informations are inside `/proc/kallsyms`.
2. `kernel.dmesg_restrict=1` —> Restrict access to kernel ring buffer and logs from booting to current state.
3. `kernel.printk="3 3 3 3"` —> Controls the log level of kernel print statements. Values range from `0` to `7`, with each number representing different logging severity levels.
4. `kernel.kexec_load_disabled=1` —> Disables the `kexec` feature which allows loading a new kernel without rebooting.
5. `kernel.sysrq=4` —> Controls the system request key combination functionalities. For example, `alt+sysrq+b` for reboot, `alt+sysrq+c` for crash and core dump.
6. For disabling core dump:
   - `$ sysctl -a | grep coredump`
   - `$ sysctl -w kernel.core_pattern="|/bin/false"`
   - `$ sysctl -w fs.suid_dumpable=0`
7. `net.ipv4.tcp_syncookies=1` —> Sets a TCP cookie to avoid filling up the TCP queue during DOS attacks.
8. `net.ipv4.tcp_rfc1337=1` —> Ends a TCP connection after sending a `FINACK`, preventing connection from staying open post-termination.
9. `net.ipv4.conf.all.rp_filter=1`, `net.ipv4.conf.default.rp_filter=1` —> Enables reverse path filtering to prevent IP spoofing.
10. `net.ipv4.conf.all.log_martians=1` —> Logs all packets coming from invalid or "martian" IPs.
11. `net.ipv4.icmp_echo_ignore_all=1` —> Prevents ICMP echo (ping) requests to avoid network scanning.
12. `net.ipv4.tcp_sack=0`, `net.ipv4.tcp_dsack=0`, `net.ipv4.tcp_fack=0` —> Disable selective acknowledgment in TCP connections.
13. `net.ipv4.ipfrag_low_thresh`, `net.ipv4.ipfrag_high_thresh` —> Increases the threshold for fragmented packets in RAM.
14. `net.ipv4.tcp_max_syn_backlog=4096` —> Sets the maximum number of TCP connection requests in the backlog.
15. `net.ipv4.tcp_synack_retries=3` —> Sets how many times a TCP SYN-ACK can be sent before aborting the connection.
16. `net.ipv4.tcp_keepalive_time=2000` —> Specifies how long to keep an inactive connection alive before checking its status.
17. `net.ipv4.tcp_keepalive_probes=4` —> Sets the number of probes sent before declaring a connection dead.
18. `kernel.randomize_va_space=2` —> Randomizes memory locations for heap, stack, and code to improve security.
19. `kernel.yama.ptrace_scope` —> Controls ptrace for process debugging; restricts it to root user.
20. `kernel.threads-max=10000` —> Specifies the maximum number of threads allowed to run.
21. To disable `CTRL+ALT+DEL`:
   - Solution 1: `systemctl mask ctrl-alt-del.target`
   - Solution 2: `sysctl kernel.ctrl-alt.del`
22. `kernel.watchdog` —> Enable the kernel watchdog to monitor system health.

## Lynis

- It’s a tool for checking system’s hardening parameters.
- It is good for dockerized environments.
- `$ lynis audit system` —> For scanning the system.
- `$ lynis show details KRNL-5820` —> To show details about error/warning/suggestions generated by Lynis.

## Process Isolation & Limits

- `$ ulimit -a` —> Show all limits.
- `$ ulimit -u 100` —> Change soft limit within hard limit boundaries.
- `$ vim /etc/security/limits.conf` —> Resource limitation, deprecated, but still in use.
  - Format: `<domain> : <user> - @group - * - 1000:1005 - 1000: (for all users except root)`
  - `soft` means user-space limits and `hard` means kernel-space limits.
  - Example: 
    - `soft core 0`
    - `hard core 0`
- For limiting the number of concurrent processes for a user:
  - `hacker soft nproc 40`
  - `hacker hard nproc 1000`

- How to limit other users from seeing other processes using `$ top` or `$ ps -aux`:
  - Inside `/etc/fstab`, add this line: `proc /proc proc hidepid=2 0 0`
  - Then run: `$ mount -a`, `$ mount -o remount proc`.
  - Difference between `hidepid=1` and `hidepid=2`:
    - `1` allows users to see PIDs but not access them.
    - `2` hides PIDs entirely, isolating processes.

## Control Groups

- It's systemd-level and can handle isolation & limitation separately (sockets, I/O, users, processes) for security and management purposes.
- `$ systemctl set-property httpd.service CPUAccounting=1 MemoryAccounting=1 BlockIOAccounting=1` —> Enable accounting and set limitations.
- For viewing all accounting values: `/etc/systemd/system.control/`
- `$ systemctl set-property httpd.service CPUQuota=30% MemoryLimit=500M` —> Set limitations.

- `$ systemctl set-property user-1000.slice CPUAccounting=1 MemoryAccounting=1`
- `$ systemctl set-property user-1000.slice CPUQuota=30% MemoryLimit=1G`
- `$ dd if=/dev/zero of=/dev/null bs=1M &` —> Fake CPU usage for benchmarking.

- To stop fork bomb attacks that make the system hang, you can use CGroups limitations.

## Sandboxing with FireJail

- FireJail creates an isolated environment for suspicious binaries or apps.
- It’s profile-based and isolates processes completely using a unique PID.

**Malware Detection:**

- LMD: linux malware detection
- **we are using LMD + ClamAv (clamd)**
- for configuring it `$ vim /usr/local/maldetect/conf.maldet`
  - `email_allert=“1”`
  - `email_address=”[examle@example.com](mailto:examle@example.com)”`
  - line 50 : `autoupdate_signature=“1”`
  - line 58 : `autoupdate_version=“1”`
  - line 71 : `cron_prune_days=“30”` —> after how many days delete isolated malwares that are kind of like logs
  - line 76 : `cron_daily_scan=“1”` —> scan every day
  - line 104 : `scan_max_depth=“21”` —> how many directories should I go down. Best practice to make it 21 because of in depth directories. attacker knows maldet is default to 15, so make 16 directories and bypass maldet
  - line 108 : `scan_min_filesize=“19”`
  - line 115 : `scan_max_filesize=“8M”`
  - line 141 : `scan_clamscan=“1”` —> use clamd as an other engine to be better
  - line 173 : `scan_ignore_root=“0”` —> if a file is owned by root, dont bypass scanning

- `$ freshclam` —> update clamAV
- `$ maldet -u` —> update maldet
- `$ maldet -a (analyze) /home` —> scan directory
- `$ maldet —report [SCANID]` —> see report that is generated
- `$ maldet -e list` —> show all reports that have generated
- `$ maldet -r /var/www/html/a/upload 7` —> scan this directory for files that are created/modified for last 7 days

**root kit hunter:**

- `$ rkhunter —update`
- `$ rkhunter -c (check) --cronjob —rwo` —> scan all system, cronjob means you don’t have to press enter in middle of scan for continuing process, rwo means just show warnings/errors

**AIDE (advanced Intrusion Detection Environment)**

- Integrity checking. it is scanning all system and make a DB full of hash of all of files that system contains. then on second time that you scan system, it is going to compare DB2 with DB1 for all of files that are modified.
- also after attack it is good for analyzing what has been part of attack.
- `$ aide —init` —> it start scanning
- `$ vim /etc/aide.conf` —> config file
  - line 91 : assign directories that want to scan, with sort of scan parameters it should have
  - ! IMPORTANT ! : first time that you scan change name of DB that it makes : `$ cd /var/lib/aide/ $ mv aide.db.new.gz aide.db.gz` —> this is because comparing is based on two files, aide.db.gz : main file (DB1), aide.db.new.gz : main file (DB2)
- `$ aide —check` —> just show files that have modified, create DB in RAM
- `$ aide —update` —> show files that have modified, create DB in /var/lib/aide

———————————————

[6- auditd, dnssec, OpenSCAP]

**AuditD:**

- auditd is a component of kernel. Can log Everything.
- It is being used by auditctl, being searched with ausearch & for generating report you can use aureport. its config file is in `/etc/audit/auditd.conf`, there is no need to make changes, rules can be written in `/etc/audit/audit.rules`. address of logs are `/var/log/audit/audit.log`
- `$ vim /etc/audit/audit.rules` —> there is by default this values there, don’t change them in any situation, they are good, you can add rules below them but it is best practice to add rules in another file:
  - `-D` —> delete all of rules that are being written in RAM
  - `-b 8192` —> how much is my audit buffer in kernel memory
  - `-f 1` —> failure mode, 0 : when audit failed do nothing, 1: when failed printk(), 2: when failed panic
  - `—backlog_wait_time 60000` —> low level concept, what my frequency (hertz) would be for your auditd
- `$ auditctl -l` —> see rules that are loaded on system
- `$ auditctl -w (watch) /etc/shadow -p (permisiion) rwxa (read/write/execute/change attribute) -k (key) SHADOW_CHANGED`
- for permanenting rules : `$ auditctl -w /etc/shadow -p w -k SHADOW_CHANGED >> /etc/audit/rules.d/askari.rules`
- for a basic seeing of logs you can : `$ cat /var/log/audit/audit.log | grep -ia shadow_changed`
- `$ ausearch -i (interpret) - k SHADOW_CHANGED` —> seeing logs
- `$ ausearch -i -x useradd` —> for searching using command that was executed
- `$ ausearch -i -ua 1000` —> for searching using logined user
- `$ ausearch —event 562` —> for finding event
- Log fields :
  - type: SYSCALL - USERLOGIN - USERLOGOUT - ADDUSER - ADDGROUP - AVC - CWD - PASS - PROCTITLE, …
  - msg: by whom and when this log was created : audit(166723324 (epoch time, for converting epoch time using terminal —> `$ date -d @1671122464):149 (event id, for each event auditd assign an id because it is easier to search in it this way))
  - arch: cpu architecture - c000003e for x86/64
  - syscall: number of syscall that caused this log to happen - could find syscall using its number : 1- searching in `$ vim /usr/include/asm/unistd_64.h` 2- `$ ausyscall —dump`
  - success: [systemic atrr] has syscall finished successfully or not
  - exit: [systemic atrr] return code of syscall to the kernel. has nothing to do with famous app exit code
  - a0 a1 a2 a3: [systemic atrr] hex arguments of syscall
  - items: [systemic atrr] how many pass auxiliary records existed in syscall
  - ppid: parent process id
  - pid: process id
  - auid: audit user id, login id, with which user was logined to system in first time
  - uid: user id
  - gid: group id
  - guid: group user id
  - euid: effective user id
  - suid: set user id
  - fsuid: file system user id (for file sharing in network)
  - egid: effective group id
  - sgid: set group id
  - fsgid: file system group id (for file sharing in network)
  - tty: console kind
  - ses: [systemic atrr] what was session id of process that was invoked that caused this log
  - comm: what command was hitted
  - exe: executable path of command
  - subj: SELinux Context
  - key: key of log

- IMPORTANT : `uid=-1/unset/40,000,000` means it is systemic user
- `$ aureport —start 03/17/2022 00:00:00 —end 01/14/2023 00:00:00`
- `$ aureport -x` —> create executable report
- `$ aureport —summary` —> create مدیریتی report
- `$ aureport -i —login` —> create report of who has logged in
- `$ aureport -i —login —summary`
- for writing rules in auditd, it is like firewall that adds from above to below, and order of it matters
- auditctl -a (append this rule below all rules) -A (append this rule above all rules) action (what to do about this syscall, values are : always - never), filter (different values —> task : is systemic and rarely used, when fork() or clone() was executed by a parent then log - exit : by the time system call is exiting do this log - user : filter events that are originated in user space - exclude : dont show this as log, like never in action) [mostly always, exit] -S system_call -F field=value -k key_name

- SCENARIO : defense evasion, Persistence, Privilege Escalation, Initial Access (T1078 MITRE ATT&CK):
  - `$ auditctl -a always,exit -F arch=b64 -F path=/bin/su -F perm=x (execute) -F “auid>=1000” -f “auid!=-1” -k T1078_PE`
- SCENARIO : log all commands a user execute
  - `$ auditctl -a always,exit -F arch=b64 -S execve -F “auid=1000” -k HACKER_EXEC` —> it is very noisy, don’t do it for all the time
  - tip: `$ file echo` —> it is a shell built-in, not going to call execve syscall
- SCENARIO : log all commands a systemic user execute, in order to find whether it is hacked
  - `$ auditctl -a always,exit -F arch=b64 -F path=/etc/passwd -F perm=war -k PASSWD_CHANGE`
  - `$ auditctl -1 always,exit -F arch=b64 -S ptrace -k PROCESS_INJECTION`  
  - (test this one, was not working) `$ auditctl -a always,exit -F arch=b aas64 -S open -S openat -F exit=-EACCES -k PERM` —> when ever a user tried to open a file that haven’t had permission to, log it. open/openat syscalls are for opening files and EACCES is error that is being sent with permission denied so if you have to

also watch `/etc/sudoers` file

**DNSSEC:**

- DNS protocol wasn’t secure in first place.
- DNS Attacks :
  - NX Domain
  - Phantom domain
  - Rebinding attack
  - Lock-up attack
  - DRDOS
  - Cache poisoning
  - DNS hijack
  - Random subdomain attack

- DNSSEC allows : verification of integrity of each record - validation that the record originates from the authoritative DNS server for the record (authenticity) - chain of trust
- what is NX record? it is the record that DNS sends when the domain is not resolved, means there is no info about this domain in DNS
- DNSSEC adds a new record to DNS : RRSET (resource record set), it is bundling all alike records, for example all MX records are being bundled together, all AAAA records are being bundled together, and then each bundle is being signed. This is good for performance and also security.
- ZSK (zone signing key): first key DNS generates.
  - RRSIG —> RRSET signed with private key of ZSK
  - DNSKEY —> public key of ZSK + public key of KSK, signed with private key of KSK

- KSK (key signing key): to validate ZSK
- steps:
  - client asks for resolving a domain
  - DNS returns RRSIG + DNSKEY
  - client asks for public key of KSK in order to verify DNSKEY
  - DNS returns public key of KSK

- DS (dedication signer): hashed public key of KSK, for chain of trust
- we are going to implement it using chroot, it is a defense in depth method for jailing system, what it does is replicating everything bind needs from system to a local / directory and then isolating it, when attacker comes thinks / is main root directory, but he’s wrong:
  - `$ rpm -aq | grep chroot`
  - `$ dnf install bind-chroot`
  - directories gonna change :
    - `/etc/named.conf` —> `/var/named/chroot/etc/named.conf`
    - `/var/named` —> `/var/named/chroot/var/named`
  - `$ systemctl stop named`
  - `$ systemctl start named-chroot`
  - `/var/named/chroot/etc`
  - get this script for automation of slave:
    - `$ wget [https://kernel110.com/named.conf](https://kernel110.com/named.conf)`
    - `$ wget [https://kernel110.com/iran.ir.db](https://kernel110.com/iran.ir.db)`
    - `$ cp -f named.conf /var/named/chroot/etc/`
    - `$ cp -f named.conf /var/named/chroot/var/named`
    - `$ echo “nameserver 127.0.0.1” > /etc/resolv.conf`
    - `$ chattr +i /etc/resolv.conf`
    - `$ systemctl stop firewalld`
    - `$ systemctl disable firewalld`
    - `$ dig mx [iran.ir](http://iran.ir)`
  - notice that chroot mount files, because of security level of things, it is making a virtual file system and then mount files, so you can’t change or modify files. if any modification want to be made, should stop chroot and then edit and then start it again.
    - `$ mv named.conf.1 named.conf`
    - `$ /usr/libexec/setup-named-chroot.sh /var/named/chroot/ on` —> a bash script which is copy all requirements of our jailing. so duplicate some files and libraries to inner / so service could work completely isolated
  - `$ vim named.conf:`
    - line 11 : acl AllowQuery { 192.168.56.0/24; }; : for setting access control and not letting anybody to change it
    - line 13 : listen-on-v6 port 53 {none;};
    - line 21 : allow query { any; }; —> {AllowQuery;};
    - line 66 : allow-transfer { 192.168.56.104;}; : for allowing transfer to slave
  - `$ named-checkconf /var/named/chroot/etc/named.conf` —> it checks whether or not config is in right syntax
  - `$ dnssec-keygen -a NSEC3RSASHA1 -b 2048 -n ZONE [iran.ir](http://iran.ir)` —> NSEC is a protocol which in case there is no domain to return, dns send before and after of those domains, but in a hashed way
  - `$ dnssec-keygen -f KSK -a NSEC3RSASHA1 -b 2048 -n ZONE [iran.ir](http://iran.ir)`
  - `$ echo “\$INCLUDE /var/named/chroot/etc/[Kiran.ir](http://Kiran.ir).+007+22757.key” >> /var/named/chroot/var/named/[iran.ir](http://iran.ir).db`
  - `$ echo “\$INCLUDE /var/named/chroot/etc/[Kiran.ir](http://Kiran.ir).+007+57339.key” >> /var/named/chroot/var/named/[iran.ir](http://iran.ir).db`
  - `$ dnssec-signzone -A -3 $(head -c 1000 /dev/random | sha1sum | cut -b 1-16) -N INCREMENT -o [iran.ir](http://iran.ir) -t /var/named/chroot/var/named/iran.ir.db` —> A: algorithm NSEC3 , 3: salt or random string, here we are running a script inside our script, N : increment version of SOA, o : origin, which zone, t : verbose
  - `$ vim /var/named/chroot/etc/named.conf.local —>`
    - zone “[iran.ir](http://iran.ir)” {
    - type master;
    - file “/var/named/chroot/var/named/iran.ir.db.signed”;
    - allow-transfer { 192.168.56.104; };
    - also-notify { 192.168.56.104; };
    - auto-dnssec maintain; —> periodically check, other option is allow
  - DNSKEY 256(ZSK, 257 : KSK) 3(DNSSEC 3) 7(algorithm type)
  - `$ dig DNSKEY @192.168.56.102 [iran.ir](http://iran.ir)`

**OpenSCAP:**

- compliance testing (تست انطباق پذیری) using for auditing. based on profiles tailored from specialists and companies in security.
- it is a standard
- SSG (scap security guide) : profiles for testing by companies and foundations. famous ones: PCIDSS (Banking industries), DISA-STIG (Enterprise Network Infrastructure), CIS, ACSC (Australian Cyber Security Centre), HIPPA (Health Insurance Portability and Accountability Act). xml format
- use DISA-STIG
- it is possible to create a profile by yourself
- in installing os, you can go forward using scap profiles. it is going to ask you for hardening step by step during installation.
- there are two forms of data model in security, imagine there is a firewall and a microsoft server and a linux server, logs of them are very different, for gathering all logs together there should be a protocol/data model. we should choose one for using.
  - XCCDF (Extensible Configuration Checklist Description Format)
  - OVAL (Open Vulnerability and Assessment Language)
  - CPE (Common Platform Enumeration) : for each os there is a number assigned, so referencing is easier. for example redhat 8.6 has a CPE
  - CVE (Common Vulnerabilities and Exposures)
  - CWE (Common Weakness Enumeration) : it is a simple way for referencing CVEs to everyone in tech industry. for example CWE-121 is related to stack overflow, one could see lots of info about that when search it
- `$ oscap info ssg-rl8-ds-1.2.xml` —> show info, ds-1.2 is better because has lots of things inside. it is about 35000 lines of code
- copy id of desired profile from last command
- `$ oscap info —profile xccdf_org.ssgproject.content_profile_pci-dss ssg-rl8-ds-1.2.xml` —> see all profile info with a little bit of description
- `$ oscap xccdf eval —results output.xml —profile xccdf_org.ssgproject.content_profile_pci-dss ssg-rl8-ds-1.2.xml` —> evaluate based on profile and save result in output.xml, output.xml is about 250000 lines
- `$ oscap xccdf generate report output.xml > report.html` —> create a human readable interactive report
- below 60 score results in isolating system in network
- `$ oscap xccdf generate guide —profile xccdf_org.ssgproject.content_profile_pci-dss ssg-rl8-ds-1.2.xml > guide.html` —> shows all of checklist that profile uses + lots of best practices on how to harden stuff, it is good for finding elements for creating your own list
- IMPORTANT : Don’t use remediate (a tool that oscap automatically corrects the whats wrong)
- `$ oscap xccdf eval —remediate —profile xccdf_org.ssgproject.content_profile_pci-dss ssg-rl8-ds-1.2.xml`

**OpenVAS:**

- vulnerability assessment (ارزیابی آسیب‌پذیری)
- main core of openVAS is GVM (Greenbone vulnerability Manager), it accepts user data, scap cert is for openscap profiles, NVT (network vulnerability test) is field of greenbone, NVTs on free version is updated monthly but in commercial is very fast, OSP (open scanner protocol) scanner is a framework that has lots of other scanners APIs and can export them and pass them to GVM, GMP (greenbone management protocol) Clients is making data standardized and viewable, it is xml based, using GreenBone Security Assistant it could be make it html viewable

---

[7- OpenVAS, Securing user accounts, PAM, Suricata]

**OpenVAS:**

- vulnerability assessment (ارزیابی آسیب‌پذیری)
- when scanning using openVAS, should turn antivirus off. so its a great machine for exploit and attacks.
- scan —> new task
- recommendation is using built-in openVAS on kali linux. should do these commands
  - `$ sudo -u gvm greenbone-feed-sync —type CERT` —> update cert advisories
  - `$ sudo -u gvm greenbone-feed-sync —type GVMD_DATA` —> update cve
  - `$ sudo -u gvm greenbone-feed-sync —type SCAP` —> update scap
  - `$ sudo -u gvm greenbone-feed-sync —type NVT` (if not worked this command instead `$sudo -u gvm greenbone-nvt-sync`) —> update nvt

**Securing user accounts:**

- for working with /etc/sudoers its best practice to use visudo because it does syntax checking, but vim could also be used
- users with /bin/bash are dangerous
- `$ visudo /etc/sudoers`
- Defaults !visiblepw —> password is not visible in terminal
- Defaults env_reset —> reset environment variables
- Defaults timestamp_timeout=3 —> after 3 mins require sudo password, default is 5. it could be 0 : it will ask password every time. -1 : never expire password so if once entered then don’t ask for password again.
- Defaults:john timestamp_timeout = 2 —> only for user john do this
- line 100 : root (user)  ALL(host, in centralized 100 systems there are 100 root users, which one )=(ALL(by whom user’s accessibility can execute):ALL(only debian has this, by whom groups’s accessibility can execute))  ALL(what command)
- when an attacker exploit a machine it is adding his own user to this like this, so there is no need to add himself to wheel(red hat)/sudoer(debian) group : mysqld  ALL=(ALL)  ALL
- john  ALL=(ALL)  /usr/bin/systemctl —> john user can do sudo all systemctl commands
- john  ALL=(ALL)  /usr/bin/systemctl  restart * —> john user can do sudo systemctl restart
- john  ALL=(ALL)  /usr/bin/systemctl  restart httpd, /usr/bin/systemctl restart sshd
- john  ALL=(hacker)  /usr/local/sbin/data.sh —> john user can execute data.sh with hacker accessibility, then run it like `$ sudo -u hacker /usr/local/sbin/data.sh`
- %john  ALL=(hacker)  NOPASSWD:  /usr/local/sbin/data.sh —> for group john (group defined with %), it has risk since you are bypassing password, don’t do it
- john  ALL=(ALL)  sudoedit /etc/ssh/sshd_config —> you can open a bash terminal with root very easily.
- `$ sudo -l` —> see all sudoers accessibilities that user has

**PAM:**

- when you are developing an  API(app)/SPI(service), it is best practice to use PAM library for authentication & authorization instead of secure coding. it has these modules:
  - Authentication service modules
  - Account management modules
  - Session management modules
  - Password management modules

- you are not going to config these modules, you are just going to call these methods
- there is no need to restart anything. but if app/service is modified must restart
- `$ ldd /usr/sbin/sshd | grep pam` —> seeing if app/service has used pam
- system-auth and password-auth are exactly same, system is for console (tty-pts-…) & password is for remote (ssh-telnet)
- `$ vim /etc/pam.d/system-auth` (for example system-auth)
  - first row: [module interface]
  - auth : identity of user is right, are username and password ok?
  - account [account validity] : check for validity of account, account is ok not disabled valid unlocked
  - password [updating password] : is user allowed, does this pass have complexity
  - session [session management] : setting environment, home directory initialization, flush keys when session is ended

- second row: [control flag]
  - requisite (strongest flag) : if failed, don’t proceed any further
  - required : if failed, proceed and then after all modules checked in end show error
  - sufficient : if it passed, there is no need to check further modules
  - optional : ignore errors
  - default :

- third row: [modules] (see all modules in `$ ls /lib64/security/`) (for info of each module `$ man pam_env`)
  - pam_env.so —>
  - pam_unix.so —> check /etc/shadow & /etc/passwd for user and password  
  - pam_deny.so —> return error, failed
  - pam_pwquality.so —> password quality checking

- fourth row: modules options, could find info about it in modules man
  - nullok : it is ok for pass to be null
  - try_first_pass : first pass that user entered at first module is being checked for this, if not passed ask for password
  - `$ vim /etc/security/pwquality.conf` —> can perform password quality from here too
  - SCENARIO : ssh brute force prevention using pam_faillock
  - `$ vim system-auth`
    - line 2 : auth   required     pam_faillock.so   preauth (history of failed enters matters) silent (don’t show that has entered many times with wrong password) audit (log with printk) deny=5 (return error if tried more than 5 times) fail_interval=400 (lock user if 5 times wrong password in 400s ) unlock_time=400 (seconds)
    - line 4 after pam_unix.so try_first_pass: auth   required     pam_faillock.so   authfail audit deny=5 unlock_time=400
    - last line of account : account   required   pam_faillock.so  —> lock account for 400s, because it is targeted
  - `$ cp system-auth password-auth`
  - `$ faillock` —> show all locked users
  - `$ faillock —user john` —> info about a specific user
  - `$ faillock —user john —reset` —> unlock

- SCENARIO: two step authentication using google authenticator for ssh
  - HARDENING: `$ vim /etc/pam.d/system-auth`, in pam_unix.so :
    - remove nullok
    - add remember=10 —> can’t use passwords that have been used in previous 10 times

**Suricata:**

- open source intrusion detection system (IDS) & intrusion prevention system (IPS) & network monitoring system (NSM)
- 10 core cpu, 20GB RAM, for enterprise environments
- suricata is good for inside network attacks, so it is not like a firewall which is on edge of network
- best practice is to port mirror all traffic of our network on a stand-alone server which has suricata on it, so it can perform all
- `$ cd /etc/suricata/`
  - classification : classes for suricate
  - reference : from where rules are being got. list of DB sources
  - suricata.yaml : config file
  - /rules/ : built-in rules/signatures for detecting protocols
  - `$ vim /var/lib/suricata/rules/suricata.rules` —> file of finding rules
  - `$ suricata-update` —> updating signatures  
  - `$ suricata-update list-sources` —> show all sources  
  - `$ suricata-update list-sources —free` —> show all free sources  
  - `$ suricata-update list-enabled-sources` —> show all enabled sources
  - `$ suricata-update enable-source tgreen/hunting` —> enable this source
  - `$ suricata -T` —> test & check if everything is ok.
  - `$ vim /etc/suricata/suricata.yaml`
    - HOME_NET : all IPs that are mine
    - EXTERNAL_NET : not my asset
    - af-packet (very low level network packet)
    - interface : enp0s8
    - threads: auto (auto = as much as cpu cores)
    - LRO: network card makes bundles, so they are going for processing in cpu. should be disabled for suricata. —> `$ ethtool -K enp0s8 gro off lro off`
    - GRO : for times LRO couldn’t be done
    - `$ vim /etc/sysconfig/suricata`
      - OPTIONS=“-i enp0s8 —user suricate”
    - IT IS NOW CONFIGURED.
    - `$ ls /var/log/suricata/`
      - eve.json : all events are being logged. should be disabled
      - fast.log : all alerts
      - stats.log : every 8 seconds, create statistics. should be disabled
      - suricata.log : daemon log
    - writing rules is complex, but :
      - action : alert (IDS), pass, drop, reject
      - header : tcp (what protocol I’m working on) $HOME_NET (direction) any (source port) -> (<- or <> for both ways) $EXTERNAL_NET any
      - rule options : (msg{how should log it as event in fast.log}:”ET MALWARE Likely Bot Nick in IRC (USA + ..)”; flow: established,to_server; content:”NICK ”; depth:5; {inspect 5 layers inside packet} content:”USA”; within:10; reference:url,[doc.emergingthreats.net/2008124](http://doc.emergingthreats.net/2008124); classtype:trojan-activity; sid:2008124; {signature id} rev:5; metadata:created_at 2010_07_30, updated_at 2010_07_30;)
    - performance tuning
      - `$ vim /etc/suricata/suricata.yaml`
        - search for runmode, line 1063 : runmode: workers --> it is turning buffer into a single thread. instead of multithreading, which needs cpu usage to join results in the end
        - search for mpm, line 1492 : mpm-algo: hs --> what mpm-algo (Multi Pattern Matching) does is searching for rules/signatures inside. HyperScan is best option
        - search for profile, line 1438 : profile: high --> for performance related stuff, suricata bundles all signatures that are look alike
        - line 622: ring-size: 20000 --> how many packets could be saved in buffer, make it higher would result in not having queue
        - line 364: pcap-log: enabled: yes, compression: lz4, lz4-level: 4 (if have cpu, could go up to 16) --> when you are under attack, it gives you all flow of network in a pcap format
        - line 65: stats: enabled: no --> stats logs are disabled
        - line 87: eve-log: enabled: no --> eve logs are disabled
        - line 569: file: enabled: no --> eve logs are disabled

**Bro (Zeek):**

- could map all network flow. very useful tool

---

[8- IPSEC, USBGuard, Reset Root Password & hardening GRUB2, Securing cronjob, FreeIPA]

**IPSEC:**

- IP is not a secure protocol. IPSEC is a collection of protocols, main one is IKE (internet key exchange) then SA (security association) which is managing keys, such as how much ttl should it have, how much live should it be
- In IPSEC there is no client and server. There are left & right
- IKE

- phase1 (ISAKMP or IKE SA) : SA - Key exchange - Authentication
- Phase2 (IPSEC SA) which has 2 modes : AH(not that popular, authentication - integrity - anti replay : not let man in the middle ) - ESP ( authentication - integrity - anti replay : not let man in the middle )

- In AH, there is sequence for preventing man in the middle and integrity and key
- In ESP, if there is a man in the middle, he can understand to which destination IP this packet is going, but can’t understand what’s inside packet
- It is possible to use AH and ESP together
- IPSEC has two modes :

  - Transport : host to host, use packets original header
  - Tunnel : router to router, Firewall to Firewall, encapsulate entire packet, even packets header is not readable

- For each connection/tunnel, there is a unique key pair needed
- For implement it we use this package : libreswan

- left & right : $ def install libreswan
- left & right : $ systemic enable ipse —now
- left & right : $ firewall-cmd —add-service=“”ipse
- left & right : $ ipsec newhostkey —> create key pair
- Left : $ ipse showhostkey —left —ckaid [id] —> show public key
- Right : $ ipse showhostkey —right —ckaid [id] —> show public key
- Left& right : $ vim /etc/ipsec.d/host-tohost.cong

- conn mytunnel

- leftid=@west
- left=192.168.56.106
- leftrsasigkey=[pub key]
- rightid=@east
- right=192.168.56.104
- rightrsasigkey=[pub key]

- left & right : $ systemctl restart ipsec
- left & right : $ ipsec auto —add mytunnel
- left & right : $ ipsec auto —up mytunnel
- it is done!
- for testing:
- $ dnf install tcpdump
- $ tcpdump -n -i enp0s8 host 192.168.56.104

**usbguard:**

- good for bad usb. could easily find it on internet, for example it introduce itself as keyboard while it is not keyboard and going to exploit system
- $ sudo pacman -S usbguard
- $ cd /etc/usbguard/
- $ usbguard generate policey -X > /etc/usbguard/rules.conf —> allow all that are attached now on this system, block everything else
- $ lsusb —> see all USBs that are connected
- $ dmesg | grep -i authorized —> see logs
- $ usbguard allow-device [id in $lsusb] —> runtime
- $ usbguard allow-device [id in $lsusb] -p —> permanent
- $ vim /etc/usbguard/rules.conf —> see all rules
- $ usbguard list-rules
- $ usbguard remove-rule 8 (number of rule in list-rules)

**Reset Root Password & hardening GRUB2:**

- reboot
- press e on menu that choose OSs
- before initrd, at the end of linux kernel line, add : rd.break —> it is going to interrupt system when loading
- cntrl-x
- system is mounted in read-only now
- $ mount -o remount,rw sysroot
- $ chroot /sysroot/
- sh-4.4$ passwd root —> set new pass
- if now restart, password is not set. problem is selinux, because labels are changed and selinux is not gonna accept this new one we set. for bypassing it $ touch /.autorelabel , by doing this we are forcing selinux to re-label all selinux labels after boot
- $ exit
- $ reboot
- how to prevent this from happening :
- $ grub2-setpassword —> will change /boot/grub2/user.cfg
- $ grub2-mkconfig -o /boot/grub2/grub.cfg —> to save changes in user.cfg into grub

**Securing cronjob:**

- one of things that an attacker does is modifying cron job to automate a task or operate a code periodically
- $ vim /etc/cron.allow —> define only user that can access this

- root

**FreeIPA:**

- centralized authentication for user’s identity. ldap and kerberos and CA and lots of other things will be integrated
- users created in FreeIP will not be accessible in /etc/shadow
- $ yum install ipa-server ipa-server-dns —> ipa-server-dns for dns resolving. if had dns in network don’t install this
- $ ipa-sever-install


# acknowledgment
## Contributors

APA 🖖🏻

## Links


## APA, Live long & prosper
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