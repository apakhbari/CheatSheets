# Zabbix

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

# Theoretical
## Introduction
- Zabbix is an enterprise-class open source distributed monitoring solution.

## Components


## Files & directories


## Starting Up
- Zabbix server mysql
```
$ docker run -d --name mysql-server --restart=always
-p 10050:10050
-p 10051:10051
-v /srv/Docker/MySQL:/var/lib/mysql
-e DB_SERVER_HOST="mysql-world"
-e MYSQL_USER="zabbixworld"
-e MYSQL_DATABASE="zabbixworld"
-e MYSQL_PASSWORD=""
zabbix/zabbix-server-mysql
--character-set-server=utf8mb4
--collation-server=utf8mb4_unicode_ci --default-authentication-plugin=mysql_native_password
```

- Zabbix web apache mysql
```
$ docker run -d --name zabbix-web-apache-mysql --restart=always
-p 80:80
-p 8080:8080
-p 443:443
-e DB_SERVER_HOST="172.17.0.5"
-e MYSQL_USER="root"
-e MYSQL_PASSWORD="test"
-e ZBX_SERVER_HOST="172.17.0.6"
-e PHP_TZ="Europe/Riga"     // THIS ONE IS FOR TIMEZONE
zabbix/zabbix-web-apache-mysql
```


## Commands

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