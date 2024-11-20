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
- Sessions
- Theoretical
  - Introduction
  - Components
  - Files & directories
  - Tips & Tricks
- Hands On
- acknowledgment
  - Contributors
  - Links

# Session 1
- Monitoring consists of: Data collection - Problem detection - alerting
- Monitoring vs log collection : Log collection is mostly data collection only
- MTTR: mean time to recover
- MTTF: Mean time to failures
- MTBF: Mean time between failures
- Availabilty = (MTTF/MTTR)*100

# Session 2

# Session 3
- Zabbix DB consists of two sets of Tables in DB: History and Trend
- History: cconsisted of 5 tables, save exact data 
- Trend:

- Active Zabbix Proxy: sends data automatically to server. Better for complex situations where server can't see proxy due to firewalls. If your Network is open, this option is better 
- Passive Zabbix Proxy: Server have to request proxy to send data in response. Better for complex situations where proxy can't see server due to firewalls


- BSS : Business support system: CRM - Recommendation system - Billing
- OSS: Operation support system: 

# Session 4
- Zabbix agent developed using C
- Zabbix agent 2 developed using Go
- In any given zabbix stack, there is only one active zabbix server
- Metric collection categorization:
1. whether it is white box or black box: in black box you have a generally limited access to metrics but in white box you have detailed information inside system
2- whether it is pushing (active/trapping/event based) or pulling (passive): in pulling monitoring server requests to desired server to get its metrics, in pushing monitoring server does not requests to desired server and desired server send its metrics to monitoring server
- in monitoring log files, you need to use zabbix agnet in active mode, since it is evet-based 
- Zabbix features:
1. Metric Collection:
- Custom zabbix monitoring:
1. 
2. 


---

# Theoretical

## Components

## Files & directories

## Tips & Tricks

## Commands

# Hands On


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