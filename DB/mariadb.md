```
 __   __  _______  ______    ___   _______  ______   _______ 
|  |_|  ||   _   ||    _ |  |   | |   _   ||      | |  _    |
|       ||  |_|  ||   | ||  |   | |  |_|  ||  _    || |_|   |
|       ||       ||   |_||_ |   | |       || | |   ||       |
|       ||       ||    __  ||   | |       || |_|   ||  _   | 
| ||_|| ||   _   ||   |  | ||   | |   _   ||       || |_|   |
|_|   |_||__| |__||___|  |_||___| |__| |__||______| |_______|
```

# Commands
## List & View

```
$ SHOW DATABASES;
```

```
$ USE DB;
```

```
$ SHOW FULL TABLES;
```

## Change Password
```
ALTER USER 'username'@'host' IDENTIFIED BY 'newpassword';
```


## Zabbix monitoring permissions + Galera

```
$ CREATE USER 'zabbix'@'%' IDENTIFIED BY '<password>';

$ GRANT REPLICATION CLIENT, PROCESS, SHOW DATABASES, SHOW VIEW ON *.* TO 'zabbix'@'%';
$ GRANT SELECT ON performance_schema.* TO 'zabbix'@'%';
$ GRANT SELECT ON information_schema.* TO 'zabbix'@'%';
```

# Tips & Tricks
- To select last 5 minutes data: ``` > Select date_add(now(), interval - 5 minute) ; ```

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