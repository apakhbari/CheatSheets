
# Linux

## Table of Contents

- Directories
- Concepts
- Interview Questions
- Kernel Parameters
- Daemons
- Syscalls
- Ports
- When you go to a system for first time
- Periodic check
- Cron jobs
- Manual
- Tips & Tricks
- `$ mv /etc/zabbix/zabbix_agent2.d/{mariadb,service}.conf`
- CLI, Shell
- Files
- Managing Software
- Managing Processes
- Commands
- Monitoring & Log
- Environmental variables
- Security
- Booting & Initializing
- Stopping System
- Configuring Hardware
- Storage & FileSystem
- GUI
- Administering the system
- Email
- Configure Printing
- Log & Journaling
- Network
- Securing system

———————————————

## Directories

A standard format has been defined for the Linux virtual directory called the Linux Filesystem Hierarchy Standard (FHS).

| Directory        | Description |
|-----------------|-------------|
| `/`             | The root filesystem |
| `bin`          | Essential command binaries |
| `boot`         | Static files of the boot loader |
| `dev`          | Device files |
| `dev/mapper`   | Maps physical block devices to virtual block devices |
| `etc`          | Host-specific system configuration (editable text config files of system and applications) |
| `home`         | Home directory of the users (Contains user data files) |
| `lib`          | Essential shared libraries and kernel modules |
| `lib/module`   | Where modules can be found, individual hardware driver files that can be linked into the kernel at runtime |
| `media`        | Mount point for removable devices |
| `mnt`          | Mount point for mounting a filesystem temporarily (for removable devices) |
| `opt`          | Add-on application software packages (data for optional third-party programs) |
| `proc`         | Virtual directory kernel dynamically populates to provide access to information about the system hardware settings and status |
| `/proc/dma`    | Direct Memory Access channels send data from a hardware device directly to memory on the system, without having to wait for the CPU |
| `/proc/ioports` | Locations in memory where the CPU can send data to and receive data from the hardware device |
| `/proc/interrupts` | Assign each hardware device installed on the system a unique interrupt request address |
| `root`         | Home directory of the root user |
| `run`          | It is home to lots of **data used at runtime**. It is temporary |
| `sbin`         | Essential system binaries |
| `srv`          | Data for services provided by this system (`/srv/mysql` for saving database data) |
| `tmp`          | Temporary files created by system users |
| `usr`          | Secondary hierarchy (data for standard Linux programs) |
| `usr/bin`      | Local user programs and data |
| `usr/lib`      | Libraries for programming and software packages |
| `usr/local`    | Data for programs unique to the local installation |
| `usr/sbin`     | Data for system programs and data |
| `var`          | Variable data files, including system and application logs |


- `/etc/machine-id` —> system’s machine ID is a unique hexadecimal 32-character identifier
- `cat /proc/sys/kernel/random/entropy_avail` —> to check entropy number of system
- `/usr/local/bin` —> for adding something binary to your terminal
- **`/usr/lib/firewalld/services`** —> where firewalld configs are saved as .xml files.
- **`/etc/ssh/sshd_config`**
- **`/etc/sysconfig/selinux`**
- `/proc/net/xt_recent` —> address of iptables’ workflow made by Conntrack module
- `/etc/login.defs` —> some password related stuff, some are being override with PAM
- `/lib/systemd/system/suricata.service` —> all services are here
- `cat /proc/sys/kernel/random/entropy_avail` —> to check entropy number of system
- `ls /dev/mapper/` —> show lvm and raid and luks mappings
- `/proc/net/xt_recent` —> address of iptables’ workflow made by Conntrack module
- `/lib/systemd/system` —> where all units are
- `/etc/login.defs` —> some password related stuff, some are being override with PAM
- `/lib/systemd/system/suricata.service` —> all services are here

## VS

- `media` vs `mnt`: new standard is that `/media` is where the system mounts removable media, and `/mnt` is for you to mount things manually.
- `sys` vs `dev`: The `/sys` filesystem (sysfs) contains files that provide information about devices: whether it's powered on, the vendor name and model, what bus the device is plugged into, etc. It's of interest to applications that manage devices. The `/dev` filesystem contains files that allow programs to access the devices themselves: write data to a serial port, read a hard disk, etc. It's of interest to applications that access devices. A metaphor is that `/sys` provides access to the packaging, while `/dev` provides access to the content of the box.
- `sda` vs `hda`

- For **PATA** devices, raw device file is named `/dev/hda`, `/dev/hdb` ...
- For **SATA** and **SCSI** devices, raw device file is named `/dev/sda`, `/dev/sdb` …

## GRUB

- **GRUB Legacy** stores the menu commands in a standard text config file `/boot/grub/menu.list` (Debian) or `/boot/grub/grub.conf` (RH)
- **GRUB2** system changes the config file name to `grub.cfg`. where the file stored depends on system’s firmware:

  - **BIOS**: `/boot/grub/grub.cfg` or `/boot/grub2/grub.cfg`
  - **UEFI**: `/boot/efi/EFI/[distro-name]/grub.cfg`

- For global commands, `/etc/default/grub` config file is used.
- Although **GRUB2** uses the `/boot/grub/grub.cfg` file as the configuration file, you should **never** modify that file. Instead, there are separate configuration files stored in the `/etc/grub.d` folder.

## Systemd

- **Systemd service unit files** can be found in these directories: (if a file is found in two different directory locations, one will have precedence over the other)

  - `/etc/systemd/system/`
  - `/run/systemd/system/`
  - `/usr/lib/systemd/system/`
  - `/lib/systemd/system` —> where all units are

## SysVinit

- `/etc/inittab` : SysVinit systems employ a configuration file that sets the default runlevel.
- `/etc/init.d/` : each service must have an initialization script which are responsible for starting, stopping, restarting, reloading, and displaying the status of various system services.
- `/etc/init.d/` or `/etc/rc.d/` : The program that calls these initialization scripts is the `rc` script, and it can be found here.

## Notifying User

- `/etc/issue` : Contains text to be displayed on the tty terminal login screens (prior to logging into the system).
- `/etc/issue.net` : Contains logon screen messages for remote logins.
- `/etc/motd` : Called the Message of the Day file, contains text that is displayed after a user has logged into a tty terminal.
- `/bin/notify-send` (or `/usr/bin/notify-send`) : Sends messages to a user employing the GUI but who is not logged into a tty terminal or does not have a GUI terminal emulator open.
- `/bin/wall` (or `/usr/bin/wall`) : Sends messages (called wall messages) to users logged into a tty terminal or who have a GUI terminal emulator open and have their message status set to “yes”. `$ mesg` : Viewing your message status.

# Hardware Devices

- `/dev` —> After kernel communicates with a device on an interface, it must be able to transfer data to and from the device.  
  To retrieve data from a specific device, a program just needs to read the Linux device file associated with that device.  
  To send data to the device, the program just needs to write to the Linux device file. This is a lot easier than requiring each application to know how to directly interact with a device.  
  There are 2 kinds of device files: Character device files, Block device files.
- `/dev/mapper/` —> show LVM, RAID, and LUKS mappings.
- **sda vs hda**
  - For **PATA devices**, raw device file is named `/dev/hda`, `/dev/hdb`, ...
  - For **SATA and SCSI devices**, raw device file is named `/dev/sda`, `/dev/sdb`, …

## `/dev/disk` —> udev creates links to the `/dev` storage device files based on unique attributes of the drive.  
udev creates four separate directories for storing links:

- `/dev/disk/by-id` —> Links storage devices by their manufacturer make, model, and serial number.
- `/dev/disk/by-label` —> Links storage devices by the label assigned to them.
- `/dev/disk/by-path` —> Links storage devices by the physical hardware port they are connected to.
- `/dev/disk/by-uuid` —> Links storage devices by the 128-bit universally unique identifier (UUID) assigned to the device.

## `/dev/mapper/mpathN`  
Where **N** is the number of the multipath drive. Acts as a normal device file to the Linux system, allowing you to create partitions and filesystems on the multipath device.

## `/etc/fstab`  
Indicate which drive devices should be mounted to the virtual directory at boot time. A table that indicates:

- The drive device file (either the raw file or one of its permanent udev filenames).
- The mount point location.
- The filesystem type, ...

## `/proc/partitions` - `/proc/mounts`  
Where commands such as `$ lsblk` read to generate a report.


# Modules

- `/lib/modules` —> Individual hardware driver files that can be linked into the kernel at runtime.
- `/etc/modules` —> The modules the kernel will load at boot time.
- `/etc/modules.conf` —> The kernel module configurations.
- `/lib/modules/version/modules.dep` —> Determines the module dependencies.


# GUI

- `/etc/X11/xorg.conf` (Typically this file is no longer used.)  
  The X.Org package keeps track of display card, monitor, and input device information in a configuration file, using the original XFree86 format.
- `/etc/X11/xorg.conf.d` —> Individual applications or devices store their own X11 settings in separate files stored in this directory.
- `~/.xsession-errors` —> If something goes wrong with the display process, the X.Org server generates the `.xsession-errors` file in your Home directory.
- `/etc/X11/xdm/xdm-config` —> XDM display manager is somewhat generic, there are some configuration features you can modify to change things a bit. In most situations, you’ll never need to modify any of these settings.
- `/etc/xrdp/xrdp.ini` —> Determines the various Xrdp configuration settings. An important setting in this file is the **security_layer** directive.


# Shell

- `/$HOME/.bashrc` —> If you need to permanently change the environmental variables or add aliases, you’ll need to add the export command to this file so that it runs each time you log in.
- `/etc/profile` —> Is the main default startup file for the Bash shell. Whenever you log into the Linux system, Bash executes the commands in the `/etc/profile` startup file.

### User-specific startup files for defining environment variables:
Most Linux distributions use only one of these three:

- `$HOME/.bash_profile`
- `$HOME/.bash_login`
- `$HOME/.profile`

### `.bashrc` file in the user’s HOME directory (`~/.bashrc`) does two things:
1. Checks for a common `/etc/bash.bashrc` file. The common `bash.bashrc` file provides a way for you to set scripts and variables used by all users who start an interactive shell.
2. Provides a place for the user to enter personal aliases and private script functions.


# Time

- `/etc/timezone` (Debian-based) & `/etc/localtime` (Red Hat–based)  
  These files are not in a text format, so you can’t simply edit them.  
  To change the time zone for a Linux system, copy or link the appropriate time zone template file from the `/usr/share/zoneinfo` folder to the `/etc/timezone` or `/etc/localtime` location.  
  **Example:** `/usr/share/zoneinfo/US/Eastern`
- `/etc/ntp.conf` —> It contains, among other directives, the **NTP time servers** you wish to use.  
  - On **CentOS**, the directive name for setting these is `server`.  
  - On **Ubuntu**, it is `pool`.
- `/etc/chrony.conf` or `/etc/chrony/chrony.conf`  
  The primary configuration file for **Chrony**.  
  - The directive name for setting these is either `server` or `pool`.  
  - The **server** directive is typically used for a single time server designation.  
  - **pool** indicates a server pool.  
  - `rtcsync` directive directs chrony to periodically update the hardware time (real-time clock).
- `/var/spool/at` —> Where jobs submitted using the `at` command are being saved.


# User & Group

- `/etc/login.defs` —> Typically installed by default on most Linux distributions.  
  It contains directives for use in various **shadow password suite commands** such as `useradd`, `userdel`, and `passwd` commands.  
  This file controls:
  - Password length.
  - How long until the user is required to change the account’s password.
  - Whether or not a home directory is created by default.
  - Other account-related settings.
- `/etc/default/useradd` —> Directs the process of creating accounts.  
  **Commands:**
  - `$ cat /etc/default/useradd`
  - `$ sudo useradd -D`
- `/etc/skel` —> The skeleton directory, holds files.  
  If a home directory is created for a user, these files are copied to the user account’s home directory when the account is created.
- `/sbin/nologin` or `/bin/false` —> Prevent an account from interactively logging in.  
  - This is done by entering one of these two records in **record 7 of `/etc/passwd`**, which is for the default shell.
  - `/sbin/nologin` displays a brief message and logs you off before you reach a command prompt.
  - You can modify the message shown by creating the file `/etc/nologin.txt`.
- `/etc/group` —> Where information about groups is stored.


# Mail

- `/bin/mail` (or `/usr/bin/mail`) —> Default location of binmail, which is an **MDA program**.
- `/var/spool/mail` directory (can be configured to read `$HOME/mail` file instead) —> Where binmail reads email messages.
- `/etc/aliases` —> Where email aliases are stored.


# Print

- `/etc/cups` —> The configuration files of CUPS software are stored here.


# Logs

- `/var/log/boot` (Debian distros) , `/var/log/boot.log` (RH distros) —> information about boot process
- `/var/log/syslog` —> where rsyslog logs are stored
- `/etc/rsyslogd.conf` file or `*.conf` files in the `/etc/rsyslog.d/` directory —> define rules on what events to listen for and how to handle them using the rsyslogd program
- `/etc/logrotate.conf` —> configuration file to determine how each log file is managed by logrotate
- `/var/log` directory —> most Linux distributions create log files in here
- `/etc/systemd/journald.conf` —> The systemd-journald service reads its configuration from this configuration file.
- `/run/systemd/journal/syslog` —> when journald logs are forwarded to rsyslog program, this file acts as a socket for rsyslog to read them

---

# Network

- No single standard configuration file exists that all distributions use for configuring `systemd-networkd`

- **Debian-based:** `/etc/network/interfaces` file  
- **Red Hat–based:** `/etc/sysconfig/network-scripts` directory  
- **OpenSUSE:** `/etc/sysconfig/network` file  

- `/etc/resolv.conf` —> DNS server is defined here, legacy SysVinit systems  
- `/etc/sysctl.conf` —> tune networking parameters for a network interface.  
  The Linux system uses this when interacting with the network interface.  
  - To disable responding to ICMP messages, set `icmp_echo_ignore_broadcasts` value to `1`  
  - If your system has multiple network interface cards, disable packet forwarding by setting `ip_forward` value to `0`

---

# SSH

- `~/.ssh/known_hosts` —> The OpenSSH application keeps track of any previously connected hosts here. Data contains the remote servers’ public keys.
- `~/.ssh/config` —> Contains OpenSSH client configurations. May be overridden by `ssh` command options. For an individual user’s connections to a remote system.
- `/etc/ssh/ssh_config` —> Contains OpenSSH client configurations. May be overridden by `ssh` command options or settings in the `~/.ssh/config` file. For every user’s connection to a remote system.
- `/etc/ssh/sshd_config` —> Contains the OpenSSH daemon (`sshd`) configurations. For incoming SSH connection requests.
- `/etc/ssh/` —> where OpenSSH will save its system’s public/private key pairs

---

# Services

- `/etc/xinetd.conf` —> primary configuration file of `xinetd`. Contains only global default options.

---

# Concepts

- When you log into the Linux system, your process’s current working directory is your account’s home directory.  
  A **current working directory** is the directory your process is currently using within the virtual directory (root directory) structure.

- Within a shell, some commands that you type at the command line are part of the shell program, other commands are external programs.  
  - `$ type echo` —> `echo` is a shell builtin  
  - `$ type uname` —> `uname is /usr/bin/uname`  

---

# Interview Questions

- **What to do in heavy DDOS attacks?** → Tell Internet Service Provider  
- **What does `mask` do in systemd?** → Links a service to `/dev/null`, so another service can’t start it. Should be done after `$ systemd stop service`  
- **What kernel process is called when memory is full?** → OOM (Out of Memory clear process)  
- **What is the dot (.) at the end of files (only Red Hat distros) after `$ ls -l`?**  
  - Example: `-rw-------.`  
  - It is linking to `acl.c` file, allowing access control to be defined on it.  
  - It is an SELinux feature:  
    - **Dot (.)** means access control is not set on this file.  
    - **Plus (+)** means access control has been set.  
- **Can two files have the same inode on a system?** → Yes, if they are **hard-linked**  
- **Can two separate files have the same inode on a system?** → Yes, if they are on **different partitions**  
- **Why does a hacker want a reverse shell after an attack?**  
  - To have **permanent access**  
  - To **bypass firewalls** – Most corporate firewalls are not strict for outbound traffic.  
- **What is the difference between `service reload` and `service restart` in systemd?**  
  - In **reload**, a **HangUp (HUP) signal** is sent, so the config file is read again but the process ID (`pid`) remains unchanged.  
  - In **restart**, the process ID changes.  
- **What is `#!/bin/bash`?** → It defines the interpreter of the file.  
- **Can there be two `UID=0` (root) users in a system?** → Yes.  
  - Attackers can create a user and change its UID & GID in `/etc/passwd` to `0:0`.  
  - Since many applications check for UID `0`, the attacker gains **root-level access**.  
  - **How to check?**  
    ```bash
    awk -F ‘($3 == “0”) {print}’ /etc/passwd
    ```
- **What is a forkbomb?**  
  ```bash
  :(){ :|: & };:
  ```
  - A function `:` is defined, it recursively calls itself and sends itself to the background, creating an **infinite loop**.  
- **What is DRDOS (Distributed Reflection Denial of Service attack)?**  
  - **UDP reflection attacks** allow attackers to **amplify** traffic using a victim's system to attack another target.  
  - The infected system is used to **attack another system.**  
- **What is the difference between SSL & TLS?**  
  - **SSL versions:**  
    - SSL v1: **Never released**  
    - SSL v2: Released **1995**, worked till **2011** (had **DROWN attack**)  
    - SSL v3: Released **2015** (had **POODLE attack**)  
  - **TLS replaced SSL:**  
    - **TLS 1.0** (1999-2020) had technical & implementation issues  
    - **TLS 1.1** (deprecated 2020)  
    - **TLS 1.2** (2008-2020)  
    - **TLS 1.3** (2018-Present)  

---

# Kernel Parameters

- **`/proc/sys/kernel/randomize_va_space` —>**  
  Address Space Layout Randomization (**ASLR**) can help defeat certain types of buffer overflow attacks. ASLR can locate the base, libraries, heap, and stack at random positions in a process's address space, making it difficult for an attacking program to predict the memory address of the next instruction.  

  **Values:**  
  - **0**: Disable ASLR. This setting is applied if the kernel is booted with the `norandmaps` boot parameter.  
  - **1**: Randomize the positions of the stack, virtual dynamic shared object (**VDSO**) page, and shared memory regions. The base address of the data segment is located immediately after the end of the executable code segment.  
  - **2**: Randomize the positions of the stack, VDSO page, shared memory regions, and the data segment. This is the default setting.  

- **`/etc/sysctl.conf` —>**  
  Tune networking parameters for a network interface. The Linux system uses this when interacting with the network interface.  
  - To disable responding to ICMP messages, set `icmp_echo_ignore_broadcasts` value to `1`  
  - If your system has multiple network interface cards, disable packet forwarding by setting `ip_forward` value to `0`  

- **NX/XD**:  
  A CPU feature in Linux, **No Execute/Execute Disable**. Prevents users from entering CPU opcodes instead of data inside RAM.  
  - To check it:  
    ```bash
    dmesg | grep -i nx
    cat /proc/cpuinfo | grep nx
    ```

- **ASLR (KASLR is better)**:  
  Memory address is randomized, making it harder for hackers. Should be set to `2`. It's a kernel parameter.

---

# Daemons

- **`acpid`**:  
  After processes are stopped and the CPU is shut down, signals are sent to the hardware telling various components to power down.  
  For **ACPI-compliant** chipsets, these are **ACPI signals**.  
  - This daemon manages signals sent to hardware for specific events, such as pressing the system’s power button or closing a laptop lid.

- **`systemd`**:  
  Initialization daemon (`init`) determines which services are started and in what order.

- **`udev`**:  
  Automatically detects new hardware connected to the Linux system and assigns each a unique device filename in the `/dev` directory.

- **`multipathd`**:  
  Device Mapper (**DM**) multipathing aggregates the paths for increased throughput while all paths are active, or provides fault tolerance if one path fails.

- **NTP Client Choices**:
  - Use the **NTP daemon (`ntpd`)**  
  - Use the **newer chrony daemon (`chronyd`)**  

- **`rsyslogd`**:  
  For logs.

- **`systemd-networkd`**:  
  Used by Linux systems with `systemd` to detect network interfaces and automatically create entries in network configuration files.

- **`systemd-resolved`**:  
  The DNS server is defined and resolved by this program.

- **`dhcpd`**:  
  DHCP server daemon.

---

# Syscalls

- **`EXECVE`**:  
  When a binary is executed, this syscall must be called.  
  - All commands executed in the terminal call this syscall.

- **`ptrace`**:  
  Used for debugging, but can be exploited by attackers to bind malicious code to processes.

- **`memfd`**:  
  Allows attackers to bind malicious code to RAM, enabling file-less attacks.

---

# Ports

- **`5900+n TCP`**:  
  The **VNC server** offers a GUI service at TCP port `5900+n`, where `n` equals the display number, usually `1` (port `5901`).

- **`5800+n TCP`**:  
  The **VNC server** can also be accessed via a **Java-enabled web browser** at this TCP port.

- **`3389 TCP`**:  
  **Xrdp server** for tunneling GUI connections.

- **`631 TCP`**:  
  **CUPS (Common UNIX Printing System)** for printing services.

| Port | Protocol  | Application |
|------|----------|--------------------------------------|
| 20   | TCP      | FTP (File Transfer Protocol)       |
| 21   | TCP      | FTP control messages               |
| 22   | TCP      | SSH (Secure Shell)                 |
| 23   | TCP      | Telnet interactive protocol        |
| 25   | TCP      | SMTP (Simple Mail Transfer Protocol) |
| 53   | TCP & UDP | Domain Name System (DNS)          |
| 80   | TCP      | HTTP (Hyper Text Transfer Protocol) |
| 110  | TCP      | POP3 (Post Office Protocol Version 3) |
| 123  | UDP      | NTP (Network Time Protocol)        |
| 139  | TCP      | NetBIOS Session Service           |
| 143  | TCP      | IMAP (Internet Message Access Protocol) |
| 161  | UDP      | SNMP (Simple Network Management Protocol) |
| 162  | UDP      | Simple Network Management Protocol trap |
| 389  | TCP      | LDAP (Lightweight Directory Access Protocol) |
| 443  | TCP      | HTTP (Hypertext Transfer Protocol) over TLS/SSL |
| 465  | TCP      | SMTPS (Authenticated SMTP)        |
| 514  | TCP & UDP | Remote Shell [TCP] or Syslog [UDP] |
| 636  | TCP      | LDAPS (Lightweight Directory Access Protocol over TLS/SSL) |
| 993  | TCP      | IMAPS (Internet Message Access Protocol over TLS/SSL) |
| 995  | TCP      | POP3S (Post Office Protocol 3 over TLS/SSL) |

---
## Tips & Tricks:

- keyring is a kernel component, it caches encrypted keys which are kernel level on user space
- for deleting important data:  
  ```sh
  shred -u -z -n 9 -v secret.txt
  ```
- why a encoded file is openable with `less`, but not with `cat`?  
  Because `less` saves the file in memory then reads it, and therefore can access keyring.
- **PEM Format**:
  ```
  —— begin pub key ———
  base64 encoded pub key
  —— end pub key ———
  ```
- Key pairs should be generated on a desktop system with GUI and personal data because it has more entropy.
- Run `echo $?` after **EVERYTHING**!
- Some free firewalls: `pfsense`, `open sense`, `firepower`
- Check out these NSM (Network Security Monitor): `zeek`, `bro`
- `Dirbuster` for crawling all directories in a web server
- `cockpit` is a service that automates and makes monitoring of all systemD services easier.
- **Executable file format**:  
  - On Windows: **PE**  
  - On Linux: **ELF** (Executable and Linkable Format)
- **IMPORTANT:**  
  - Bash scripts (and all interpreter scripts and files / not compiler-based) **must have read permission** in order to execute.  
  - **ELF formats** are fine **without read permission** in order to execute.
- **Preventing user modification**:  
  ```sh
  chattr +i /etc/passwd
  ```
  This prevents hackers from adding users, which is often an early step in an attack.
- **BLP (Bell-LaPadula Model)** is a security model.
- **SELinux on Debian-based systems**: After first reboot, it takes 30-40 mins to label resources.
- **Hardening should be done BEFORE production deployment.**  
  Otherwise, rootkits might already be present.
- **Kernel is read-only (RO) during startup** to prevent malware from loading into RAM.
- **Setting line numbers in Vim**:
  ```vim
  :set nu
  ```
- **Grepping binary files**:
  ```sh
  grep -a (ascii) 
  ```
- **Converting epoch time in terminal**:
  ```sh
  date -d @1671122464
  ```
- **Hardening should be implemented via threat modeling, NOT best practices.**  
  Create models, analyze the environment, and conduct a risk assessment before hardening.
- **DNS Leakage**:  
  If tunneling, check for DNS leaks (some online tools are available).
- **Antivirus bypassing**:  
  AVs hash files for detection; binary padding (adding a single nop byte) can change the hash and bypass AV detection.
- **Searching in Vim**:
  ```sh
  /
  ```
- **Encryption algorithms**:  
  - `aes256-ctr`: (Counter mode) **Stream-based, bit-by-bit encryption**  
  - `aes256-cbc`: **Cipher Block Chaining**
- **Bash execution**:  
  When a user is given a bash shell, all `.sh` files inside `/etc/profile.d` are read.
- **Forcing a bash script to re-execute without restart**:
  ```sh
  source a.sh
  ```
- **Search engines that hackers use**:  
  `shodan`, `censys`, `binaryage`
- **POSIX**: A UNIX-based standard introduced by **Richard Stallman** to standardize distributions.
- **Threads**: Threads **do not have access to their parent’s heap and stack**.
- **Apache attack vector**:  
  Apache is **thread-based**, so tools like **slowhttptest** (developed by Google) create threads and send data very slowly to exhaust system resources.
- **Finding syscalls by number**:
  ```sh
  vim /usr/include/asm/unistd_64.h
  ausyscall --dump
  ```
- **Installing MITRE ATT&CK Navigator on Docker**.
- **On low-resource systems** (low RAM & CPU), use **haveged** package for generating public-private keys.
- **Salt in passwords (`/etc/shadow`)**:  
  A phrase used to ensure two identical passwords don’t generate the same hash.
- **File inheritance**:  
  If a file exists in **John’s home directory** (`/home/john`) with `700` permissions but is owned by `root:root`, John can **still** modify it because **directory permissions override file permissions**.
- **For scripts that must remain unchanged**, store them here:
  ```sh
  /usr/local/sbin/
  ```
- **AVML tool** is used for **RAM data dumping**.
- **Keyring in kernel**:  
  - Caches session credentials, so entering a password once means you **don't** need to re-enter it for a while.  
  - Can be flushed using:
    ```sh
    sudo -k
    ```
- **Shared Object files (`.so`)** are dynamically linked libraries.
- **After restarting a service, always check its status**.
- **Finding processes without `ps`**:
  ```sh
  cat /proc/[PID]/cmdline
  ```
- **List dynamic dependencies**:
  ```sh
  ldd /sbin/sshd | grep libwrap
  ```
- **Standard I/O Streams**:
  ```sh
  /dev/stdout
  /dev/stdin
  /dev/stderr
  ```
- **Multiplexing Terminal Screens**:
  ```sh
  screen
  tmux
  ```
- **Prevent an account from interactive login**:
  ```sh
  /sbin/nologin or /bin/false
  ```
- `/sbin/nologin` is used for **system service accounts** that don’t need an interactive shell.
- `/bin/false` is a **more restrictive** alternative to `/sbin/nologin`.
- **Exit status conventions**:
  - `0`: Success  
  - Any **positive integer**: Error  
- **Killing a process in the terminal**:
  - `Ctrl + C`: Sends **SIGINT** to terminate the process.
- **Restart the system**:
  ```sh
  init 6
  ```
- **Setting the timezone**:
  ```sh
  timedatectl set-timezone Asia/Tehran
  ```
- **Cronjob**:  
  - **Minute** is the smallest unit.

---
## When you go to a system for the first time:

## System Information Commands:

```sh
$ systemctl is-system-running
```

```sh
$ sudo -l  # See all sudoers accessibilities that the user has
```

### Show which shell `/bin/sh` points to:
```sh
$ readlink /bin/sh
$ echo $SHELL
$ echo $BASH_VERSION
```

### Current Working Directory:
```sh
$ pwd --logical
$ pwd --physical
```

### System Uptime & Hardware Information:
```sh
$ uptime
$ lsblk
$ locale
```

### Check if NTP (Network Time Protocol) package is installed and running:
Chrony is recommended since it is newer and better.
```sh
$ systemctl status chronyd
```

### List Aliases:
```sh
$ alias -p
```

### View pending jobs for execution using `at` command:
```sh
$ atq
```

### List existing cron jobs:
```sh
$ crontab -l
```

### Show all current system users, terminal they are using, and login details:
```sh
$ who
```

### Display system uptime, user sessions, and CPU load:
```sh
$ w
```

### Show login history from `/var/log/wtmp`:
```sh
$ last
```

---

## **Periodic Check & Cron Jobs**

### Periodic Check for Systems with NTPD (Chrony recommended)
Check the accuracy of your system clock:
```sh
$ ntpstat
```

View time servers your `ntpd` is polling and last sync status:
```sh
$ ntpq -p
```

Check if an attacker has created a user with root-level access (UID & GID set to `0:0`):
```sh
$ awk -F ‘($3 == "0") {print}’ /etc/passwd
```

### **Cron Jobs**
Automatically split `rsyslogd` log files into archive files based on time or size:
```sh
$ logrotate
```

Check for files with **SUID & SGID** permissions:
```sh
$ find / -perm /6000 -type f > SUID-SGID_Audit.txt
```

---

## **Manual Sections**

```sh
$ man   # An interface to the online reference manuals
```

Search descriptions and manual pages using:
```sh
$ man -k keyword   # Equivalent to 'apropos' command
```

Lookup the manual pages referenced by keyword and print short descriptions:
```sh
$ man -f keyword   # Equivalent to 'whatis' command
```

### **Standard Sections of the Manual**:
(Distributions may customize sections, often including additional sections.)

1. **User Commands**
2. **System Calls**
3. **Library Calls** (C Library Functions)
4. **Devices & Special Files** (usually stored in `/dev`)
5. **File Formats & Conventions**
6. **Games & Miscellaneous**
7. **Miscellaneous** (macro packages, conventions, etc.)
8. **Administrative Commands** (System Administration tools & Daemons)
9. **Kernel Routines**

---

# **CLI & Shell**

## Adding Binaries to Terminal
- To add something binary to your terminal, add it to `/usr/local/bin`

## **History**
The shell keeps track of all the commands you have recently used and stores them in your login session’s history list.

```sh
$ history n  # Lists the last N commands
```

### **History Options**
- `-a` → Appends the current history list commands to the end of the history file.
- `-n` → Appends the history file commands from the current Bash shell session to the current history list.
- `-r` → Overwrites the current history list commands with the commands stored in the history file.
- `-w` → Writes the current history to the history file.
- `-c` → Clears your current history list.
- `--w` → Wipes the history file.

```sh
$ echo $HISTFILE  # Viewing history file path
```

### **Re-execute Commands**
```sh
$ !!  # Re-execute your most recent command
$ !n  # Re-execute command with number n in history list
```

---

## **File Combining Commands**
### **Horizontal Combination**
```sh
$ cat numbers.txt random.txt
```

### **Vertical Combination**
```sh
$ paste numbers.txt random.txt
```

---

## **File Operations**
```sh
$ od       # Dump files in octal and other formats
$ split    # Divide large file into smaller chunks
$ sort     # Sort lines of text files (output is sorted, original file remains unchanged)
$ nl       # Number lines of a file (only non-blank text files)
$ tr 'A-Z' 'a-z'  # Convert uppercase characters to lowercase
```

### **Navigating with `less`**
```sh
$ less
```
- **Spacebar** → Move forward one page down.
- **Esc+V** → Move backward one page up.
- **Enter** → Move forward one line down.
- **? or /** → Search through the file.

---

## **File Viewing Commands**
```sh
$ head   # Output the first part of files
$ tail   # Output the last part of files
$ wc     # Word, byte, and line count of files
```

### **Follow file growth in real-time**
```sh
$ tail -f filename
```

---

## **Text File Processing**
```sh
$ cut    # Remove sections from each line of files (does not modify the file)
$ uniq   # Like `cat`, but omits repeated lines
$ md5sum # Generate MD5 hash of a file
$ grep   # Print lines that match a pattern
```

### **`grep` Options**
- **`-c`** → Display a count of text file records that contain a pattern match.
- **`-d action`** → Read a directory as if it were a file (`read`), ignore (`skip`), or act recursively (`recurse`).
- **`-i`** → Ignore case in patterns.
- **`-v`** → Display only lines that do not contain the pattern.
- **`-f FILE`** → Obtain patterns from a file.
- **`-F`** → Treat patterns as fixed strings (no regex).
- **`-E`** → Treat patterns as extended regex.
- **`-r`** → Recursively search directories.

### **Example: Remove blank lines from a file**
```sh
$ grep -v ^$ filename
```

---

## **Linux Standard I/O Streams**
1. **Standard Input (STDIN)** - Keyboard by default, file descriptor = **0**.
2. **Standard Output (STDOUT)** - Terminal window by default, file descriptor = **1**.
3. **Standard Error (STDERR)** - Terminal window by default, file descriptor = **2**.

### **Redirecting Outputs**
```sh
$ command > file       # Redirect STDOUT to file
$ command 2> file      # Redirect STDERR to file
$ command &> file      # Redirect both STDOUT and STDERR to file
$ command >> file      # Append STDOUT to file
$ command 2>> file     # Append STDERR to file
$ command &>> file     # Append both STDOUT and STDERR to file
$ command 2>&1         # Redirect STDERR to STDOUT
```

### **Combining Outputs**
```sh
$ (cal 2017; cal 2018) | less
```

### **Redirecting STDIN from a file**
```sh
$ tr 'A-Z' 'a-z' < .bash_profile
```

### **Using `tee` for Output Duplication**
```sh
$ command1 | tee filename | command2
```
- Stores `STDOUT` of `command1` in `filename`, then pipes to `command2`.
- Useful for **troubleshooting pipelines** and **simultaneous viewing and logging of output**.

---

## **Wildcard Expansion Rules**
| Character | Description |
|-----------|-------------|
| `*`       | Zero or more characters |
| `?`       | Any single character |
| `[abc]`   | A character from `a, b, or c` |
| `[^abc]`  | A character NOT from `a, b, or c` |
| `[a-z]`   | A character from `a to z` |
| `{st1,st2,st3}` | A string from `st1, st2, or st3` |

---

## **File Management Commands**
```sh
$ ls      # List directory contents
$ cp      # Copy files and directories
$ mv      # Move/rename files
$ rm      # Remove files or directories
$ find    # Search for files in a directory hierarchy
$ chmod   # Change file permissions
$ chown   # Change file owner and group
$ stat    # Display detailed information about a file
$ touch   # Create an empty file or update a file's timestamp
$ du      # Estimate file space usage
$ df      # Report file system disk space usage
```

---

# Compressing Files

| Compress Command | Decompress Command | Compression Algorithm | Compressed File Extension | Deleting Original Files | Display Compressed Files |
|-----------------|-------------------|-----------------------|--------------------------|------------------------|-------------------------|
| `$gzip`        | `$gunzip`          | Lempel-Ziv (Lz77)     | `.gz`                    | Yes                    | `$zcat` (`$gunzip -c`) |
| `$bzip2`       | `$bunzip2`         | Huffman coding algorithm | `.bz2`                | Yes                    | `$bzcat` (`$bzip2 -dc`) |
| `$xz`          | `$unxz`            | LZMA2                  | `.xz`                   | Yes                    | `$xzcat` (`$xz --decompress --stdout`) |
| `$zip`         | `$unzip`           | 32-bit CRC             | `.zip`                  | No                     | N/A                     |

# Archiving Files
- Some popular programs for managing backups: Amanda, Bacula, Bareos, Duplicity, BackupPC
- We are focusing on CLI utilities: cpio, dd, tar

## CLI Backup Utilities

- `$ cpio` → copy files to and from archives (copy in and out)
- `$ tar` → an archiving utility for creating tarball

### The tar command’s commonly used tarball creation options:

- `-c, --create` → create a new archive. The backup can be a full or incremental backup, depending on the other selected options.
- `-u, --update` → only append files newer than copy in archive
- `-g, --listed-incremental=FILE` → handle new GNU-format incremental backup
- `-v, --verbose` → verbosely list files processed
- `-f, --file=ARCHIVE` → use archive file or device ARCHIVE

- It is possible to create full backups using tarball snapshot file or `.snar` with `-g` option
- It is possible to create incremental backups using tar
- Compressing tar archives is achieved via adding an option to tar as follows:

## Compression Options for Tar Archives

| Compression Algorithm | Tar Option | Tar Filename Extension | Decompression Option |
|----------------------|-----------|-----------------------|----------------------|
| gzip | `-z, --gzip` | `.tgz` or `.tar.gz` | `-z, --gunzip` |
| bzip2 | `-j, --bzip2` | `.tbz` or `.tbz2` or `.tb2` or `.tar.bz2` | `-j, --bunzip2` |
| xz | `-J, --xz` | `.txz` or `.tar.xz` | `-J, --unxz` |

## Tar Verification Options

- `-d, --compare, --diff` → Compares a tar archive file’s members with external files and lists the differences.
- `-t, --list` → Displays a tar archive file’s contents.
- `-W, --verify` → Verifies each file as the file is processed. This option cannot be used with the compression options.
- `-x, --extract, --get` → Extracts files from a tarball or archive file and places them in the current working directory

## Other CLI File Management Commands

- `$ dd` → convert & copy a file
- `$ ln` → make links between files
- `$ ln -s` → soft link

### Symbolic Links vs Hard Links

- **Symbolic link / soft link:** A soft link file provides a pointer to a file that may reside on another filesystem. Used for aliasing commands.
- **Hard link:** A file or directory that has one index (inode) number but at least two different filenames. Used for preventing accidental deletions, especially in scripting.

**Notice:** Use `$ unlink` when deleting a link, as it could be a security issue.

## Version Link Example:

```bash
$ which java
/usr/bin/java

$ readlink -f /usr/bin/java
/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.201.b09-2.el7_6.x86_64/jre/bin/java
```

- `$ readlink` → print resolved symbolic links or canonical file names

# File Ownership
- three-tiered approach:

- Owner
- Group
- Others

- `$ chown —> change file owner and group`

- `$ chown NEWOWNER:NEWGROUP FILENAMES / or / $ chown :NEWGROUP FILENAMES`

- `$ chgrp —> change group ownership`
- `only root can change a file’s owner, only root or the owner can change a file’s group`
- `$ id -gn —> check your current group’s name`
- `$ newgrp groupname —> change your current group`

| File Type Code | Description |
|---------------|------------|
| - | The file is a binary file, a readable file (such as a text file), an image file, or a compressed file. |
| d | The file is a directory. |
| l | The file is a symbolic (soft) link to another file or directory. |
| p | The file is a named pipe or regular pipe used for communication between two or more processes. |
| s | The file is a socket file, which operates similar to a pipe but allows more styles of communication, such as bidirectional or over a network. |
| b | The file is a block device, such as a disk drive. |
| c | The file is a character device, such as a point-of-sale device. |

- `$ chmod —> change file mode bits`

- `u => owner, g => group, o => others, a => all tiers`
- `+ => grant, - => deny, = => set`
- `r => read, w => write, x => execute`
- `Its possible to use chmod with octal numbers`
- `user mask value is an octal value that represents the bits to be removed from the default octal mode 666 permissions for files, or 777 permissions for directories.`

- **Set User ID (SUID)**:  
  Setuid and setgid are a way for users to run an executable with the permissions of the user (setuid) or group (setgid) who owns the file.  
  For example, if you want a user to be able to perform a specific task that requires root/superuser privileges, but don't want to give them sudo or root access.

- `rwsr-xr-x`  
  If the SUID bit is set on a file that doesn’t have execute permission for the owner, it’s indicated by a capital S.

- **Set Group ID (SGID)**  
  The SGID bit works differently in files and directories.  
  - For files, it tells Linux to run the program file with the file’s group permissions.  
  - For directories, the SGID bit helps us create an environment where multiple users can share files.

- **The Sticky Bit**  
  The sticky bit is used on directories to protect one of its files from being deleted by those who don’t own the file, even if they belong to the group that has write permissions to the file.  
  Example: `rwxrw-r-t`.  
  The sticky bit is often used on directories shared by groups. The group members have read and write access to the data files contained in the directory, but only the file owners can remove files from the shared directory.

## Tools to Locate Files

- `$ which —> shows the full path of shell commands`
- `$ whereis —> locate the binary, source, and manual page files for a command`
- `$ locate —> find files by name, searches a database, mlocate.db, which is located in the /var/lib/mlocate/ directory, to determine if a particular file exists on the local system. The mlocate.db database is updated via the $ updatedb utility.`
- `$ find —> search for files in a directory hierarchy, Searches directory trees in real-time`
- `$ type —> display how a file is interpreted by the Bash shell if it is entered at the command line. Three categories it returns are:`
  - `alias`
  - `shell built-in`
  - `external command (displaying its absolute directory reference)`

---

## **Managing Software**

Two package management systems have risen to the top and become standards:

- **Red Hat Package Management (RPM)**  
  Used in RH distros such as RHL, Fedora, CentOS, and non-RH distros such as openSUSE, OpenMandriva LX.
- **Debian Package Management (Apt)**

**Package managers track similar things:**
- `Application files`
- `Library dependencies`
- `Application version`

### **RPM, yum**
- RPM files have a `.rpm` file extension
- `PACKAGE-NAME-VERSION-RELEASE.ARCHITECTURE.rpm`
- `$ rpm`

**Common rpm commands:**
- `-e, --erase —> Removes the specified package`
- `-F, --freshen —> Upgrades a package only if an earlier version already exists`
- `-i, --install —> Installs the specified package`
- `-U, --upgrade —> Installs or upgrades the specified package`
- `-V, --verify —> Verifies whether the package files are present and the package’s integrity`
- `-vh —> Shows the progress of an update and what it’s doing.`
- `-q, --query —> Queries whether the specified package is installed. Can add options for querying better`
  - `-c, --configfiles —> Lists the names and absolute directory references of package configuration files`
  - `-i, --info —> Provides detailed information, including version, installation date, and signatures`
  - `--provides —> Shows what facilities the package provides`
  - `-R, --requires —> Displays various package requirements (dependencies)`
  - `-s, --state —> Provides states of the different files in a package, such as normal (installed), not installed, or replaced`
  - `--whatprovides —> Shows to what package a file belongs`
  - `-a, --all —> Query all installed packages.`
  - `-p, --package PACKAGE_FILE —> Query an (uninstalled) package PACKAGE_FILE.`

- `$ rpm2cpio —> Extract cpio archive from RPM Package Manager (RPM) package`
  - `Extract files from an RPM package file —> $ rpm2cpio zsh-5.0.2-34.el7_7.2.x86_64.rpm > zsh.cpio`
  - `Move the files from the cpio archive into directories —> $ cpio–idv < zsh.cpio`

**RPM has limitations:**  
If you’re looking for new software packages to install, it’s up to you to find them.  
If a package depends on other packages to be installed, it’s up to you to install those packages first, and in the correct order.  

To solve RPM problems, each Linux distro has its own central clearinghouse of packages, called a **repository**.  

**YUM (Yellowdog Updater Modified)**
- `$ yum —> Yellowdog Updater Modified`
- Uses the `/etc/yum.repos.d/` directory to hold files that list the different repositories it checks for packages.

**Common yum commands:**
- `check-update —> Checks the repository for updates to installed packages`
- `clean —> Removes temporary files downloaded during installs`
- `deplist —> Displays dependencies for the specified package`
- `groupinstall —> Installs the specified package group`
- `info —> Displays information about the specified package`
- `install —> Installs the specified package`
- `list —> Displays information about installed packages`
- `localinstall —> Installs a package from a specified RPM file`
- `localupdate —> Updates the system from specified RPM files`
- `provides —> Shows to what package a file belongs`
- `reinstall —> Reinstalls the specified package`
- `remove —> Removes a package from the system`
- `resolvedep —> Displays packages matching the specified dependency`
- `search —> Searches repository package names and descriptions for specified keyword`
- `shell —> Enters yum command-line mode`
- `update —> Updates the specified package(s) to the latest version in the repository`
- `upgrade —> Updates specified package(s) but removes obsolete packages`

- `$ zypper —> Command-line interface to ZYpp system management library (libzypp)`

---

### **Debian Package Manager**
- have an `.deb` file extension
- `PACKAGE-NAME-VERSION-RELEASE_ARCHITECTURE.deb`
- `$ dpkg`

1. `-c, --contents —> Displays the contents of a package file`
2. `--configure —> Reconfigures an installed package`
3. `--get-selections —> Displays currently installed packages`
4. `-i, --install —> Installs the package; if package is already installed, upgrades it`
5. `-I, --info —> Displays information about an uninstalled package file`
6. `-l, --list —> Lists all installed packages matching a specified pattern`
7. `-L, --listfiles —> Lists the installed files associated with a package`
8. `-p, --print-avail —> Displays information about an installed package`
9. `-r, --remove —> Removes an installed package but leaves the configuration files`
10. `-P, --purge —> Removes an installed package, including configuration files`
11. `-s, --status —> Displays the status of the specified package`
12. `-S, --search —> Locates the package that owns the specified files`

- `$ apt —> Advanced Package Tool`

### `apt-cache` —> Query the APT cache

- `depends —> Displays the dependencies required for the package`
- `pkgnames —> Prints the name of each package APT knows`
- `search —> Displays the name of packages matching the specified item`
- `showpkg —> Lists information about the specified package`
- `stats —> Displays package statistics for the system`
- `unmet —> Shows any unmet dependencies for all installed packages or the specified installed package`

### `apt-get` —> APT package handling utility (command-line interface)

- `autoclean —> Removes information about packages that are no longer in the repository`
- `check —> Checks the package management database for inconsistencies`
- `clean —> Cleans up the database and any temporary download files`
- `dist-upgrade —> Upgrades all packages, but monitors for package dependencies`
- `dselect-upgrade —> Completes any package changes left undone`
- `install —> Installs or updates a package and updates the package management database`
- `remove —> Removes a package from the package management database`
- `source —> Retrieves the source code package for the specified package`
- `update —> Retrieves updated information about packages in the repository`
- `upgrade —> Upgrades all installed packages to newest versions`

- `$ dpkg-reconfigure —> Reconfigure an already installed package`
- `$ debconf-show —> Query the debconf database`

---

## **Linux Libraries**

Linux supports two different flavors of libraries:

- **Static libraries** (also called statically linked libraries) that are copied into an application when it is compiled.
- **Shared libraries** (also called dynamic libraries) where the library functions are copied into memory and bound to the application when the program is launched. (loading a library)  
  **Filename format:** `libLIBRARYNAME.so.VERSION`

### When Linux searches for a function’s library, it looks in the following directories:

- `LD_LIBRARY_PATH` environment variable
- Program’s `PATH` environment variable
- `/etc/ld.so.conf.d/` folder
- `/etc/ld.so.conf` file
- `/lib*/` and `/usr/lib*/` folders

- When a program is started, the **dynamic linker** (also called the dynamic linker/loader) is responsible for finding the program’s needed library functions.  
  After they are located, the dynamic linker will copy them into memory and bind them to the program.  
  Historically, the dynamic linker executable has a name like `ld.so` and `ld-linux.so*`.

- The **library cache** is a catalog of library directories and all the various libraries contained within them.  
  The system reads this cache file to quickly find needed libraries when it is loading programs.  
  When new libraries or library directories are added to the system, this library cache file must be updated.

- `$ ldconfig —> Configure dynamic linker run-time bindings`
- `$ ldd —> Print shared object dependencies. Displays a list of the library files required for the specified application`

---

## **Managing Processes**
