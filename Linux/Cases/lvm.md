# Question
This ubuntu server of mine seems to not use all 20G of space. tell me how to fix it

apa@aa-01:~$ df -h
Filesystem                         Size  Used Avail Use% Mounted on
tmpfs                              388M  1.6M  386M   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv   11G   11G     0 100% /
tmpfs                              1.9G     0  1.9G   0% /dev/shm
tmpfs                              5.0M     0  5.0M   0% /run/lock
/dev/sda2                          2.0G  255M  1.6G  14% /boot
/dev/sda1                          1.1G  6.1M  1.1G   1% /boot/efi
tmpfs                              388M  4.0K  388M   1% /run/user/1001
apa@aa-01:~$ lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0                       7:0    0 61.9M  1 loop /snap/core20/1405
loop3                       7:3    0 63.8M  1 loop /snap/core20/2682
loop4                       7:4    0 91.4M  1 loop /snap/lxd/35819
loop5                       7:5    0 50.9M  1 loop /snap/snapd/25577
loop6                       7:6    0 91.4M  1 loop /snap/lxd/36918
sda                         8:0    0   50G  0 disk
├─sda1                      8:1    0    1G  0 part /boot/efi
├─sda2                      8:2    0    2G  0 part /boot
└─sda3                      8:3    0 21.9G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0   11G  0 lvm  /
sr0                        11:0    1 1024M  0 rom


# Answer

You have a classic LVM issue! Your physical disk is 50GB, but your logical volume is only using 11GB. Here's how to fix it:

## **The Problem:**
- **Physical disk (`sda`)**: 50GB total
- **Partition `sda3`**: 21.9GB
- **LVM Logical Volume**: Only 11GB (100% full)
- **Wasted space**: ~10GB in the LVM volume group, plus ~28GB unallocated on the disk

## **Complete Fix Steps:**

### **1. First, Check Current LVM Status**
```bash
# See the volume group details
sudo vgdisplay ubuntu-vg

# See physical volume details
sudo pvdisplay /dev/sda3

# See logical volume details
sudo lvdisplay ubuntu-vg/ubuntu-lv
```

### **2. Extend the Physical Partition First**
```bash
# Check if there's free space after sda3
sudo parted /dev/sda unit GB print free

# Resize partition 3 to use all disk space
sudo growpart /dev/sda 3

# If growpart not installed:
sudo apt install cloud-guest-utils
sudo growpart /dev/sda 3

# Or manually with parted:
sudo parted /dev/sda
# In parted: resizepart 3 100%
# Then: quit
```

### **3. Rescan and Resize LVM Physical Volume**
```bash
# Tell kernel about partition change
sudo partprobe /dev/sda

# Resize the physical volume to use all partition space
sudo pvresize /dev/sda3

# Verify PV now shows larger size
sudo pvdisplay /dev/sda3
```

### **4. Extend the Logical Volume**
```bash
# Extend to use all free space in volume group
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv

# Or extend by specific amount (e.g., add 20GB)
sudo lvextend -L +20G /dev/ubuntu-vg/ubuntu-lv
```

### **5. Resize the Filesystem**
```bash
# For ext4 (most common)
sudo resize2fs /dev/ubuntu-vg/ubuntu-lv

# For xfs (if used)
# sudo xfs_growfs /
```

### **6. Verify the Fix**
```bash
df -h /
lsblk
sudo vgdisplay ubuntu-vg
```

## **Complete One-Liner Script**

Save as `expand-lvm.sh`:
```bash
#!/bin/bash
set -e

echo "=== Expanding LVM to use all disk space ==="

# Step 1: Grow partition
echo "1. Growing partition sda3..."
sudo growpart /dev/sda 3 || sudo parted /dev/sda resizepart 3 100%

# Step 2: Rescan partition table
echo "2. Rescanning partition table..."
sudo partprobe /dev/sda

# Step 3: Resize PV
echo "3. Resizing physical volume..."
sudo pvresize /dev/sda3

# Step 4: Extend LV
echo "4. Extending logical volume..."
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv

# Step 5: Resize filesystem
echo "5. Resizing filesystem..."
sudo resize2fs /dev/ubuntu-vg/ubuntu-lv

# Step 6: Show results
echo "=== Results ==="
df -h /
lsblk | grep -A 5 sda
```

Run it:
```bash
chmod +x expand-lvm.sh
sudo ./expand-lvm.sh
```

## **Alternative: You Have Even More Space!**

Your `lsblk` shows `sda` is 50G, but only 21.9G is partitioned. You can:
1. **Extend `sda3` to use all 50GB**, OR
2. **Create a new partition `sda4` and add to LVM**

### **Option 1: Extend Existing Partition (Recommended)**
```bash
# Extend sda3 to end of disk
sudo parted /dev/sda resizepart 3 100%
sudo partprobe
sudo pvresize /dev/sda3
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
sudo resize2fs /dev/ubuntu-vg/ubuntu-lv
```

### **Option 2: Add New Partition to LVM**
```bash
# Create new partition
sudo parted /dev/sda mkpart primary 21.9GB 100%
sudo parted /dev/sda set 4 lvm on

# Add to LVM
sudo pvcreate /dev/sda4
sudo vgextend ubuntu-vg /dev/sda4
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
sudo resize2fs /dev/ubuntu-vg/ubuntu-lv
```

## **Expected Final Result:**
```bash
$ df -h /
Filesystem                         Size  Used Avail Use% Mounted on
/dev/mapper/ubuntu--vg-ubuntu--lv   49G   11G   36G  24% /
```

## **If You Get Errors:**

### **Error: "No space left on device" during growpart**
```bash
# Check if partition is mounted and has free space after it
sudo parted /dev/sda unit GB print free
```

### **Error: "Partition is being used"**
```bash
# Use a live USB or:
# Boot into recovery mode
# Or run from initramfs
```

### **Error: "pvresize failed"**
```bash
# Force the resize
sudo pvresize --setphysicalvolumesize 50G /dev/sda3
```

## **Quick Fix (Most Common Case):**
```bash
# Just run these 4 commands:
sudo growpart /dev/sda 3
sudo pvresize /dev/sda3
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
sudo resize2fs /dev/ubuntu-vg/ubuntu-lv

# Check result
df -h /
```

**The key issue**: Your LVM volume group has free space that isn't allocated to the logical volume. After extending the partition and PV, you'll be able to use all 50GB.

Run the quick fix commands and share the output if you encounter any errors!