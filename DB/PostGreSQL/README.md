# PostgreSQL

```
 _______  _______  _______  _______  _______  ______    _______  _______  _______  ___     
|       ||       ||       ||       ||       ||    _ |  |       ||       ||       ||   |    
|    _  ||   _   ||  _____||_     _||    ___||   | ||  |    ___||  _____||   _   ||   |    
|   |_| ||  | |  || |_____   |   |  |   | __ |   |_||_ |   |___ | |_____ |  | |  ||   |    
|    ___||  |_|  ||_____  |  |   |  |   ||  ||    __  ||    ___||_____  ||  |_|  ||   |___ 
|   |    |       | _____| |  |   |  |   |_| ||   |  | ||   |___  _____| ||      | |       |
|___|    |_______||_______|  |___|  |_______||___|  |_||_______||_______||____||_||_______|
```
# Connection String
```
$ psql -h <REMOTE HOST> -p <REMOTE PORT> -U <DB_USER> <DB_NAME>
```

# Commands

## List & View
```
\l - Display database
\c - Connect to database
\dn - List schemas
\dt - List tables inside public schemas
\dt schema1.* - List tables inside a particular schema. For example: 'schema1'.
```

## See Version
### Server version:
```
=> SELECT version();
                                                   version                                                    
--------------------------------------------------------------------------------------------------------------
 PostgreSQL 9.2.9 on x86_64-unknown-linux-gnu, compiled by gcc (GCC) 4.4.7 20120313 (Red Hat 4.4.7-4), 64-bit

=> SHOW server_version;
 server_version 
----------------
 9.2.9

=> SHOW server_version_num;
 server_version_num 
--------------------
 90209
 ```
- If more curious, try => ``` SHOW all; ```.

### Client version
```
=> \! psql -V
psql (PostgreSQL) 9.2.9
```


## Change Password
```
ALTER USER user_name WITH PASSWORD 'new_password';
```

# Dockerized
- Run the PostgreSQL Docker Container:
```
$ docker run \
  --name pgsql-dev \
  -e POSTGRES_PASSWORD=test1234 \
  -d \
  -v ${PWD}/postgres-docker:/var/lib/postgresql/data \
  -p 5432:5432 postgres 
```

- This command lets you connect to the PostgreSQL CLI running inside the Docker container:
```
$ docker exec -it pgsql-dev bash
root@6b7f283ad618:/#
```

- connect to the PostgreSQL instance
```
$ psql -h localhost -U postgres
```

# Enabling SSL/TLS encryption
- You can achieve this by providing the necessary SSL certificates and modifying the ```postgresql.conf``` file to enforce SSL connections.

# Backup Process
- Backup your data periodically. You can do this by running the ```pg_dump``` command:
```
pg_dump -U<user_name> --column-inserts --data-only <db_name> > \
  backup_data.sql
```

# Cases
## Giving Zabbix permissions
```
GRANT CONNECT ON DATABASE zabbix_proxy TO zabbix;
GRANT USAGE ON SCHEMA public TO zabbix;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO zabbix;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO zabbix;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO zabbix;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO zabbix;
```

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