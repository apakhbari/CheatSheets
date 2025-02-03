
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
