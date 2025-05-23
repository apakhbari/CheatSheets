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

Use this for RAM + CPU Restrictions:
```
sudo prlimit --cpu=50 --as=2G -- cp -r /example_directory /backup/
```

1. Backup Zabbix Configuration Files:
```
sudo cp -r /etc/zabbix /backup/zabbix_config_$(date +%F)
```

1-1. For PHP files and Zabbix binaries, run:

```
sudo cp -R /usr/share/zabbix/ /backup/zabbix_share_$(date +%F)
```

2. Backup Zabbix PostgreSQL Database: Use pg_dump to create a backup of the PostgreSQL database:
```
sudo -u postgres pg_dump -v zabbix > /backup/zabbix_backup_$(date +%F).sql
```

3. Test Restore of Backup: Test your backup by restoring it to a non-production environment:
```
sudo -u postgres psql zabbix < /backup/zabbix_backup.sql
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


## Step 3: Migrate Zabbix Server to Docker and Upgrade

1. Initialize Docker Volumes: Create the necessary volumes for Zabbix data and PostgreSQL data persistence:
```
sudo mkdir -p ./vol_docker/zabbix-server/data
sudo mkdir -p ./vol_docker/zabbix-server/config
sudo mkdir -p ./vol_docker/zabbix-server/share

sudo mkdir -p ./vol_docker/zabbix-web/data
sudo mkdir -p ./vol_docker/zabbix-web/config

sudo mkdir -p ./vol_docker/postgres/data
```
2. Copy directories to their related vol_docker
- zabbix-web:
```
sudo cp -r /usr/share/zabbix/* ./vol_docker/zabbix-web/data/
sudo cp -r /etc/zabbix/web/* ./vol_docker/zabbix-web/config/
```

- zabbix-server:
```
sudo cp -r /var/lib/zabbix/* ./vol_docker/zabbix-server/data/
sudo cp -r /etc/zabbix/* ./vol_docker/zabbix-server/config/
sudo cp -r /usr/share/zabbix/* ./vol_docker/zabbix-server/share/
```

3. Give proper Permissions
```
find ./vol_docker -type d -exec chmod 755 {} \;
find ./vol_docker -type f -exec chmod 644 {} \;

sudo chown zabbix:zabbix -R ./vol_docker
```

3. Restore the PostgreSQL Backup into Docker: Start the PostgreSQL container:
```
docker-compose up -d postgresql
```

- Then, restore the database backup:
```
cat /backup/zabbix_backup.sql | docker exec -i $(docker ps -q -f "name=pgsql") psql -U zabbix -d zabbix
```

- Check things work
```
docker exec -it pgsql bin/bash
psql -h localhost -p 5432 -U zabbix -d zabbix
zabbix=# \l
```

4. Start Zabbix Server: Bring up the entire Zabbix environment:
```
docker-compose up -d
```

5. See all logs
```
docker compose logs -f
```

6. Verify Zabbix Server:
```
docker ps
```

- Verify connectivity via the Zabbix frontend.


## Step 4: Monitor the New Setup

1. Check Logs: Regularly check the logs of both Zabbix and PostgreSQL containers to ensure there are no errors:
```
docker logs zabbix-server
docker logs zabbix-proxy
```

2. Check Zabbix Health: Log into the Zabbix frontend and ensure that all hosts, proxies, and data are being correctly monitored.

3. Test Zabbix Alerts: Trigger some test alerts to verify that notifications are working as expected.

## Step 5: Clean Up and Decommission Old Services
1. Stop Old Services: Once you have verified the new Docker-based setup is working fine, stop the old unit services:
```
sudo systemctl disable zabbix-server
sudo systemctl disable postgresql
```

2. Remove Old Installations (optional): You can remove the old Zabbix server and PostgreSQL installations if no rollback is needed.
```
sudo apt remove zabbix-server postgresql
```


## Step 6: Clear web browser cookies and cache
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
