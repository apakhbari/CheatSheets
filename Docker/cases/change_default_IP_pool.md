To change the default IP pool of Docker (version 24.0.2, build cb74dfc) to the `10.10.0.0/16` range, you need to modify the Docker daemon's configuration file to specify a custom IP address range for Docker's network bridge.

Here are the steps to achieve this:

### 1. Edit the Docker Daemon Configuration File
Docker's configuration is typically managed via the `daemon.json` file located at `/etc/docker/daemon.json`.

1. Open the file in a text editor:

   ```bash
   sudo nano /etc/docker/daemon.json
   ```

2. Add or modify the `"default-address-pools"` key to include your desired IP range:

   ```json
   {
     "default-address-pools": [
       {
         "base": "10.10.0.0/16",
         "size": 24
       }
     ]
   }
   ```

   - `base`: This is the base IP address range for Docker networks.
   - `size`: This specifies the size of each network subnet that Docker will allocate from the pool. `24` is common because it allows for up to 256 addresses per network.

3. Save and close the file (`Ctrl + O`, then `Ctrl + X`).

### 2. Restart Docker

After modifying the `daemon.json` file, you need to restart the Docker service for the changes to take effect:

```bash
sudo systemctl restart docker
```

### 3. Verify the Configuration

You can verify that Docker is using the new default IP address pool by inspecting a newly created Docker network:

```bash
docker network create test-network
docker network inspect test-network
```

Look for the IP range in the output under the `IPAM` section. It should show an IP range within `10.10.0.0/16`.

### Notes:

- Ensure that the IP range you choose does not conflict with your existing network setup.
- If you have existing containers or networks, they won’t be automatically reallocated to the new IP pool. You may need to recreate them if you want them to use the new IP range.
  
By following these steps, Docker will use `10.10.0.0/16` for the IP pool of its bridge networks going forward.