Step 1: Check Current Swap Usage

First, verify your swap usage to confirm the problem:

bash

free -h

This command will display your system's memory and swap usage in human-readable format.

Look for the Swap line. If swap usage is above 50%, note the total size, used swap, and free swap.
Step 2: Identify Processes Using Swap

To identify which processes are using swap memory, you can use smem (if not installed, you can install it with sudo apt install smem):

bash

sudo apt install smem
sudo smem -rs swap

This will show you a list of processes sorted by their swap usage.

Alternatively, if smem is not available or you prefer another method, you can use top or htop to inspect memory usage:

bash

top -o %MEM

Look at the %MEM column to see which processes are consuming the most memory. If the system is swapping due to RAM exhaustion, those processes are likely contributing to high swap usage.
Step 3: Check Swap Size

Verify if the swap partition or file is large enough for your workload:

bash

swapon --show

This will display the size of your swap space. If your swap space is relatively small compared to your workload, consider increasing it (discussed in Step 6).
Step 4: Check Available RAM

Check if your system is running low on physical RAM, which may force the system to use swap space:

bash

free -h

Alternatively, use:

bash

vmstat -s

Look at the "free memory" value to assess how much RAM is available. If your system is consistently running out of RAM, it will resort to swap, leading to high swap usage.
Step 5: Examine Swap Tendency (swappiness)

The swappiness value controls how aggressively the kernel uses swap. A high swappiness value means the kernel will swap more aggressively, even when RAM is available. You can check your current swappiness value:

bash

cat /proc/sys/vm/swappiness

The default value is typically 60, meaning the kernel will start swapping when RAM usage reaches about 40%. If this value is too high, it may be causing excessive swap usage.
Step 6: Adjust swappiness to Reduce Swap Usage

If your system is using swap excessively even when RAM is available, try lowering the swappiness value. Setting it to a lower value like 10 or 20 will make the system prefer using RAM over swap:

    Temporarily adjust swappiness:

    bash

sudo sysctl vm.swappiness=10

This change will take effect immediately but is temporary (it will revert after a reboot).

To make it permanent, edit /etc/sysctl.conf:

bash

sudo nano /etc/sysctl.conf

Add or modify this line:

bash

vm.swappiness=10

Save and exit the editor. Then apply the changes:

bash

    sudo sysctl -p

Step 7: Increase Swap Size (if Needed)

If you determine that your swap space is too small for your system's workload, you can increase it. You can either expand your swap partition (if possible) or create an additional swap file.
To create an additional swap file:

    Create a new swap file:

    bash

sudo fallocate -l 2G /swapfile

This creates a 2GB swap file (adjust the size as needed).

Set the correct permissions:

bash

sudo chmod 600 /swapfile

Format the file as swap:

bash

sudo mkswap /swapfile

Enable the swap file:

bash

sudo swapon /swapfile

Make the swap file permanent by adding it to /etc/fstab:

bash

echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

Verify the swap space:

bash

    swapon --show

    This will confirm that your system is now using the new swap space.

Step 8: Restart Services or Reboot (If Necessary)

If certain services or applications are using excessive memory and swap, restarting them may help reclaim memory and reduce swap usage:

bash

sudo systemctl restart <service_name>

If the situation doesn't improve after adjustments, consider rebooting the server during a scheduled maintenance window.
Step 9: Monitor Swap and RAM Usage

After making the adjustments, continuously monitor swap and memory usage to ensure the problem doesn't reoccur:

bash

free -h
watch -n 5 free -h

Use monitoring tools like htop, vmstat, or a more advanced monitoring solution to track memory usage trends over time.
Final Recommendations:

    Optimize Applications: Investigate and optimize applications that use excessive memory. Profiling tools might help identify memory leaks or inefficiencies in your applications.
    Add More RAM: If your workload exceeds the available RAM consistently, consider adding more physical memory to the server. This is a more permanent solution to prevent swapping.

By following these steps, you should be able to inspect the root cause of the high swap usage on your Ubuntu server and address it without risking data loss or negatively affecting production.