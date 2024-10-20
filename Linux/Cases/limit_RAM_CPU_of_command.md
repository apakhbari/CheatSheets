### 1. **Using `cpulimit` to restrict CPU usage**

`cpulimit` is a simple tool to limit the CPU usage of a specific process.

#### Steps:
1. Install `cpulimit` if it's not installed:
   ```bash
   sudo apt-get install cpulimit
   ```

2. Use `cpulimit` to restrict CPU usage to a specific percentage. For example, to limit a command to 30% CPU usage:
   ```bash
   cpulimit --limit=30 -- <your_command>
   ```

### 2. **Using `prlimit` to restrict CPU and RAM**

`prlimit` allows you to set resource limits for a process, such as CPU time, memory usage, etc.

#### Steps:
1. To restrict both CPU and memory, you can use `prlimit`:
   
   For example, to restrict a command to use only 1 CPU second and 500MB of RAM:
   ```bash
   prlimit --cpu=1 --as=500M -- <your_command>
   ```

   - `--cpu=1` limits the CPU time to 1 second.
   - `--as=500M` restricts the process's address space (virtual memory) to 500 MB.

### 3. **Using `cgroups` for more granular control**

`cgroups` (control groups) give you fine-grained control over CPU, memory, and other resources.

#### Steps:

1. Install `cgroup-tools`:
   ```bash
   sudo apt-get install cgroup-tools
   ```

2. Create a new cgroup for your process:
   ```bash
   sudo cgcreate -g memory,cpu:/mygroup
   ```

3. Set memory and CPU limits. For example, to limit the memory to 500MB and CPU to 20%:
   ```bash
   echo 500M | sudo tee /sys/fs/cgroup/memory/mygroup/memory.limit_in_bytes
   echo 20000 | sudo tee /sys/fs/cgroup/cpu/mygroup/cpu.cfs_quota_us
   ```

4. Run the command within the cgroup:
   ```bash
   sudo cgexec -g memory,cpu:/mygroup <your_command>
   ```

This approach gives you more control and allows persistent restrictions for specific tasks.

Let me know if you need more details or assistance with any of these methods!