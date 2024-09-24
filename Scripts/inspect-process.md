# Check if Java 8 is being used by any systemd services

- List all services that might use Java
```
$ systemctl list-units --type=service | grep -i java
```

- Check if any service is specifically using Java 8
```
$ sudo systemctl cat <service_name>.service
```

- Check running processes for Java 8
```
$ ps aux | grep '/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java'
```

- Check for open files
```
$ lsof | grep '/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java'
```

# Inspect the result of a specific process based on its PID

## Using ps to Filter by PID
```
$ ps -p <PID> -o pid,ppid,user,comm,%cpu,%mem,etime,start,args

pid: Process ID.
ppid: Parent process ID.
user: The user running the process.
comm: Command name.
%cpu: CPU usage.
%mem: Memory usage.
etime: Elapsed time since the process started.
start: Start time of the process.
args: Full command with all arguments that started the process.
```

## Using cat to View Process Details from the /proc Directory

- Command line arguments:
```
$ cat /proc/<PID>/cmdline
```

- Environment variables
```
$ cat /proc/<PID>/environ
```

- Current working directory
```
$ ls -l /proc/<PID>/cwd
```

- Opened files
```
$ ls -l /proc/<PID>/fd
```

- Status of the process
```
$ cat /proc/<PID>/status
```

## Using top or htop for Real-Time Monitoring

- using top
```
$ top -p <PID>
```

- using htop: Run htop and search for the PID by pressing / and entering the PID number.


# Inspect a Process for Port and network

## Method 1: Using netstat
```
$ sudo netstat -tulnp | grep 100

-t : Show TCP connections.
-u : Show UDP connections.
-l : Show listening ports.
-n : Show numerical addresses and ports.
-p : Show the PID and program name of the process.
```

## Method 2: Using ss (Socket Statistics)
```
$ sudo ss -tulnp | grep 100
```

## Method 3: Using lsof (List Open Files)
```
$ sudo lsof -Pan -p 100 -i

-P : Show port numbers instead of service names.
-a : Combine multiple conditions (e.g., process and network interface).
-n : Show numerical addresses instead of resolving hostnames.
-p 100 : Filter by the process ID (PID 100).
-i : Show only internet (network) files.
```