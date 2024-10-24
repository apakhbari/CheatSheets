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

# What i want to do
- Zabbix server (Version 6): Currently on linux unit service, migrate from unit service to docker image, upgrade to version 7
- Zabbix server postgresql DB (Version 10): Currently on linux unit service, Backup, migrate from unit service to docker image, upgrade to version 15
- Zabbix proxy (Version 5): Currently on linux unit service, upgrade to version 7
- Zabbix proxy postgresql DB (Version 10): Currently on linux unit service, Backup, migrate from unit service to docker image, upgrade to version 15

# How to do it
## Prerequisites

- Backup Strategy: Ensure you have reliable backups of both your Zabbix configurations and PostgreSQL databases.
- Docker Setup: Ensure Docker and Docker Compose are installed and properly configured on your production servers.
- Storage Configuration: Prepare for Docker volumes to persist your Zabbix data and PostgreSQL data.

> Consider running two parallel SSH sessions during the upgrade: one for executing the upgrade steps and another for monitoring server/proxy logs. For example, run tail -f zabbix_server.log or tail -f zabbix_proxy.log in the second session to view the latest log entries and possible errors in real time. This can be critical for production instances.


## Step 1: Backup Zabbix Server and PostgreSQL Database

1. Backup Zabbix Configuration Files:
```
sudo cp -r /etc/zabbix /backup/zabbix_config_$(date +%F)
```

1-1. For PHP files and Zabbix binaries, run:

```
sudo cp -R /usr/share/zabbix/ /backup/zabbix-backup/
sudo cp -R /usr/share/zabbix-* /backup/zabbix-backup/
```

2. Backup Zabbix PostgreSQL Database: Use pg_dump to create a backup of the PostgreSQL database:
```
sudo -u postgres pg_dump zabbix_db > /backup/zabbix_db_backup_$(date +%F).sql
```

3. Test Restore of Backup: Test your backup by restoring it to a non-production environment:
```
sudo -u postgres psql zabbix_db_test < /backup/zabbix_db_backup.sql
```

## Step 2: Prepare for Migration to Docker

1. Pull Docker Images for Zabbix and PostgreSQL:
```
docker pull zabbix/zabbix-server-pgsql:latest
docker pull postgres:15
```

2. Stop Services: Before migration, gracefully stop your Zabbix server and database services:
```
sudo systemctl stop zabbix-server
sudo systemctl stop postgresql
```

## Step 3: Migrate Zabbix Proxy and PostgreSQL Database

1. Backup Zabbix Proxy PostgreSQL Database: Similar to the Zabbix server, back up the proxy database:

```
sudo -u postgres pg_dump zabbix_proxy_db > /backup/zabbix_proxy_db_backup_$(date +%F).sql
```

2. Create Docker Compose File for Zabbix Proxy: Create a docker-compose.yml for the Zabbix proxy:


3. Initialize Docker Volumes for Proxy:
```
mkdir -p /docker/zabbix_proxy/zabbix_proxy_data
mkdir -p /docker/zabbix_proxy/pgsql_proxy_data
```

4. Restore Proxy PostgreSQL Backup: Start the PostgreSQL proxy container and restore the backup:
```
docker-compose up -d postgresql
cat /backup/zabbix_proxy_db_backup.sql | docker exec -i $(docker ps -q -f "name=postgresql") psql -U zabbix_proxy -d zabbix_proxy_db
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