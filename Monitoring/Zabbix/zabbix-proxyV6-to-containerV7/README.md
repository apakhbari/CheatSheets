# Zabbix Upgrade plan

```
 _______  _______  _______  _______  ___   __   __ 
|       ||   _   ||  _    ||  _    ||   | |  |_|  |
|____   ||  |_|  || |_|   || |_|   ||   | |       |
 ____|  ||       ||       ||       ||   | |       |
| ______||       ||  _   | |  _   | |   |  |     | 
| |_____ |   _   || |_|   || |_|   ||   | |   _   |
|_______||__| |__||_______||_______||___| |__| |__|
```

# Table of Contents
- What i want to do
- how to do it
    - Step 1: Backup Zabbix Server and PostgreSQL Database
    - Step 2: Prepare for Migration to Docker
    - Step 3: Migrate Zabbix Server to Docker and Upgrade
    - Step 4: Migrate Zabbix Proxy and PostgreSQL Database
- Worklog
- acknowledgment


## Step 3: Migrate Zabbix Proxy and PostgreSQL Database


2. Create Docker Compose File for Zabbix Proxy: Create a docker-compose.yml for the Zabbix proxy:


3. Initialize Docker Volumes for Proxy:
```
mkdir -p /docker/zabbix_proxy/zabbix_proxy_data
mkdir -p /docker/zabbix_proxy/pgsql_proxy_data
```

4. Restore Proxy PostgreSQL Backup: Start the PostgreSQL proxy container and restore the backup:
```
docker-compose up -d postgresql
cat /backup/zabbix_proxy_db_backup.sql | docker exec -i $(docker ps -q -f "name=postgresql") psql -U zabbix_proxy -d zabbix
```

5. Start Zabbix Proxy:
```
docker-compose up -d
```

6. Verify Zabbix Proxy: Check the logs and ensure the proxy is working correctly.

## Step 5: Monitor the New Setup

1. Check Logs: Regularly check the logs of both Zabbix and PostgreSQL containers to ensure there are no errors:
```
docker logs zabbix-server
docker logs zabbix-proxy
```

2. Check Zabbix Health: Log into the Zabbix frontend and ensure that all hosts, proxies, and data are being correctly monitored.

3. Test Zabbix Alerts: Trigger some test alerts to verify that notifications are working as expected.

## Step 6: Clean Up and Decommission Old Services
1. Stop Old Services: Once you have verified the new Docker-based setup is working fine, stop the old unit services:
```
sudo systemctl disable zabbix-server
sudo systemctl disable postgresql
```

2. Remove Old Installations (optional): You can remove the old Zabbix server and PostgreSQL installations if no rollback is needed.
```
sudo apt remove zabbix-server postgresql
```


## Step 7: Clear web browser cookies and cache
After the upgrade, you may need to clear web browser cookies and web browser cache for the Zabbix web interface to work properly.

# Worklog
## Testbed
- postgresql: 10.23-4.pgdg22.04+1 --> 15.8
```
Name                          Version             Architecture
zabbix-server-pgsql           1:6.0.6-1+ubuntu18. amd64
zabbix-agent                  1:6.0.6-1+ubuntu18. amd64
zabbix-frontend-php           1:6.0.6-1+ubuntu18. all

postgresql-10                 10.23-0ubuntu0.18.0 amd64
```

## Need further investigation



# acknowledgment
## Contributors

APA 🖖🏻

## Links

```                                                                                
  aaaaaaaaaaaaa  ppppp   ppppppppp     aaaaaaaaaaaaa   
  a::::::::::::a p::::ppp:::::::::p    a::::::::::::a  
  aaaaaaaaa:::::ap:::::::::::::::::p   aaaaaaaaa:::::a 
           a::::app::::::ppppp::::::p           a::::a 
    aaaaaaa:::::a p:::::p     p:::::p    aaaaaaa:::::a 
  aa::::::::::::a p:::::p     p:::::p  aa::::::::::::a 
 a::::aaaa::::::a p:::::p     p:::::p a::::aaaa::::::a 
a::::a    a:::::a p:::::p    p::::::pa::::a    a:::::a 
a::::a    a:::::a p:::::ppppp:::::::pa::::a    a:::::a 
a:::::aaaa::::::a p::::::::::::::::p a:::::aaaa::::::a 
 a::::::::::aa:::ap::::::::::::::pp   a::::::::::aa:::a
  aaaaaaaaaa  aaaap::::::pppppppp      aaaaaaaaaa  aaaa
                  p:::::p                              
                  p:::::p                              
                 p:::::::p                             
                 p:::::::p                             
                 p:::::::p                             
                 ppppppppp                                                        
```