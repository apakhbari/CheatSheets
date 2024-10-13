# Zabbix monitor postgresql

```
 _______  _______  _______  _______  ___   __   __ 
|       ||   _   ||  _    ||  _    ||   | |  |_|  |
|____   ||  |_|  || |_|   || |_|   ||   | |       |
 ____|  ||       ||       ||       ||   | |       |
| ______||       ||  _   | |  _   | |   |  |     | 
| |_____ |   _   || |_|   || |_|   ||   | |   _   |
|_______||__| |__||_______||_______||___| |__| |__|
```

## PostgreSQL Database Monitoring
### Add PostgreSQL Read-Only User

```
sudo -u postgres psql
```
- or on docker:
```
docker exec -it 784097dd8e69 bin/bash
root@784097dd8e69:/# psql -h postgresql -U zabbix -d zabbix_db
```

- Add the user.
```
CREATE USER zbx_monitor WITH PASSWORD '<PASSWORD>' INHERIT;
GRANT pg_monitor TO zbx_monitor;
```

- Confirm user exists
```
select * from pg_catalog.pg_user;
```

thisisforapatest

### Set Up Zabbix PostgreSQL Template Dependencies
- Now to download the Zabbix repository from GitHub. This contains the PostgreSQL database queries used by the template that we will import into Zabbix.
```
git clone https://github.com/zabbix/zabbix.git --depth 1
```
- We now need to copy the ./zabbix/templates/db/postgresql/ folder and contents to the /var/lib/zabbix/ folder.
```
mkdir /var/lib/zabbix
cp -r ./zabbix/templates/db/postgresql/. /var/lib/zabbix/
cd /var/lib/zabbix
ls
```

- We also need to copy just the template_db_postgresql.conf file to /etc/zabbix/zabbix_agentd.d/
```
cp /var/lib/zabbix/template_db_postgresql.conf /etc/zabbix/zabbix_agentd.d/
cd /etc/zabbix/zabbix_agentd.d/
ls
```

### Configure PostgreSQL ```pg_hba.conf``` File
- Now we need to edit the ```pg_hba.conf``` to allow the zbx_monitor user to connect.
```- sudo nano /etc/postgresql/14/main/pg_hba.conf```

- Add these lines to the end
```
host all zbx_monitor 127.0.0.1/32 trust
host all zbx_monitor 0.0.0.0/0 md5
host all zbx_monitor ::0/0 md5

host    all     zbx_monitor             127.0.0.1/32                 trust
host    all     zbx_monitor             0.0.0.0/0                 md5
host    all     zbx_monitor             ::0/0                 md5
```

### Configure Host and Template in Zabbix
- Restart Zabbix Agent and check status.
```
sudo service zabbix-agent restart
sudo service zabbix-agent status
```

- Go into Zabbix and create a new host named 'postgresql'.
- Assign the template PostgeSQL by Zabbix agent.
- Add to any group you desire. Templates/Databases is a good option.
- Add an Agent interface, and set the IP address of your PostgreSQL server.
- Select the Macros tab and check/set each macro key. (Most keys will be already set to the correct value)

|    Macro key   |                                Value                                |
|:--------------:|:-------------------------------------------------------------------:|
|   {$PG.HOST}   |                              127.0.0.1                              |
| {$PG.PORT}     | 5432                                                                |
| {$PG.USER}     | zbx_monitor                                                         |
| {$PG.PASSWORD} | the same password you used above when creating zbx_monitor the user |
|    {$PG.DB}    |                               postgres                              |

- Press Update and after some time, you will see new values populating in Monitoring → Latest Data

regarding of zabbix stack wholely setup on  docker containers, i have problems monitoring postgresql container of zabbix [Status: PROBLEM - Host: zabbix-postgresql - Problem: Service is down] & docker socket of server [Status: PROBLEM - Host: docker-socket - Problem: Service is down]. I am using a zabbix-agent2 container on port 10050 and all of these services are on 1 server. What went wrong and how to fix it? Give me a thourough step-by-step instruction
This is my docker-compose.yml file:

write a command for me that using iptables, inside INPUT Chain drops all packets on port 443 except the ones that are coming from IP Address 100.200.300.400

# acknowledgment
## Contributors

APA 🖖🏻

## Links
- Docker Container Monitoring With Zabbix : https://blog.zabbix.com/docker-container-monitoring-with-zabbix/20175/
- [Youtube] Monitor Docker Containers with Zabbix - Easy Setup and Configuration Guide : https://www.youtube.com/watch?v=QNdsWp_X9-c

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