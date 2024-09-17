```
 _______  _______  _______  _______  _______  ______    _______  _______  _______  ___     
|       ||       ||       ||       ||       ||    _ |  |       ||       ||       ||   |    
|    _  ||   _   ||  _____||_     _||    ___||   | ||  |    ___||  _____||   _   ||   |    
|   |_| ||  | |  || |_____   |   |  |   | __ |   |_||_ |   |___ | |_____ |  | |  ||   |    
|    ___||  |_|  ||_____  |  |   |  |   ||  ||    __  ||    ___||_____  ||  |_|  ||   |___ 
|   |    |       | _____| |  |   |  |   |_| ||   |  | ||   |___  _____| ||      | |       |
|___|    |_______||_______|  |___|  |_______||___|  |_||_______||_______||____||_||_______|
```
# Commands

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

## List & View
\l - Display database
\c - Connect to database
\dn - List schemas
\dt - List tables inside public schemas
\dt schema1.* - List tables inside a particular schema. For example: 'schema1'.

## Change Password
```
ALTER USER user_name WITH PASSWORD 'new_password';
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