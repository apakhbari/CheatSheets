To move `/var/lib/docker` from `sda2` to `sdb`, you need to follow these steps carefully. This process involves stopping the Docker service, transferring data, and remounting the directory. Here's how:

---

### **Steps to Move `/var/lib/docker` from `sda2` to `sdb`**

2. **Create a Mount Point**  
   Create a directory to mount the new storage:
   ```bash
   sudo mkdir -p /mnt/docker
   ```

3. **Mount `sdb` Temporarily**  
   Mount `sdb` to the new directory:
   ```bash
   sudo mount /dev/sdb /mnt/docker
   ```

4. **Stop Docker Service**  
   Stop Docker to ensure there are no active processes using `/var/lib/docker`:
   ```bash
   sudo systemctl stop docker
   ```

5. **Copy Existing Docker Data**  
   Copy the current contents of `/var/lib/docker` to the new mount point:
   ```bash
   sudo rsync -aH /var/lib/docker/ /mnt/docker/
   ```

6. **Backup and Unmount `/var/lib/docker`**  
   Rename the original `/var/lib/docker` directory as a backup:
   ```bash
   sudo mv /var/lib/docker /var/lib/docker.bak
   ```
   Create a new directory to act as the mount point:
   ```bash
   sudo mkdir -p /var/lib/docker
   ```

7. **Update `/etc/fstab` for Permanent Mount**  
   Edit `/etc/fstab` to mount `sdb` at `/var/lib/docker` on every reboot. Add the following line:
   ```bash
   /dev/sdb /var/lib/docker ext4 defaults 0 2
   ```

8. **Mount the New Location**  
   Mount the new `/var/lib/docker`:
   ```bash
   sudo mount -a
   ```

9. **Verify the Mount**  
   Confirm that `sdb` is correctly mounted:
   ```bash
   df -h | grep /var/lib/docker
   ```

10. **Restart Docker**  
    Start the Docker service again:
    ```bash
    sudo systemctl start docker
    ```

11. **Test Docker Functionality**  
    Run a test Docker container to ensure everything is working:
    ```bash
    docker run hello-world
    ```

12. **Cleanup Backup (Optional)**  
    Once you are sure everything is functioning, remove the backup:
    ```bash
    sudo rm -rf /var/lib/docker.bak
    ```

---

### **Points to Note**
- Ensure no active containers or volumes are running during the transfer.
- The `rsync` command is crucial for preserving file permissions, ownership, and symlinks.
- Make sure the new mount point on `sdb` has sufficient space to accommodate Docker's data.

If you encounter any issues during the process, let me know!