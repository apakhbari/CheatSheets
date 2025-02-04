
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

- Linux calls each running program a process. The Linux system assigns each process a process ID (PID) and manages how the process uses memory and CPU time based on that PID.
- When a Linux system first boots, it starts a special process called the init process.
- **Process States:**

  - **Sleeping:** Processes that are swapped into virtual memory. Often the Linux kernel places a process into sleep mode while the process is waiting for an event. When the event triggers, the kernel sends the process a signal. If the process is in interruptible sleep mode, it will receive the signal immediately and wake up. If the process is in uninterruptible sleep mode, it only wakes up based on an external event, such as hardware becoming available. It will save any other signals sent while it was sleeping and act on them once it wakes up.
  - **Zombie:** If a process has ended but its parent process hasn’t acknowledged the termination signal because it’s sleeping.

- `$ ps` → report a snapshot of the current processes.

- **To print a process tree:**  
  ```sh
  $ ps -ejH 
  $ ps axjf
  ```

- **To see every process running as root (real & effective ID) in user format:**  
  ```sh
  $ ps -U root -u root u
  ```

- `a` → Display every process on the system associated with a tty terminal  
- `-A, -e` → Display every process on the system  
- `-C CommandList` → Only display processes running a command in the CommandList  
- `-g GIDList, -group GIDList` → Only display processes whose current effective group is in GIDList  
- `-G GIDList, -Group GIDList` → Only display processes whose current real group is in GIDList  
- `-N` → Display every process except selected processes  
- `p PIDList, -p PIDList, --pid PIDList` → Only display PIDList processes  
- `-r` → Only display selected processes that are in a state of running  
- `-t ttyList, --tty ttyList` → List every process associated with the ttyList terminals  
- `-T` → List every process associated with the current tty terminal  
- `-u UserList, --user UserList` → Only display processes whose effective user (username or UID) is in UserList  
- `-U UserList, --User UserList` → Only display processes whose real user (username or UID) is in UserList  
- `x` → Remove restriction of “associated with a tty terminal”; typically used with the `a` option  

- `$ top` → viewing Linux processes  

- `1` → Toggles the single CPU and Symmetric Multiprocessor (SMP) state  
- `t` → Toggles display of the CPU information line  
- `m` → Toggles display of the MEM and SWAP information lines  
- `f` → Adds or removes different information columns  
- `F or O` → Selects a field on which to sort the processes (%CPU by default)  
- `h` → Toggles showing of threads  
- `z` → Toggles color and mono mode  
- `k` → Kills a specific process (only if process owner or if root user)  
- `d or s` → Changes the update interval (default three seconds)  
- `q` → Exits the `top` command  

- `$ uptime`  
- `$ sleep` → number of seconds you wish the script to freeze  
- `$ jobs` → display status of jobs in the background  
- `$ bg` → Move jobs to the background. First use `Ctrl+Z` to pause the process  

```sh
$ bash CriticalBackups.sh
^Z
[2]+ Stopped bash CriticalBackups.sh
$ bg %2
[2]+ bash CriticalBackups.sh &
```

- `$ fg` → Move job to the foreground  
- `$ lsof -p PID` → See if the running program has any files open  
- `$ kill` → Send a signal to a process. By default, it is TERM  

The generally accepted procedure is to first try `TERM`, if the process ignores that, try `INT` or `HUP`. `KILL` is the most forceful signal and should be used as a last resort.

- `$ killall` → Kill processes by name  
- `$ pgrep , $ pkill` → Look up or signal processes based on name and other attributes  
- `$ nohup` → Run a command immune to hangups, with output to a non-tty  

Will force the application to ignore any input from `STDIN`. By default, `STDOUT` and `STDERR` are redirected to the `$HOME/nohup.out` file.

- `$ nice` → Run a program with modified scheduling priority  
- `$ renice` → Alter priority of running processes  

**Why send processes signals?**  
1. A process gets hung up and just needs a gentle nudge to either get going again or stop.  
2. A process runs away with the CPU and refuses to give it up.  

**Interprocess communication signals:**

| Number | Name  | Description                                      |
|--------|------|--------------------------------------------------|
| 1      | HUP  | Hangs up                                        |
| 2      | INT  | Interrupts                                      |
| 3      | QUIT | Stops running                                  |
| 9      | KILL | Unconditionally terminates                     |
| 11     | SEGV | Segments violation                             |
| 15     | TERM | Terminates if possible                         |
| 17     | STOP | Stops unconditionally, but doesn’t terminate   |
| 18     | TSTP | Stops or pauses, but continues to run in background |
| 19     | CONT | Resumes execution after STOP or TSTP          |

# Commands

- `[TAB] [TAB]` → see recommendations  
- `$ strace` → sys call trace, `$ ltrace` → library call trace, `$ ptrace` → process trace for debugging and injection  
- `$ strace -p 1` → what syscalls pid 1 is using  
- `$ ldd /usr/bin/ls` → see what libs a software is using  
- `$ users` → online users logged in system, right now  
- `$ file a.txt` → show info about `a.txt`  
- `$ ln` → hard linking  
- `$ lsmod` → list all modules that are running on kernel  
- `$ & (flag)` → in background  
- `$ nc -nlvp [port number]` → open port  
- `$ netstat -antp` → show all open ports  
- `$ systemctl list-units --type slice` → show users unit in systemd  
- `$ dd if=/dev/zero of=/dev/null bs=1M &` → fake CPU usage for benchmarking  
- `$ cron -e` → do something on schedule that I am telling you  
- `$ namectl set-hostname ASGHAR`, `$ bash` → change name and re-open terminal  
- `$ jobs -l` → list all jobs on the system; active, stopped, or otherwise  
- `$ kill -9 [PID]`  
- `$ cp -p /home/john/fosh.txt` → don’t change any attributes and timestamp of file when copied  
- `$ grep -i pwquality \*` → search for `pwquality` in all files of this directory  

## Packages

- `$ dnf update` → update repos  
- `$ dnf update -security` → just update security-related packages  
- `$ dnf updateinfo` → showing info about packages with their updates  
- `$ dnf updateinfo list updates security` → showing info about security-related package updates  

Because of recent filtering situation and better performance of package managers:  

1. Edit configuration:
   ```sh
   $ vim /etc/dnf/dnf.conf
   ```
   Add:
   ```
   skip_if_unavailable=True
   fastestmirror=1
   ```

2. If encountering YAML file missing warnings:
   ```sh
   $ dnf update libmodule
   ```

- `$ uname [option]` → print system information  
- `$ cd -` → go back to most recent directory  
- `$ which -a filename (e.g., hello.sh, echo)` → locate command  
- `$ which vim` → `/usr/bin/vim`  
- `$ lsof -p PID` → see if the running program has any files open  

---

## Monitoring & Log

- When you can’t use `ps`, try:  
  ```sh
  $ cat /proc/8/cmdline
  ```
  This shows what process is running.

---

## Environmental Variables
| **NAME**     | **Description** |
|-------------|----------------|
| **BASH_VERSION** | Current Bash shell instance’s version number |
| **EDITOR** | Default editor, e.g. vim, nano |
| **GROUPS** | User account’s group memberships |
| **HISTSIZE** | Maximum number of commands stored in history file |
| **HISTFILE** | History file path |
| **HOME** | Current user’s home directory name |
| **HOSTNAME** | Current system’s host name |
| **LANG** | Locale category for the shell |
| **PATH** | Colon-separated list of directories to search for commands |
| **PS1** | Primary shell command-line interface prompt string |
| **PS2** | Secondary shell command-line interface prompt string |
| **PWD** | User account’s current working directory |
| **SHLVL** | Current shell level |
| **TZ** | User’s time zone, if different from system’s time zone |
| **UID** | User account’s user identification number |
| **VISUAL** | Default screen-based editor used by some shell commands |

# Locale Related  

- `LANG="en_US.UTF-8"`
- `LC_COLLATE="en_US.UTF-8"`
- `LC_CTYPE="en_US.UTF-8"`
- `LC_MESSAGES="en_US.UTF-8"`
- `LC_MONETARY="en_US.UTF-8"`
- `LC_NUMERIC="en_US.UTF-8"`
- `LC_TIME="en_US.UTF-8"`
- `LC_ALL=`

## Modify Environmental Variables

- **Using `=`** → Not survive entering into a subshell  

```sh
$ MYVAR=101
$ echo $SHLVL  # 1
$ echo $MYVAR  # 101
$ bash
$ echo $MYVAR  # (empty)
$ echo $SHLVL  # 2
```

- **Using `export`** → Survives entering into a subshell  
- `$ unset ENV_VAR` → To unset a variable  

If you need to **permanently change** the environmental variables, you’ll need to add the `export` command to the `.bashrc` file in your `$HOME` folder so that it runs each time you log in.

---

# Security  

- `$ md5sum` → Compute and check MD5 message digest, used for integrity, produces a 128-bit hash value  
- `$ sha2256sum file.txt`

---

# Booting & Initializing  

### Main Steps of Booting  

1. The server firmware starts, performing a quick check of the hardware, called a **Power-On Self-Test (POST)**, and then it looks for a boot loader program to run from a bootable device.  
2. The boot loader runs and determines what Linux kernel program to load.  
3. The kernel program loads into memory; prepares the system, such as mounting the root partition; and then runs the initialization program.  
4. The initialization process starts the necessary background programs required for the system to operate (such as a graphical desktop manager for desktops or web and database applications for servers).  

### System Firmware  

- When a machine is powered on, the CPU is hardwired to execute boot code stored in ROM.  
- The system firmware typically knows about all the devices that live on the motherboard, such as SATA controllers, network interfaces, USB controllers, and sensors for power and temperature.  
- During normal bootstrapping, the system firmware probes for hardware and disks, runs a simple set of health checks, and then looks for the next stage of bootstrapping code.  

All **IBM-compatible workstations and servers** utilize some type of built-in firmware to control how the installed operating system starts:  

- **BIOS (Basic Input/Output System)**  
- **UEFI (Unified Extensible Firmware Interface)**  

### BIOS  

- One limitation of the original BIOS firmware was that it could read only one sector’s worth of data from a hard drive into memory to run. That’s not enough space to load an entire operating system.  
- To get around that limitation, most operating systems split the boot process into two parts:  
  - The **BIOS runs a boot loader program**, a small program that initializes the necessary hardware to find and run the full operating system program.  
  - The **Master Boot Record (MBR)** is the first sector on the first hard drive partition on the system. The BIOS looks for the MBR and reads the program stored there into memory.  
  - The boot loader program mainly points to the location of the actual operating system kernel file.  

### UEFI  

- Intel created the **Extensible Firmware Interface (EFI)** in 1998, and by 2005, the **Unified EFI (UEFI)** specification was adopted as a standard.  
- UEFI specifies a special disk partition, called the **EFI System Partition (ESP)**, to store boot loader programs.  
- On Linux systems, the ESP is typically mounted in the `/boot/efi` directory, and the boot loader files are typically stored using the `.efi` filename extension, such as `linux.efi`.  

### Extracting Information about the Boot Process  

```sh
$ dmesg            # Print or control the kernel ring buffer
$ journalctl       # Query the systemd journal
# Log files:
# - /var/log/boot (Debian distros)
# - /var/log/boot.log (RH distros)
```

---

# Boot Loaders  

A boot loader helps bridge the gap between the system firmware and the full **Linux operating system kernel**.  

## GRUB  

- **GRUB Legacy** (1999) was created to provide a robust and configurable boot loader.  
- **GRUB2** (2005) introduced:  
  - The ability to load hardware driver modules.  
  - Using logic statements to alter the boot menu options dynamically, depending on conditions detected on the system.  

## GRUB Configuration Files  

- **GRUB Legacy** stores the menu commands in:  
  - `/boot/grub/menu.list` (Debian)  
  - `/boot/grub/grub.conf` (RH)  
- **GRUB2** config file:  
  - BIOS: `/boot/grub/grub.cfg` or `/boot/grub2/grub.cfg`  
  - UEFI: `/boot/efi/EFI/[distro-name]/grub.cfg`  

```sh
$ grub-install   # Install GRUB Legacy on your drive
$ grub2-mkconfig -o /boot/grub2/grub.cfg  # Generates a new GRUB2 config
```

### Alternative Boot Loaders  

- `systemd-boot`  
- `U-Boot boot loader`  

---

# Initialization  

The **initialization daemon (init)** determines which services are started and in what order.

Two types of initialization daemons:  

- **SysVinit** → Not used by most major Linux distributions anymore.  
- **systemd** (2010) → The most popular system service initialization and management mechanism.  

## Systemd  

The easiest way to start exploring **systemd** is through the **systemd units**.  
A unit defines a service, a group of services, or an action. Each unit consists of a name, a type, and a configuration file.

### systemd Unit Types  

- `automount`
- `device`
- `mount`
- `slice`
- `snapshot`
- `socket`
- `path`
- `scope`
- `service`
- `swap`
- `target`
- `timer`

# systemd Service Unit Files

systemd service unit files can be found in these directories:  
(If a file is found in two different directory locations, one will have precedence over the other)

- `/etc/systemd/system/`
- `/run/systemd/system/`
- `/usr/lib/systemd/system/`

```sh
$ systemctl list-units  # Looking at systemd unit names
$ systemctl list-unit-files  # See unit file’s enablement state
```

There are at least **12 different enablement states**, but you’ll commonly see these 3:

- **enabled**: Service starts at system boot.
- **disabled**: Service does not start at system boot.
- **static**: Service starts if another unit depends on it. Can also be manually started.

```sh
$ systemctl cat name.unit-type  # Show base name & directory location of the unit file
```

## systemd Unit File Configuration Sections

### `[Unit]` — Basic directives

- **After** → Sets this unit to start *after* the designated units.
- **Before** → Sets this unit to start *before* the designated units.
- **Description** → Describes the unit.
- **Documentation** → URIs for documentation sources (web locations, system files, info pages, man pages).
- **Conflicts** → If any of the designated units start, this unit is *not* started. *(Opposite of Requires.)*
- **Requires** → This unit *must* start together with the designated units. *(Opposite of Conflicts.)*
- **Wants** → This unit *should* start together with the designated units but will still start even if the designated units fail.
- **AllowIsolate** → Similar to changing the runlevel in a traditional init system.

### `[Service]` — Configuration items specific to that service

- **ExecReload** → Scripts or commands to run when unit is reloaded.
- **ExecStart** → Scripts or commands to run when unit is started.
- **ExecStop** → Scripts or commands to run when unit is stopped.
- **Environment** → Sets environment variables.
- **EnvironmentFile** → Indicates a file that contains environment variable substitutes.
- **RemainAfterExit** → *(yes/no)* If set to *yes*, the service is left active even when ExecStart process terminates.
- **Restart** → *(no, on-success, on-failure, on-abnormal, on-watchdog, on-abort, always)*
- **Type** → Sets the startup type.

### `[Install]` — Determines what happens when a service is enabled/disabled

- **Alias** → Additional names for the service in systemctl commands.
- **Also** → Additional units that must be enabled or disabled for this service.
- **RequiredBy** → Designates other units that require this service.
- **WantedBy** → Specifies which target unit manages this service.

---

# Target Unit Files  

Groups together various services to start at system boot time.  
The default target unit file, `default.target`, is symbolically linked to the target unit file used at system boot.

```sh
$ systemctl get-default  # Show the default.target link
$ systemctl isolate multi-user.target  # Change target
$ systemctl status graphical.target  # Check status of a target & whether it's active
$ systemctl list-units --type=target  # List all systemd targets
```

### Commonly Used System Boot Target Unit Files:

- **graphical.target** → Multiple users, GUI access available.
- **multi-user.target** → Multiple users, no GUI access.
- **runleveln.target** → SysVinit compatibility (n = 1-5).
- **rescue.target** → Mounts all local filesystems, root-only access, no networking, minimal services.
- **emergency.target** → Only mounts root filesystem as read-only, root-only access, minimal services.

---

# Commonly Used systemctl Service Management Commands  

```sh
$ systemctl start <service>
$ systemctl stop <service>
$ systemctl status <service>
$ systemctl restart <service>
$ systemctl reload <service>
$ systemctl disable <service>
$ systemctl enable <service>
$ systemctl daemon-reload
$ systemctl mask <service>
$ systemctl unmask <service>
```

### Convenient systemctl Service Status Checks  

```sh
$ systemctl is-active <service>  # Is service running?
$ systemctl is-enabled <service>  # Is service enabled?
$ systemctl is-failed <service>  # Has service failed?
$ systemctl is-system-running  # Overall system state
```

---

# systemctl Operational Statuses  

```sh
$ systemctl is-system-running
```

- **running** → System is fully in working order.
- **degraded** → System has one or more failed units.
- **maintenance** → System is in emergency or recovery mode.
- **initializing** → System is starting to boot.
- **starting** → System is still booting.
- **stopping** → System is starting to shut down.

---

# SysVinit  

- **systemd** is backward compatible with **SysVinit**.  
- **SysVinit** uses *runlevels* instead of *targets* to determine what groups of services to start.

```sh
$ systemctl list-units --type=service  # View active services
$ systemctl show <service>  # Display properties of a systemd service
```

# Runlevel Comparison: RedHat-based vs Debian-based

| Runlevel   | RedHat-based                                        | Debian-based                                      |
|------------|----------------------------------------------------|--------------------------------------------------|
| **0**      | Shut down the system                               | Shut down the system                            |
| **1, s or S** | Single-user mode used for system maintenance (Similar to system rescue target) | Single-user mode used for system maintenance (Similar to system rescue target) |
| **2**      | Multi-user mode without networking services enabled. | Multi-user mode with GUI available.             |
| **3**      | Multi-user mode with networking services enabled.  | -                                                |
| **4**      | Custom                                            | -                                                |
| **5**      | Multi-user mode with GUI available.               | -                                                |
| **6**      | Reboot the system.                                | Reboot the system.                              |

# SysV Runlevel Commands

- `$ runlevel` → Print previous and current SysV runlevel
- `$ init, telinit` → Change SysV runlevel (e.g. `$ init 6`)
- `/etc/inittab` → SysVinit systems employ a configuration file that sets the default runlevel
- `/etc/init.d/` → Each service must have an initialization script which is responsible for starting, stopping, restarting, reloading, and displaying the status of various system services.
- `/etc/init.d/` or `/etc/rc.d/` → The program that calls these initialization scripts is the `rc` script, and it can be found here.
- `$ service` → Run a System V init script

## Commonly Used Service Utility Commands

- `start`
- `stop`
- `status`
- `restart`
- `reload`
- `--status-all` → Runs all init scripts, in alphabetical order.

---

## Stopping the System

- `halt` → Stops all processes and shuts down the CPU.
- `poweroff` → Stops all processes, shuts down the CPU, and sends signals to the hardware to power down.
- `reboot` → Stops all processes, shuts down the CPU, and then restarts the system.
- `shutdown` → Stops all processes, shuts down the CPU, and sends signals to the hardware to power down.

### `$ shutdown` Options:

- `-H, --halt` → Halt the machine.
- `-P, --poweroff` → Power-off the machine (the default).
- `-r, --reboot` → Reboot the machine.
- `--no-wall` → Do not send wall message before halt, power-off, reboot.
- `-c` → Cancel a pending shutdown.
- `TIME` → `now`, `hh:mm`, `+m`

> For any utility used to shut down the system, the processes are sent a `SIGTERM` signal. This allows the various running programs to close their files properly and gracefully terminate.

- `$ lsof -p PID` → See if a running program has any files open.
- `$ kill -9 PID` → Forcefully terminate a process.

### **ACPI Daemon (`acpid`)**

After processes are stopped and the CPU is shut down, signals are sent to the hardware to power down. For operating systems using **Advanced Configuration and Power Interface (ACPI)**–compliant chipsets, these are ACPI signals. The **`acpid`** daemon manages signals sent to various hardware devices based on predefined settings.

---

## **Wall Messages with `systemctl`**

The `systemctl` utility will send a **wall message** when any of these commands are issued:

- `emergency`
- `halt`
- `power-off`
- `reboot`
- `rescue`

---

# **Configuring Hardware**

Each device uses some type of standard protocol to communicate with the system:

### **Common Protocols**
- **Peripheral Component Interconnect (PCI)** standard
  - `$ setpci` → View & manually change settings for a board.
- **Universal Serial Bus (USB) interface**
  - Kernel must have the proper module installed to recognize the USB bus controller.
  - Linux system must also have a kernel module installed for the individual device type plugged into the USB bus.
- **General Purpose Input/Output (GPIO) interface**

---

## **Device Files and Directories**

- `/dev/` → Kernel dynamically assigns device files.
- **Types of device files:**
  - **Character device files** → Transfer data one character at a time (used for terminals, USB devices).
  - **Block device files** → Transfer data in large blocks (used for hard drives, network cards).

- `/dev/mapper` (Device Mapper) → Maps physical block devices to virtual block devices.
  - Used by:
    - **Logical Volume Manager (LVM)** for creating logical drives.
    - **Linux Unified Key Setup (LUKS)** for encrypting data on hard drives.

- `/proc/` → A virtual directory dynamically populated by the kernel for system information.
  - `$ cat /proc/interrupts` → Display interrupt requests (IRQs).
  - `$ sudo cat /proc/ioports` → Display input/output (I/O) ports.
  - `$ cat /proc/dma` → Display direct memory access (DMA) channels.

- `/sys/` → Created by the kernel in the **sysfs** filesystem format, providing additional information about hardware devices.

---

## **Device Information Commands**

- `$ lsdev` → Display installed hardware information.
- `$ lsblk` → List block devices.
- `$ lspci` → List all PCI devices.
- `$ lsusb` → List USB devices.

---

# **Linux Kernel Modules**

The **Linux kernel** requires **device drivers** to communicate with hardware. Instead of including all drivers in the kernel, **kernel modules** are dynamically loaded at runtime.

- Kernel module files are stored in `/lib/modules/` and use the `.ko` extension.
- Each kernel version has its own directory (e.g., `/lib/modules/4.3.3`).

## **Kernel Module Files and Commands**

- `/etc/modules` → Modules the kernel loads at boot time.
- `/etc/modules.conf` → Kernel module configurations.
- `/lib/modules/version/modules.dep` → Determines module dependencies.

### **Kernel Module Management Commands**
- `$ lsmod` → Show loaded kernel modules.
- `$ modinfo` → Show information about a kernel module.
  - Example: `$ modinfo bluetooth`
- `$ insmod` → Insert a module into the Linux kernel.
- `$ rmmod` → Remove a module from the Linux kernel.
- `$ modprobe` → Add or remove modules from the Linux kernel.

# Storage & FileSystem

## Drive Interfaces

- **Parallel Advanced Technology Attachment (PATA)**
  - Connects drives using a parallel interface, which requires a wide cable. 
  - PATA supports two devices per adapter.

- **Serial Advanced Technology Attachment (SATA)**
  - Connects drives using a serial interface, but at a much faster speed than PATA.
  - SATA supports up to four devices per adapter.

- **Small Computer System Interface (SCSI)**
  - Connects drives using a parallel interface, but with the speed of SATA.
  - SCSI supports up to eight devices per adapter.

- **Device File Naming**
  - For **PATA devices**, raw device file is named `/dev/hda`, `/dev/hdb`, ...
  - For **SATA and SCSI devices**, raw device file is named `/dev/sda`, `/dev/sdb`, …

---

## Partitions

A partition is a self-contained section within the drive that the operating system treats as a separate storage space. 

- Partitions must be tracked by some type of indexing system on the drive.

### **Partition Table Types**

- **Master Boot Record (MBR)**
  - Used for the old BIOS boot loader.
  - Supports up to **four primary partitions** on a drive.
  - Each primary partition can be split into **multiple extended partitions**.

- **GUID Partition Table (GPT)**
  - Used for the **UEFI boot loader**.
  - Supports up to **128 partitions** on a drive.

- **Linux Partition Naming**
  - Linux assigns partition numbers **in the order** they appear on the drive, starting with **1**.
  - Linux creates `/dev` files for each separate disk partition.
  - **MBR extended partitions** are numbered **starting at 5**.

---

## **Device Management with `udev`**

The **udev** program runs in the background and automatically detects new hardware connected to a Linux system. 

- It assigns each device a unique filename in the `/dev` directory.
- It also creates **persistent device files** for storage devices.

**udev creates four separate directories for storing links:**
- `/dev/disk/by-id` → Links storage devices by manufacturer make, model, and serial number.
- `/dev/disk/by-label` → Links storage devices by label.
- `/dev/disk/by-path` → Links storage devices by the physical hardware port they are connected to.
- `/dev/disk/by-uuid` → Links storage devices by their **128-bit universally unique identifier (UUID)**.

---

## **Device Mapper (DM) Multipathing**

- The **Linux kernel supports DM multipathing**, which aggregates multiple paths to provide **fault tolerance** and **increased throughput**.

### **Multipathing Tools**
- **dm-multipath** → Kernel module providing multipath support.
- **multipath** → CLI tool to view multipath devices.
- **multipathd** → Background process monitoring paths and activating/deactivating paths.
- **kpartx** → CLI tool for creating device entries for multipath storage devices.

Multipath devices appear under:
```
/dev/mapper/mpathN
```
Where `N` is the number of the multipath drive.

---

## **Logical Volume Manager (LVM)**

The **Linux Logical Volume Manager (LVM)** allows you to create **virtual drive devices** using `/dev/mapper`.

- You can **aggregate multiple physical drive partitions into virtual volumes**, treating them as a **single partition**.
- **LVM allows dynamic resizing** by adding or removing physical partitions.

### **LVM Tools**
- `$ pvcreate` → Creates a physical volume.
- `$ vgcreate` → Groups physical volumes into a volume group.
- `$ lvcreate` → Creates a logical volume from partitions in each physical volume.

---

## **RAID (Redundant Array of Inexpensive Disks)**

RAID technology allows:
- **Improved data access performance**.
- **Data redundancy for fault tolerance**.

Linux uses **software RAID**, implemented with:
- `$ mdadm` → CLI tool to configure and manage RAID devices.

### **RAID Levels**
- **RAID 0** → Disk striping for performance.
- **RAID 1** → Disk mirroring for redundancy.
- **RAID 10** → Combination of striping and mirroring.
- **RAID 4** → Disk striping with a dedicated parity disk.
- **RAID 5** → Disk striping with **distributed parity** for fault tolerance.
- **RAID 6** → Disk striping with **double parity**, allowing for two failed drives.

---

## **Disk Partitioning Tools**

### **MBR-Based Partitioning: `fdisk`**
- `$ fdisk` → Manipulates disk partition tables.

#### **`fdisk` Commands**
- `a` → Toggle bootable flag.
- `d` → Delete a partition.
- `g` → Create a new GPT partition table.
- `l` → List known partition types.
- `n` → Add a new partition.
- `p` → Print partition table.
- `w` → Write table to disk and exit.

---

## **Advanced Partitioning: `parted`**
- `$ parted` → Modify partition sizes dynamically.
- **Graphical Interface:** `GParted`.

---

# FileSystem

- Linux utilizes filesystems to manage data stored on storage devices. A filesystem maintains a map to locate each file placed in the storage device.
- Windows assigns drive letters to each storage device you connect to the system. Linux uses a virtual directory structure. The virtual directory contains file paths from all the storage devices installed on the system, consolidated into a single directory structure.
- The Linux virtual directory structure doesn’t give you any clues as to which physical device contains the file.
- Linux places physical devices in the virtual directory using **mount points**. A mount point is a directory placeholder within the virtual directory that points to a specific physical device.
- Before you can assign a drive partition to a mount point in the virtual directory, you must format it using a filesystem.

## Filesystems:

### btrfs:
- Supports files up to **16 exbibytes (EiB)** in size, and a total filesystem size of **16 EiB**.
- Perform its own form of RAID as well as **LVM and subvolumes**.
- **Built-in snapshots** for backup.
- **Improved fault tolerance**.
- **Data compression** on the fly.

### Ecryptfs (Enterprise Cryptographic Filesystem):
- Applies a **Portable Operating System Interface (POSIX)**–compliant encryption protocol to data before storing it on the device.
- This provides a **layer of protection** for data stored on the device.
- Only the **operating system that created** the filesystem can read data from it.

### ext3 (ext3fs):
- Descendant of the original Linux ext filesystem.
- Supports files up to **2 tebibytes (TiB)**, with a total filesystem size of **16 TiB**.
- Supports **journaling**, as well as faster **startup and recovery**.

### ext4 (ext4fs):
- The **current version** of the original Linux filesystem.
- Supports files up to **16 TiB**, with a total filesystem size of **1 EiB**.
- Supports **journaling** and utilizes improved performance features.
- **Default filesystem** used by most Linux distributions.

### reiserFS:
- Created before the **Linux ext3fs filesystem** and commonly used on older Linux systems.
- Provides features now found in **ext3fs** and **ext4fs**.
- Linux has dropped support for the most recent version, **reiser4fs**.

### swap:
- The **swap filesystem** allows you to create **virtual memory** for your system using space on a physical drive.
- The system can then **swap data** out of normal memory into the swap space, providing a method of adding **additional memory** to your system.
- This is **not** intended for storing **persistent data**.

## Non-Linux FS:
- **CIFS** → Common Internet Filesystem (CIFS)
- **exFAT** → The Extended File Allocation Table
- **HFS** → The Hierarchical Filesystem (HFS)
- **ISO-9660**
- **NFS** → The Network Filesystem (NFS)
- **NTFS** → The New Technology Filesystem (NTFS)
- **SMB** → The Server Message Block (SMB)
- **UDF** → The Universal Disk Format (UDF)
- **VFAT** → The Virtual File Allocation Table (VFAT)
- **XFS** → The X Filesystem (XFS)
- **ZFS** → The Zettabyte Filesystem (ZFS)

## Journaling:
- A method of **tracking data** not yet written to the drive in a log file, called the **journal**.
- If the system **fails before the data** can be written to the drive, the **journal data can be recovered** and stored upon the next system boot.

```bash
$ mkfs  # Build a Linux FS
$ sudo mkfs -t ext4 /dev/sdb1
```

# Mount

- After you’ve formatted a drive partition with a filesystem, you can add it to the virtual directory on your Linux system. This process is called mounting the filesystem.
- `$ mount` → mount a filesystem. It only temporarily mounts the device in the virtual directory. When you reboot the system, you have to manually mount the devices again.

```bash
$ sudo mount -t ext4 /dev/sdb1 /media/usb1
```

- `$ umount` → unmount a filesystem.
- `/etc/fstab` → Indicate which drive devices should be mounted to the virtual directory at boot time. A table that indicates:
  - The drive device file (either the raw file or one of its permanent udev filenames).
  - The mount point location.
  - The filesystem type, ...

```bash
$ df     # Report file system disk space usage
$ du     # Estimate file space usage. Produces text usage report (in kilobytes) by directory
$ iostat # Displays a real-time chart of disk statistics by partition
$ lsblk  # Displays current partition sizes and mount points : /proc/partitions - /proc/mounts
```

## e2fsprogs (ext Filesystem Tools)

- `blkid`: Display information about block devices, such as storage drives.
- `chattr`: Change file attributes on the filesystem.
- `debugfs`: Manually view and modify the filesystem structure, such as undeleting a file or extracting a corrupted file.
- `dumpe2fs`: Display block and superblock group information.
- `e2label`: Change the label on the filesystem.
- `resize2fs`: Expand or shrink a filesystem.
- `tune2fs`: Modify filesystem parameters.

## XFS Filesystem Tools

- `xfs_admin`: Display or change filesystem parameters such as the label or UUID assigned.
- `xfs_db`: Examine and debug an XFS filesystem.
- `xfs_fsr`: Improve the organization of mounted filesystems.
- `xfs_info`: Display information about a mounted filesystem, including the block sizes and sector sizes, as well as label and UUID information.
- `xfs_repair`: Repair corrupted or damaged XFS filesystems.

```bash
$ fsck  # Check and repair a Linux filesystem. A front-end to several different programs that check the various filesystems.
```

- If any discrepancies occur, run the fsck program in repair mode, and it will attempt to reconcile the discrepancies and fix the filesystem. If the fsck program is unable to repair the drive on the first run, try running it again a few times to fix any broken files and directory links.

```bash
$ sudo fsck -f /dev/sdb1
```

# GUI

- A windows manager is a program that communicates with the display server (sometimes called a windows server) on behalf of the UI.
- Each particular desktop environment has its own default window manager, such as Mutter, Kwin, Muffin, Marco, and Metacity.
- The display server is a program that uses a communication protocol to transmit the desires of the UI to the operating system, and vice versa. The communication protocol, called the display server protocol, can operate over a network. A compositor program arranges various display elements within a window to create a screen image to be passed back to the client.
- The X Window System (X for short) is the display server used for Linux systems. It was developed in the 1980s. In Linux there was only one software package that supported X, called XFree86.  
  In 2004, the XFree86 project changed their licensing requirements, which caused many Linux distributions to switch to the X.Org foundation’s implementation of X, simply called X.Org. Many distributions created their own customizations of the X.Org server; thus, you will see a wide variety of names concerning the Linux X display server, such as X.org-X11, X, X11, and X.Org Server.
- Within the past few years, a new X display server package called **Wayland** has made headway in the Linux world.

---

## X.org

- The X.Org package keeps track of display card, monitor, and input device information in a configuration file, using the original XFree86 format. The primary configuration file is `/etc/X11/xorg.conf`, though the file is sometimes stored in the `/etc/` directory. Typically, however, this file is no longer used.
- Individual applications or devices store their own X11 settings in separate files stored in the `/etc/X11/xorg.conf.d` directory.
- The X.Org software can detect most common hardware devices, so no manual configuration is required. In some cases, auto-detection might not work properly, and you need to make X11 configuration changes. In this case, you can manually create the configuration file.  

  **Steps to manually configure X11:**
  1. Shut down the X Server by going to a command prompt and using:  
     ```bash
     $ sudo telinit 3
     ```
  2. Use superuser privileges to generate the file via:
     ```bash
     $ Xorg -configure
     ```
  3. The file, named `xorg.conf.new`, will be in your local directory.
  4. Make any necessary tweaks, rename the file, move the file to its proper location, and restart the X server.

### xorg.conf Sections Information:

- **Input Device:** Configures the session’s keyboard and mouse.
- **Monitor:** Sets the session’s monitor configuration.
- **Modes:** Defines video modes.
- **Device:** Configures the session’s video card(s).
- **Screen:** Sets the session’s screen resolution and color depth.
- **Module:** Denotes any modules that need to be loaded.
- **Files:** Sets file path names, if needed, for fonts, modules, and keyboard layout files.
- **Server Flags:** Configures global X server options.
- **Server Layout:** Links together all the session’s input and output devices.

- If something goes wrong with the display process, the X.Org server generates the `.xsession-errors` file in your Home directory (often referred to as `~/.xsession-errors`).

#### Two utilities are available to help:
- `xdpyinfo`: Provides information about the X.Org server, including the different screen types available, the default communication parameter values, protocol extension information, and more.
- `xwininfo`: Provides window information. If no options are given, an interactive utility asks you to click on the window for which you desire statistics.

---

## Wayland

- **Wayland** is designed to be simpler, more secure, and easier to develop and maintain than the X.Org software.
- Wayland defines the communication protocol between a display server and its various clients. However, **Wayland** is also an umbrella term that covers the compositor, the window server, and the display server.
- The **Wayland compositor** is **Weston**. However, Weston provides a rather basic desktop experience. It was created as a Wayland compositor reference implementation.  
  Weston’s core focus is **correctness and reliability**. Wayland’s compositor is **swappable**. You can use a different compositor if you need a more full-featured desktop experience.  
  Several compositors are available for use with Wayland, including:
  - Arcan
  - Sway
  - Lipstick
  - Clayland

### Troubleshooting Wayland:

#### Try the GUI without Wayland:
- If your Linux distribution has multiple flavors of the desktop environment (with Wayland or with X11), log out of your GUI session and pick the **desktop environment without Wayland**.  
  If your UI problems are resolved, then you know it has most likely something to do with Wayland.

#### Disable Wayland in GNOME:
- If you do not have multiple flavors of the desktop environment and you are using the **GNOME shell** user interface, turn off Wayland by following these steps:

  1. Using superuser privileges, edit the `/etc/gdm3/custom.conf` file:
  2. Remove the `#` from the `#WaylandEnable=false` line and save the file.
  3. Reboot the system and log in to a GUI session and see if the problems are gone.

#### Additional Fixes:
- **Check your system’s graphics card:** If your system seems to be running fine under X11 but gets problematic when running under Wayland, check your graphics card.
- **Use a different compositor:** If you are using a desktop environment’s built-in compositor or one of the other compositors, try installing and using the **Weston** compositor package instead.

---

## Desktop Environment Components

- **Desktop Settings**
- **Display Manager**
- **File Manager**
- **Icons**
- **Favorites Bar**
- **Launch**
- **Menus**
- **Panels**
- **System Tray**
- **Widgets**
- **Windows Manager**

- The **display manager** component is responsible for controlling the graphical login feature.  
  Every Linux display manager package uses the **X Display Manager Control Protocol (XDMCP)** to handle the graphical login process.

- The **X Display Manager (XDM)** package is the basic display manager software available for Linux.  
  It presents a generic **user ID and password** login screen, passing the login attempt off to the Linux system for verification.  
  If the system authenticates the login attempt, XDM starts up the appropriate **X server** environment and Windows desktop environment.

```bash
/etc/X11/xdm/xdm-config
```
> XDM display manager is somewhat generic, but there are some configuration features you can modify. In most situations, you’ll never need to modify these settings.

### Common Display Managers:
- **KDM:** The default display manager used by the KDE desktop environment.
- **GDM:** The default display manager used by the GNOME desktop environment.
- **LightDM:** A bare-bones display manager used in lightweight desktop environments such as Xfce.

---

## X11 Forwarding

- The **X11 system** utilizes a **classic client/server model** for serving up graphical desktops.  
  In most situations, the client and server both run on the same physical device, but that doesn’t need to be the case.

### Enabling X11 Forwarding:
1. Check if **X11 forwarding** is permitted in your OpenSSH configuration file (`/etc/ssh/sshd_config`).
2. Ensure the directive `X11Forwarding` is set to `yes` on the remote system.
3. Connect using SSH with X11 forwarding:
   ```bash
   $ ssh -X user@remote-host
   ```

Here is your content properly **reformatted** into **Markdown (.md)** while **keeping everything intact**:

# Remote Desktop Software

## Virtual Network Computing (VNC)
- VNC is multiplatform and employs the **Remote Frame Buffer (RFB) protocol**.
- This protocol allows a user on the client side to send **GUI commands** (e.g., mouse clicks) to the server.
- The server sends **desktop frames** back to the client’s monitor.
- The **VNC server** offers a GUI service at **TCP port 5900+n**, where **n** equals the display number (usually `1`, meaning **port 5901**).
- The **VNC server** is flexible:
  - Java-enabled web browsers can access it at **TCP port 5800+n**.
  - HTML5 client web browsers are supported as well.

### **Benefits of Using VNC**
- **Flexibility** in providing remote desktops.
- Desktops are available for **multiple users**.
- Supports both **persistent and static desktops**.
- **On-demand desktop provisioning**.
- **SSH tunneling** can be employed via `ssh` or a client viewer command-line option to encrypt traffic.

### **Potential Concerns with VNC**
- The **VNC server** handles only **mouse movements and keystrokes**.  
  It does **not** deal with file transfer, audio transfer, or printing services for the client.
- By **default, VNC does not encrypt traffic**; you must tunnel it through **OpenSSH** for security.
- **The VNC server password** is stored as **plaintext** in a server file.

---

## TigerVNC
- A modern, high-performance VNC implementation.

---

## XRDP (Remote Desktop Protocol)
- **Supports RDP (Remote Desktop Protocol)** and uses `X11rdp` or `Xvnc` to manage the GUI session.
- **Provides only the server side** of an RDP connection.
- **Allows access from multiple RDP clients**, such as:
  - `rdesktop`
  - `FreeRDP`
  - **Microsoft Remote Desktop Connection**

### **Benefits of XRDP**
- **Uses RDP**, which **encrypts traffic** using **Transport Layer Security (TLS)**.
- A **wide variety of open-source RDP client software** is available.
- **Persistent desktop support** (can reconnect to an already existing session).
- **Handles mouse movements, keystrokes, audio transfers**, and **mounting of local client drives** on the remote system.

#### XRDP Configuration
```bash
/etc/xrdp/xrdp.ini
```
> This file contains **various XRDP configuration settings**.  
> An important setting in this file is the **security_layer directive**.

---

## NX Protocol (NX Technology)
**Benefits of Using NX:**
- **Excellent response times**, even over **low-bandwidth** and **high-latency** connections.
- **Faster than VNC-based products**.
- **Uses OpenSSH tunneling by default**, ensuring **encrypted traffic**.
- **Supports multiple simultaneous users** through a **single network port**.
- **Compresses X11 data**, reducing network data transfer and improving response times.
- **Employs caching techniques** to enhance remote desktop performance.

---

## Simple Protocol for Independent Computing Environments (SPICE)
- **SPICE is typically used for remote access to KVM virtual machines**, competing with VNC.
- **Provides high-performance remote desktop connections**.

### **SPICE Features**
- **Supports multiple client connections** via **multiple data socket connections**.
- **Delivers desktop experience speeds comparable to local usage**.
- **Consumes minimal CPU resources**, making it efficient for multi-VM server environments.
- **Supports high-quality video streaming**.
- **Enables live migration**, meaning **no connection interruptions when a virtual machine is migrated to a new host**.


# Administering the System:

## Locale

- Not only does each country have its own language (or sometimes, sets of languages), but each country also has its own way in which people write numerical values, monetary values, and the time and date. For a Linux system to be useful in any specific location, it must adapt to the local way of doing all those things.
- A character set defines a standard code used to interpret and display characters in a language.

### ASCII
- The American Standard Code for Information Interchange (ASCII) uses 7 bits to store characters found in the English language.

### ISO-8859
- The International Organization for Standardization (ISO) worked with the International Electrotechnical Commission (IEC) to produce a series of standard codes for handling international characters. There are 15 separate standards (ISO-8859-1 through ISO-8859-15) for defining different character sets.

### Unicode
- The Unicode Consortium, composed of many computing industry companies, created an international standard that uses a 3-byte code and can represent every character known to be in use in all countries of the world.

### UTF
- Unicode Transformation Format (UTF) transforms the long Unicode values into either 1-byte (UTF-8) or 2-byte (UTF-16) simplified codes. For work in English-speaking countries, the UTF-8 character set is replacing ASCII as the standard.

### Locale Command
- `$ locale` —> get locale-specific environmental variables. The output of the locale command is in the format: language_country.character set
- For changing locales
- Changing manually: (changes the localization for your current login session)
  - Using `$ export`
  - Instead of having to change all of the LC_ environment variables individually, the LANG environment variable controls all of them at one place.
- `$ localectl` —> Control the system locale and keyboard layout settings.

## Time

- Many elements depend on accurate time, such as programs designed to run at particular moments, remote services that expect accurate client times (and will reject the client if their times are inaccurate), and maintaining accurate log message time stamps in order to properly investigate client/server issues.
- Local time is also called wall clock time.
- It’s often easier to use a different standard called Coordinated Universal Time (UTC). UTC is a time that does not change according to an individual’s time zone.
- Linux maintains two time clocks:

### Hardware Based
- Also called the real-time clock. Attempts to maintain the correct time, even when the system is powered down by using power from the system battery (traditionally called the CMOS battery). When the system boots, the Linux OS gets the time from the hardware clock and updates its software clock.

### Software Based
- This clock runs only while the system is up and is used by many utilities on Linux, which is why it is sometimes called system time. Unfortunately, the Linux software clock has a tendency to become inaccurate, especially if it is a busy system.

- Each country selects one or more time zones, or offsets from the standard Coordinated Universal Time (UTC) time, to determine time within the country.
- `/etc/timezone` (Debian-based) & `/etc/localtime` (Red Hat–based) —> These files are not in a text format, so you can’t simply edit. To change the time zone for a Linux system, copy or link the appropriate time zone template file from the `/usr/share/zoneinfo` folder to the `/etc/timezone` or `/etc/localtime` location. e.g: `/usr/share/zoneinfo/US/Eastern`.
- `$ hwclock` —> Time clocks utility.
- `$ date` —> Display or set the time and date in a multitude of formats.
- `$ timedatectl` —> Control the system time and date.

### Network Time Protocol (NTP)
- A network protocol used to synchronize clocks over a network in order to provide accurate time. NTP uses what is called a clock stratum scheme. The stratums are numbered from 0 to 15. The devices at stratum 0 are highly accurate time-keeping hardware devices, such as atomic clocks. The next level down is stratum 1, which consists of computers that are directly connected to the stratum 0 devices.
- One of the most popular NTP servers is actually a cluster of servers that work together in what is called a pool. To use the NTP server pool, when you configure your NTP client application, enter `pool.ntp.org` as your NTP server.
- An interesting time problem revolves around leap seconds. Because the earth’s rotation has been slowing down, our actual day is about 0.001 seconds less than 24 hours. About every 19 months or so, NTP passes a leap second announcement. This is typically handled without any problems and the clocks are set backward by one second. Some applications have problems, Google introduced free public time servers that use NTP and smear the leap second over the course of time so that there is no need to issue a leap second announcement. This is called leap-smearing. The Google leap-smearing NTP servers are `timen.google.com`, where `n` is set to 1 through 4.
- If you need to implement an NTP client program, you have choices:
  - You can either employ the NTP daemon (ntpd)
  - Or use the newer chrony daemon (chronyd).

- For years the NTP program was synonymous with the network time protocol, and on Linux they were often spoken of interchangeably. But it does have some limitations, such as keeping time accurate when the network has high traffic volumes, which is why alternatives such as chrony were developed. The NTP program is installed by default on some distributions and not on others. The package name is ntp, so you can check to see if it is installed.
- `/etc/ntp.conf` —> It contains, among other directives, the NTP time servers you wish to use. The directive name for setting these, On CentOS is `server` & On Ubuntu is `pool`.
- `$ ntpq -p` —> View a table showing what time servers your ntpd is polling and when the last synchronization took place.

### Chronyd
- The chrony daemon (`chronyd`) has many improvements over ntpd.
  - It can keep accurate time even on systems that have busy networks or that are down for periods of time, and even on virtualized systems.
  - It synchronizes the system clock faster than does ntpd, and it can easily be configured to act as a local time server itself.
  - The package name is chrony.
  - On CentOS and other Red Hat–based distros, chrony is installed by default, but not enabled on boot (by default). Use superuser privileges and type `$ systemctl start chronyd` at the command line.
  - On Ubuntu, when chrony is installed, it is automatically started and enabled on boot.
  - `/etc/chrony.conf` or `/etc/chrony/chrony.conf` —> Primary configuration file for chrony. The directive name for setting these is either `server` or `pool`. The `server` directive is typically used for a single time server designation. `pool` indicates a server pool. `rtcsync` directive directs chrony to periodically update the hardware time (real-time clock).
  - `chronyc` — Command-line interface for chrony daemon.

# Users & Groups

- User accounts and their underlying framework are at the center of credential management and access controls. These accounts are a part of Linux’s discretionary access control (DAC).
- DAC is the traditional Linux security control, where access to a file, or any object, is based on the user’s identity and current group membership.
- Though a user account can have lots of group memberships, its process can have only one designated current group at a time.

- A user account, sometimes called a normal account, is any account, an authorized human with the appropriate credentials has been given to access the system and perform daily tasks.
- A user ID (UID) is the number used by Linux to identify user accounts.
- System accounts are accounts that provide services (daemons) or perform special tasks, such as the root user account.
- root UID is 0.
- `/etc/login.defs` —> typically installed by default on most Linux distributions. contains directives for use in various shadow password suite commands. such as the useradd, userdel, and passwd commands. The directives in this configuration file control: password length, how long until the user is required to change the account’s password, whether or not a home directory is created by default, and so on. The file is typically filled with comments and commented-out directives.

| Name            | Desc                                                                                                                                      |
|-----------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| PASS_MAX_DAYS   | Number of days until a password change is required. This is the password’s expiration date.                                               |
| PASS_MIN_DAYS   | Number of days after a password is changed until the password may be changed again.                                                      |
| PASS_MIN_LENGT  | Minimum number of characters required in password.                                                                                        |
| PASS_WARN_AGE   | Number of days a warning is issued to the user prior to a password’s expiration.                                                         |
| CREATE_HOME     | Default is no. If set to yes, a user account home directory is created.                                                                  |
| ENCRYPT_METHOD  | The method used to hash account passwords.                                                                                                 |
| UID_MIN         | Indicates the lowest UID allowed for user accounts.                                                                                       |
| SYS_UID_MIN     | A system account’s minimum UID                                                                                                            |

- `/etc/default/useradd` —> directs the process of creating accounts.
- `$ cat /etc/default/useradd`, or `$ sudo useradd -D`


| Name          | Desc                                                                                         |
|---------------|----------------------------------------------------------------------------------------------|
| HOME          | Base directory for user account directories.                                                |
| INACTIVE      | Number of days after a password has expired and has not been changed until the account will be deactivated. See PASS_MAX_DAYS in slide #10. |
| SKEL          | The skeleton directory.                                                                      |
| SHELL         | User account default shell program.                                                          |

- `/etc/skel` —> The skeleton directory as it is commonly called, holds files. If a home directory is created for a user, these files are to be copied to the user account’s home directory, when the account is created. These files are account environment files as well as a configuration file directory.
- `/etc/passwd` —> Account information is stored here. Each account’s data occupies a single line in the file. When an account is created, a new record for that account is added to this file.
  
  ```bash
  $ cat /etc/passwd
  ```

1. `root:x:0:0:root:/root:/bin/bash`
2. `user1:x:1000:1000:User One:/home/user1:/bin/bash`

- The file records contain seven fields in total and each field in a record is delimited by a colon (:)

1. User account’s username.
2. Password field. Typically this file is no longer used to store passwords. An x in this field indicates passwords are stored in the `/etc/shadow` file.
3. User account’s user identification number (UID).
4. User account’s group identification number (GID).
5. Comment field. This field is optional. Traditionally it contains the user’s full name.
6. User account’s home directory.
7. User account’s default shell. If set to `/sbin/nologin` or `/bin/false`, then the user cannot interactively log into the system.

- Prevent an Account from Interactively Logging, enter `/sbin/nologin` or `/bin/false` in record 7 of `/etc/passwd`, which is for default shell.

- `/sbin/nologin` is typically set for system service account records. System services (daemons) do need to have system accounts, but they do not interactively log in. Instead, they run in the background under their own account name. If a malicious person attempted to interactively log in using the account they are politely kicked off the system. `/sbin/nologin` displays a brief message and logs you off before you reach a command prompt. You can modify the message shown by creating the file `/etc/nologin.txt` and adding the desired text.
- `/bin/false` shell is a little more brutal than later. If this is set as a user account’s default shell, no messages are shown, and the user is just logged out of the system.

- `/etc/shadow` —> Each account’s data occupies a single file line.

  ```bash
  $ sudo cat /etc/shadow
  ```

1. `root:!::0:99999:7:::`
2. `bin:*:17589:0:99999:7:::`
3. `user1:$6$bvqdqU[…]:17738:0:99999:7:::`

- The `/etc/shadow` records contain several fields. Each field in a record is delimited by a colon (:).

1. User account’s username.
2. Password field. The password is a salted and hashed password.
   - A `!!` or `!` indicates a password has not been set for the account.
   - A `!` or an `*` indicates the account cannot use a password to log in.
   - A `!` in front of a password indicates the account has been locked.
3. Date of last password change in Unix Epoch time (days) format.
4. Number of days after a password is changed until the password may be changed again.
5. Number of days until a password change is required. This is the password’s expiration date.
6. Number of days a warning is issued to the user prior to a password’s expiration (see field #5).
7. Number of days after a password has expired (see field #5) and has not been changed until the account will be deactivated.
8. Date of account’s expiration in Unix Epoch time (days) format.
9. Called the special flag. It is a field for a special future use, is currently not used, and is blank.

- `$ useradd` —> Create a new user or update default new user information.
- `$ getent` —> Get entries from Name Service Switch libraries to view a user account’s information.
- `$ passwd` —> Change user password.
- `$ chage` —> Change user password expiry information in a more human-readable format.
- `$ usermod` —> Modify a user account.
- `$ userdel` —> Delete a user account and related files.

  - `-r, --remove`: Files in the user's home directory will be removed along with the home directory itself and the user's mail spool. Files located in other file systems will have to be searched for and deleted manually.

- Groups are identified by their name as well as their group ID (GID).
- If a default group is not designated when a user account is created, then a new group is created. This new group has the same name as the user account’s name and it is assigned a new GID.
- `/etc/group` —> Where information about groups are being saved.
- `$ getent group [USER]` —> See default group of a user.
- `$ groupadd` —> Create a new group.
- `$ sudo usermod -aG [GROUP] [USER]` —> Add an account to a group.
- `$ groupmod` —> Modify a group.
- `$ groupdel` —> Delete a group.

———————————————

**Email:**
- Linux follows the Unix method of handling email, which is a modular software.
  
- The Linux email server is normally divided into three separate functions: (Some Linux email packages combine functionality for the MTA and MDA functions, whereas others combine the MDA and MUA functions.)

  1. The mail transfer agent (MTA): sends incoming emails (and outgoing emails being delivered locally) to a mail delivery agent (MDA) or local user’s inbox. For outbound messages being transferred to a remote system, the agent establishes a communication link with another MTA program on the remote host to transfer the email.
  
  2. The mail delivery agent (MDA): is a program that delivers messages to a local user’s inbox.
  
  3. The mail user agent (MUA): is an interface for users to read messages stored in their mailboxes. MUAs do not receive messages; they only display messages that are already in the user’s mailbox.

- Popular MTA packages:
  
  1. sendmail
  2. postfix
  3. exim

- Because Sendmail was a popular MTA for so long, the Postfix MTA program is backward compatible with it.
- binmail program has been the most popular MDA program used on Linux systems. It’s typical location on the system is `/bin/mail` (or `/usr/bin/mail`). It is no longer installed by default on all Linux distributions.
- `/var/spool/mail` directory (can be configured to read `$HOME/mail` file instead) —> Where binmail reads email messages.
- `$ mail`, `mailx`, `Mail` —> Send and receive mail.
- An email alias allows you to redirect email messages to a different recipient. For example, on a corporate web server, instead of listing your email address (and at the same time letting every hacker in the world know your username) you can employ an alias, such as `hostmaster`. While you do need to use super user privileges, there are only two steps to setting up an email alias:

  1. Add the alias to the `/etc/aliases` file. The format of the alias records is:

     ```bash
     ALIAS-NAME: RECIPIENT1[,RECIPIENT2[,…]]
     ```

  2. Run the `$ newaliases` command to update the aliases database, `/etc/aliases.db`.

- Forwarding email is another way other than aliases, and it’s done at the user level:

  1. The user creates the `.forward` file in their `$HOME` directory and puts in the username who should be receiving the forwarded emails.
  
  2. The `$ chmod` command is used on the `.forward` file to set the permissions to 644 (octal).

---

## Configure Printing:

- CUPS (Common Unix Printing System) provides a common interface for working with any type of printer on Linux systems. It accepts print jobs using the PostScript document format and sends them to printers using a print queue system.
- The print queue is normally configured to support not only a specific printer but also a specific printing format, such as landscape or portrait mode, single-sided or double-sided printing, or even color or black and-white printing. There can be multiple print queues assigned to a single printer, or multiple printers that can accept jobs assigned to a single print queue.
- The CUPS software uses the Ghostscript program to convert the PostScript document into a format understood by the different printers. The Ghostscript program requires different drivers for the different printer types to know how to convert the document to make it printable on that type of printer. This is done using configuration files and drivers.
- `/etc/cups` —> The configuration files of CUPS software are stored in here.
- To define a new printer on your Linux system, you can use the CUPS web interface. Open your browser and navigate to `http://localhost:631/`.
- You can also configure network printers using several standard network printing protocols, such as the Internet Printing Protocol (IPP) or the Microsoft Server Message Block (SMB) protocol.
  
### CUPS CLI:

- `cancel`: Cancels a print request.
- `cupsaccept`: Enables queuing of print requests.
- `cupsdisable`: Disables the specified printer.
- `cupsenable`: Enables the specified printer.
- `cupsreject`: Rejects queuing of print requests.

- CUPS also accepts commands from the legacy BSD command-line printing utility:

  - `lpc`: Start, stop, or pause the print queue.
  - `lpq`: Display the print queue status, along with any print jobs waiting in the queue.
  - `lpr`: Submit a new print job to a print queue.
  - `lprm`: Remove a specific print job from the print queue.

---

## Log & Journaling:

- In the early days of Unix, a range of different logging methods tracked system and application events. Applications used different logging methods, making it difficult for system administrators to troubleshoot issues.
- In the mid-1980s Eric Allman defined a protocol for logging events from his Sendmail mail application called syslog. The syslog protocol quickly became a de facto standard for logging both system and application events in Unix, and it made its way to the Linux world.
- What made the syslog protocol so popular is that it defines a standard message format that specifies the time stamp, type, severity, and details of an event. That standard can be used by the operating system, applications, and even devices that generate errors.
- The type of event is defined as a facility value. The facility defines what is generating the event message, such as a system resource or an application.
- Each event is also marked with a severity. The severity value defines how important the message is to the health of the system.

- The syslog protocol facility values:
| Code | Keyword     | Description                                                              |
|------|-------------|--------------------------------------------------------------------------|
| 0    | kern        | Messages generated by the system kernel                                  |
| 1    | user        | Messages generated by user events                                        |
| 2    | mail        | Messages from a mail application                                         |
| 3    | daemon      | Messages from system applications running in background                  |
| 4    | auth        | Security or authentication messages                                      |
| 5    | syslog      | Messages generated by the logging application itself                     |
| 6    | lpr         | Printer messages                                                          |
| 7    | news        | Messages from the news application                                       |
| 8    | uucp        | Messages from the Unix-to-Unix copy program                              |
| 9    | cron        | Messages generated from the cron job scheduler                          |
| 10   | authpriv    | Security or authentication messages                                      |
| 11   | ftp         | File transfer Protocol application messages                              |
| 12   | ntp         | Network Time Protocol application messages                               |
| 13   | security    | Log audit messages                                                       |
| 14   | console     | Log alert messages                                                       |
| 15   | solaris-cron| Another scheduling daemon message type                                   |
| 16-23| local0-local7 | Locally defined messages                                               |

---

## The syslog protocol severity values

| Code | Keyword     | Description                                                                 |
|------|-------------|-----------------------------------------------------------------------------|
| 0    | emerg       | The event causes the system to be unusable                                   |
| 1    | alert       | An event that requires immediate attention                                   |
| 2    | crit        | An event that is critical but doesn’t require immediate attention            |
| 3    | err         | An error condition that allows the system or application to continue         |
| 4    | warning     | A non-normal warning condition in the system or application                  |
| 5    | notice      | A normal but significant condition message                                  |
| 6    | info        | An informational message from the system                                    |
| 7    | debug       | Debugging messages for developers                                           |

# History of Linux Logging

- **sysklogd** → The original syslog application, it includes two programs: the syslogd program to monitor the system and applications for events, and the klogd program to monitor the Linux kernel for events.
- **syslogd-ng** → Added advanced features, such as message filtering and the ability to send messages to remote hosts.
- **rsyslog** → The project claims the "r" stands for "rocket fast." Speed is the focus of the rsyslog project, and the rsyslogd application has quickly become the standard logging package for many Linux distributions.
- **systemd-journald** → Part of the systemd application for system startup and initialization, many Linux distributions are now using this for logging. It does not follow the syslog protocol but instead uses a completely different way of reporting and storing system and application events.

## rsyslogd

- `/etc/rsyslogd.conf` file or `*.conf` files in the `/etc/rsyslog.d/` directory → define rules on what events to listen for and how to handle them using the rsyslogd program.
- Format of an rsyslogd rule is: `facility.priority action`

    - The **facility** entry uses one of the standard syslog protocol facility keywords.
    - The **priority** entry uses the severity keyword as defined in the syslog protocol, but with a twist.
    - The **action** entry defines what rsyslogd should do with the received syslog message.

### Setting Priority

- **kern.crit**

    - Logs all kernel event messages with a severity of critical, alert, or emergency.
    - When you define a severity, syslogd will log all events with that severity or higher (lower severity code).

- **kern.=crit**

    - Logs only messages with a specific severity.

- **\*.emerg**

    - Logs all events with an emergency severity level. Use wildcard characters for either the facility or priority.

### Actions

- Forward to a regular file
- Pipe the message to an application
- Display the message on a terminal or the system console
- Send the message to a remote host
- Send the message to a list of users
- Send the message to all logged-in users

### rsyslogd.conf configuration entries, for Ubuntu 18.04:

- `auth,authpriv.* /var/log/auth.log`
- `_._;auth,authpriv.none -/var/log/syslog`
- `kern.* -/var/log/kern.log`
- `mail.* -/var/log/mail.log`
- `mail.err /var/log/mail.err`
- `_.emerg :omusrmsg:_`

### rsyslogd.conf configuration entries, for CentOS 7:

- `*.info;mail.none;authpriv.none;cron.none /var/log/messages`
- `authpriv.* /var/log/secure`
- `mail.* -/var/log/maillog`
- `cron.* /var/log/cron`
- `_.emerg :omusrmsg:_`
- `uucp,news.crit /var/log/spooler`
- `local7.* /var/log/boot.log`

A common server these days in many data centers is a central logging host that receives and stores logs for all its various log client systems. Configuring your system to act as a logging client is fairly easy using the rsyslog application’s configuration file(s). For doing so, edit the `/etc/rsyslogd.conf` configuration file and go to the file’s bottom:

- `TCP|UDP[(z#)]HOST:[PORT#Linux] → _._ @@(z9)[loghost.anisa.co.ir:6514](http://loghost.anisa.co.ir:6514)`

- **TCP|UDP**: You can select either the TCP or UDP protocols to transport your log messages to the central log server. UDP can lose data, so you should select TCP if your log messages are important. Use a single at sign (@) to select UDP and double at signs (@@) to choose TCP.
- **[(z#)]**: This syntax is optional. The `z` selects `zlib` to compress the data prior to traversing the network, and the `#` picks the compression level, which can be any number between 1 (lowest compression) and 9 (highest compression).
- **HOST**: Designates the central logging server either by a fully qualified domain name (FQDN), such as `example.com`, or an IP address. If you use an IPv6 address, it must be encased in brackets.
- **[PORT#]**: This syntax is optional. Designates the port on the remote central logging host where the log service is listening for incoming traffic.

## logrotate

- For busy Linux systems, it doesn’t take long to generate large log files. So many Linux distributions install the logrotate utility. It automatically splits rsyslogd log files into archive files based on a time or the size of the file. You can usually identify archived log files by a numerical extension added to the log filename.
- logrotate can also compress, delete, and if desired, mail a log file to a designated account.
- To ensure the files are handled in a timely manner, the logrotate utility is typically run every day as a cron job.
- `/etc/logrotate.conf` → configuration file to determine how each log file is managed.

- `$ logger` → Enter messages into the system log. If you create and run scripts on your Linux system, you may want to log your own application events.

- Most Linux distributions create log files in the `/var/log` directory.
- Depending on the security of the Linux system, many log files are readable by everyone, but some may not be.
- It’s also common for individual applications to have a separate directory under the `/var/log` directory for their own application event messages, such as `/var/log/apache2` for the Apache web server.
- Since rsyslogd log files are text files, you can use any of the standard text tools available in Linux, such as `cat`, `head`, `tail`, as well as filtering tools, such as `grep`, to view the files and search them. One common trick for administrators is to watch a log file by using the `-f` option with the `tail` command. That displays the last few lines in the log file but then monitors the file for any new entries and displays those too.

## systemd-journald

- We call it a journal utility instead of a logging utility.
- The system-journald program uses a completely different method of storing event messages from the syslog protocol. However, it does store syslog messages as well as notes from the kernel, boot events, service messages, and so on.
- `/etc/systemd/journald.conf` → The systemd-journald service reads its configuration from this configuration file.


| Directive                | Description                                                                                                                                                           |
|--------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Storage=**              | Set to auto, persistent, volatile, or none. Determines how systemd-journald stores event messages. (Default is auto.)                                                  |
| **Compress=**             | Set to yes or no. If yes, journal files are compressed. (Default is yes.)                                                                                             |
| **ForwardToSyslog=**      | Set to yes or no. If yes, any received messages are forwarded to a separate syslog program, such as rsyslogd, running on the system. (Default is yes.)                  |
| **ForwardToWall=**        | Set to yes or no. If yes, any received messages are forwarded as wall messages to all users currently logged into the system. (Default is yes.)                        |
| **MaxFileSec=**           | Set to a number followed by a time unit (such as month, week, or day) that sets the amount of time before a journal file is rotated (archived). Typically this is not needed if a size limitation is employed. To turn this feature off, set the number to 0 with no time unit. (Default is 1month.) |
| **RuntimeKeepFree=**      | Set to a number followed by a unit (such as K, M, or G) that sets the amount of disk space systemd-journald must keep free for other disk usages when employing volatile storage. (Default is 15% of current space.) |
| **RuntimeMaxFileSize=**  | Set to a number followed by a unit (such as K, M, or G) that sets the amount of disk space systemd-journald journal files can consume if it is volatile.               |
| **RuntimeMaxUse=**        | Set to a number followed by a unit (such as K, M, or G) that sets the amount of disk space systemd-journald can consume when employing volatile storage. (Default is 10% of current space.) |
| **SystemKeepFree=**       | Set to a number followed by a unit (such as K, M, or G) that sets the amount of disk space systemd-journald must keep free for other disk usages when employing persistent storage. (Default is 15% of current space.) |
| **SystemMaxFileSize=**    | Set to a number followed by a unit (such as K, M, or G) that sets the amount of disk space systemd-journald journal files can consume if it is persistent.              |
| **SystemMaxUse=**         | Set to a number followed by a unit (such as K, M, or G) that sets the amount of disk space systemd-journald can consume when employing persistent storage. (Default is 10% of current space.) |

