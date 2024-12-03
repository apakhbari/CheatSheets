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
2. whether it is pushing (active/trapping/event based) or pulling (passive): in pulling monitoring server requests to desired server to get its metrics, in pushing monitoring server does not requests to desired server and desired server send its metrics to monitoring server. Usually in active monitoring hostname must be unique.
- in monitoring log files, you need to use zabbix agnet in active mode, since it is evet-based 
- Zabbix features:
1. Metric Collection:
- Custom zabbix Metric Collection:
1. Zabbix Trapper: Script is on host, whenever/however it executed the response is be sent to zabbix server 
2. External Check: Script is on zabbix server/proxy, whenever/however it need to be executed is uppon zabbix server/proxy 
3. Script: Is using Java script, it is on zabbix server/proxy whenever/however it need to be executed is uppon zabbix server/proxy

- Monitored numeric data has differnet forms:
1. Cummulative: like age, machine kilometer, number of all services from firs day --> this metric won't reduce it is whether constant or adds up. Each time you monitor this it is related to last time. It is not good for operation monitoring so we derivative/Slope (مشتق/شیب خط) it
2. Gauge: current speed of car, Memory usage -- > Each time you monitor this it is not related to last time

- Monitoring is usually based on time-series, meaning that it can be mapped into a x-y axis with x axis being time and y axis being value of metric

# Session 5
- Discovery has two methods:
1. bottom up: Monitoring server does not need to know things about its components since components introduce themselves. In low level discovery (LLD) you can fine tune what needs to be monitored where as in top down approach there is a template that applies for all hosts
2. top down: You need to be sure about your network, in zabbix only works for active agent (for example snmp does not work on it)

- Monitoring requierments:
1- HLD --> High Level Design
2- LLD --> Low Level Design
3- Process Flow (Sequence Diagram)
4- KPI

- Rules can be applied on Auto registration/discovery in zabbix
- Host groups and User groups are being used for permissions
- For categorizing you can use tags

# Session 6
- By regulatory definition, Network Throughput is divides by (/) 1000 for getting Kb, Mb, etc but Disk space is divides by (/) 1024 for getting Kb, Mb, etc
- in Units of zabbix, B (for bite) divides by 1024 for human readability and b (for bitee) divides by 1000 for human readability

#### In Item definition section
- Update interval is maximum 24 h
- Update interval 0 means do not monitor
- Monitoring using custom intervals Type Flxible (8 records in sum):
  - set Update interval to 0
  - [Add 2 custom interval record with type Flexible] for saturday to wednesday would be monitoring with 1m time interval: 1-3,08:00-17:59 + 6-7,08:00-17:59
  - [Add 2 custom interval record with type Flexible] other times of weekday we monitor with 3m time interval: 1-3,18:00-23:59 + 6-7,18:00-23:59 + 1-3,00:00-08:00 + 6-7,00:00-08:00
  - [Add custom interval record with type Flexible] on thursday we monitor 5m time interval: 4-4,00:00-23:59
  - [Add custom interval record with type Flexible] on friday we monitor 10m time interval: 5-5,00:00-23:59

- Custom intervals Scheduling:
``` m<filter>wd<filter>h<filter>m<filter>s<filter> ```

``` filter: [<from>[-<to>]][/<step>][,<filter>] ```

``` md = month day [1-31] , wd = weekday [1-7] , h = hour [0-59] , s = second [0-59] ```


- when before value is omitted it means full range, when after value is omitted it means 0 by default
- minute 15 second 30 of each hour: m15s30
- m5 --> m5s0 minute 5 of each hour, second 0
- h2 --> h2m0s0 every day at 2:00:00 am
- m/5 --> m/5s0 every five minutes at 00 second, for example 5 10 15 20 ...
- h/2m/3 --> 02:03 02:06 02:09 ... + 04:03 04:06 04:09 ... + 06:03 06:06 06:09 ... 
- h0,6,12,18 = h/6 = h/6m0s0
- h8-18,22 --> from 08:00 to 18:00 plus 22:00
- md15wd3h/1m/1 --> if 15-th day of month was equal to third day of week, then do this every 1 minute
- h15-18m30

m3,7,11,15,19,23,27,31,35,...  something abbreviated like m/4
h12-18s30 what is going to be minutes? say some times its executes
- create two other icmp and then trigger it


in zabbix mysql DB:
```
$ show tables like "history%";

history --> table for float data
history_bin
history_log
history_str
history_text
history_uint --> table for unsigned integer

$ show tables like "trends%";

trends
trends_uint
```

- by default history is being kept 31 days and trends is 365 days

# Session 7
- Since UDP is connection-less, you can't monitor it, only NTP has the ability to be monitored from UDP services
- net.tcp.service.perf --> returns response time and good for performance monitoring
- In items for monitoring TCP connection you can use: ITEM > Type: Simple Check > net.tcp.service . You can monitor these services using this:
  - 

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