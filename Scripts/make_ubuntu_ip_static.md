
1. find out the network interface name ```$ sudo ip a```
2. ```$ sudo vi /etc/netplan/01-netcfg.yaml ```
3. Apply chmod 600 for all ``` $ chmod 600 -R /etc/netplan/ ```
4. ```$ ls -ltrh```
5. apply netplan ``` $ sudo netplan apply ```
6. ``` $ ```