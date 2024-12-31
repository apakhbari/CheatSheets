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
- OSS: Operation support system: Monitoring - Ticketing system

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
## Items
### Create TCP Simple Check (TYPE: Simple Check):
- Since UDP is connection-less, you can't monitor it, only NTP has the ability to be monitored from UDP services
- net.tcp.service.perf --> returns response time and good for performance monitoring
- In items for monitoring TCP connection (net.tcp.service) you can use: ITEM > Type: Simple Check > net.tcp.service . You can monitor these services using this:
  - ftp
  - http
  - https
  - imap
  - ldap
  - nntp
  - pop
  - smtp
  - ssh
  - tcp
  - telnet
  - ntp

- SSH Port Status
```
Data collection-> Hosts -> Items -> create item:
  Name: TCP: SSH Status
  Type: Simple Check
  Key: net.tcp.service[ssh]
```

- MariaDB Port Status
```     
Data collection-> Hosts -> Items -> create item:
  Name: TCP: MariaDB Status
  Type: Simple Check
  Key: net.tcp.service[tcp,,3306]
```     
    
- On Zabbix Server for giving permissions (SELinux):
```
$ grep zabbix_t /var/log/audit/audit.log | audit2allow -M zabbix-server
$ semodule -i zabbix-server.pp
```

### SSH Agent (TYPE: SSH Agent)
- needs permissions and is somehow a whitebox monitoring
- A quick trick to return whether a service is up or no and return 0/1:
```
$ systemctl is-active mariadb | grep ^a -c
```

- On Zabbix Server:
```
$ getent passwd zabbix
$ ls -ld /var/lib/zabbix
$ mkdir /var/lib/zabbix
$ chown zabbix: /var/lib/zabbix/
$ chmod 700 /var/lib/zabbix/
        
$ sudo -u zabbix ssh-keygen
$ sudo -u zabbix ssh-copy-id -n zabbix_ssh@192.168.0.101
    
* copy the public key
```
    
- On Target server:
```
$ useradd zabbix_ssh
$ passwd zabbix_ssh
$ mkdir /home/zabbix_ssh/.ssh/

$ vim .ssh/authorized_keys

* paste the public Key

$ chmod 700 .ssh/authorized_keys
```
   
- On Zabbix Server:
```
$ sudo -u zabbix ssh "zabbix_ssh"@192.168.0.101 hostname
```

- On Zabbix Server:
```
$ vim /etc/zabbix/zabbix_server.conf:
  Line 632: SSHKeyLocation=/var/lib/zabbix/.ssh/

$ systemctl restart zabbix-server.service
        
$ grep zabbix_t /var/log/audit/audit.log | audit2allow -M zabbix_server_custom
        
$ semodule -i zabbix_server_custom.pp
```

- on ZABBIx UI:
```     
Data collection-> Hosts -> Items -> create item     
  Name: MariaDB: Service Status (By SSH)
  Type: SSH Agent
  Key: ssh.run[MariaDB.status]
  Authentication Method: Public key
  user name: zabbix_ssh
  Public key file: id_rsa.pub
  Private key file: id_rsa
  Script: systemctl is-active mariadb.service | grep -c ^a
  app: MariaDB
```
- On Zabbix Server:
```
$ grep zabbix_t /var/log/audit/audit.log | audit2allow -M zabbix_server_custom
$ semodule -i zabbix_server_custom.pp
```

- Ping Script:
```
$ ping -c 1 8.8.8.8 | tail -n1 | cut -d "=" -f2 | cut -d "/" -f2
```
### Zabbix Agent (TYPE: Agent)
- whether in proxy gruop or servers for monitoring, ";" means and. for example:
  - ServerActive=192.168.1.100;192.168.1.150,192.168.1.200 --> whether send data to 192.168.1.100 or 192.168.1.150 (if first one failed, try second one. / These two servers are clustered) but always send data to 192.168.1.200

- For active checks and zabbix wrapper, name of hostname in UI must be exactly name of agen hostname in zabbix-agent.conf

- Installin Zabbix Agent 2 on Target Server:
```
$ vim /etc/yum.repos.d/epel.repo
line 11=> excludepkgs=zabbix*

$ rpm -Uvh https://repo.zabbix.com/zabbix/7.0/rocky/9/x86_64/zabbix-release-latest.el9.noarch.rpm
$ dnf install zabbix-agent2 zabbix-agent2-plugin-*
```
- configs
``` 
$ vim /etc/zabbix/zabbix_agent2.conf

Line 80=> Server=[zabbix server or proxy address]
Line 133=> ServerActive=[zabbix server or proxy address]
Line 144 => Hostname=LTEH-R04U10-1234
       
$ systemctl enable --now zabbix-agent2.service
$ systemctl status zabbix-agent2.service
    
$ ss -lntp | grep zabbix
$ lsof -Panp [zabbix agent pid] -iTCP -sTCP:LISTEN
    
$ firewall-cmd --add-service=zabbix-agent --permanent
$ firewall-cmd --reload
```

- Testing zabbix agent connection:
```
on zabbix server:

$ telnet 192.168.1.101 10050
$ dnf install zabbix-get

$ zabbix_get -k agent.ping -s 192.168.1.101
$ zabbix_get -k agent.hostname -s 192.168.1.101
$ zabbix_get -k agent.version -s 192.168.1.101 --> 7.0.6
$ zabbix_get -k agent.variant -s 192.168.1.101 --> agent 1 or 2
$ zabbix_get -k system.uptime -s 192.168.1.101
$ zabbix_get -k vfs.dir.count[/home] -s 192.168.1.101
$ zabbix_get -k vfs.dir.get[/home] -s 192.168.1.101
$ zabbix_get -k vfs.dir.get[/home] -s 192.168.1.101 | jq
$ zabbix_get -k vfs.dir.get[/home] -s 192.168.1.101 | jq .[].user
$ zabbix_get -k system.sw.os -s 192.168.1.101
$ zabbix_get -k system.sw.os[full] -s 192.168.1.101
$ zabbix_get -k system.sw.os[short] -s 192.168.1.101
$ zabbix_get -k system.sw.os[name] -s 192.168.1.101
$ zabbix_get -k vfs.file.contents[/etc/system-release] -s 192.168.1.101
$ zabbix_get -k system.sw.os[name] -s 192.168.1.101 
$ zabbix_get -k vfs.file.owner[/etc/system-release] -s 192.168.1.101
$ zabbix_get -k vfs.file.size[/etc/system-release] -s 192.168.1.101 
$ zabbix_get -k system.sw.packages[MariaDB-server] -s 192.168.1.101
$ zabbix_get -k system.sw.packages['MariaDB-server-\d',,short] -s 192.168.1.101
```

# Session 8
- Scenario: Giving permission for custom zabbix-agent check and then running 
```
ZABBIX Agent:
  On Zabbix UI:
    Configuration->Hosts->items-> Create Item:
    name: Check Zabbix agent connectivity
    Key: agent.ping
    Show Value Zabbix agent ping status
    Application: ZABBIX Agent
    
On Zabbix Server:
  # zabbix_server -R config_cache_reload

On Target Server:
  # vim /etc/zabbix/zabbix_agent2.conf
    line 418: AllowKey=system.run[systemctl is-*]
  # systemctl restart zabbix-agent2.service
           
On Zabbix UI:
  Configuration->Hosts->items-> Create Item:
  name: MariaDB Service Running Status (via Agent - Using System Run)
  Key: system.run["systemctl is-active mariadb | grep -c ^a"]
  Application: MariaDB
```

- A simple cool trick for generalizing UserParameter
```
On Target Server:
  $ UserParameter=service.status[*],systemctl is-$2 $1 | grep -c ^$2
  $ zabbix_agent2 -R userparameter_reload

On zabbix UI:
  Configuration->Hosts->items-> Create Item:
  name: MariaDB Service Status (By UserParameter)
  Key: service.status[mariadb,active]
  Application: MariaDB
```

- For monitoring MariaDB service status you have multiple choices:

| **MariaDB Service Status** | **Key**                                        |
|:--------------------------:|:----------------------------------------------:|
|          Agent2           |    systemd.unit.info[mariadb.service,ActiveState]    |
|          By SSH           |               ssh.run[MariaDB.status]         |
|        System Run         |                system.run[mariadb]            |
|        UserParameter      |               service.status[mariadb,enabled] |

- When Item > key is really long, define an aliase for it

### SNMP
- Simple Network Management Protocol
- SNMP is also uasble for setting data on hosts
- OID: Object IDentifier, has a tree-based attribute. For example:
- 1.2.3.4.5.6.7 => FileSystem-total (1.2.3.4.5.6.7 is OID)
  - 1.2.3.4.5.6.7.1 => 1 is index
  - 1.2.3.4.5.6.7.2 => 2 is index
  - 1.2.3.4.5.6.7.3 => 3 is index

- There are MIB Files, a library, which is related to what these OIDs are. Not all of OIDs are part of this library thogh. These library acts as a human-readablity translator.

- There is an enterprise OID which then assign each branch to different places so they can monitor their own parameters, For example:
- .1.2.3.9 => enterprise
  - .1.2.3.9.1 => cisco
  - .1.2.3.9.2 => microsoft
  - .1.2.3.9.3 => linux
  - .1.2.3.9.4 => IBM
  - ...

- MIB file translate like this: 1.2.3.4.5.8.1 --> system::filesystem-total.1
- If we want human-readable names for SNMP, we need to have its related names on zabbix
- These SNMP codes are hard-coded on all machines

- SNMP has Different Versions:
  - Version 1 => Plain, Clear, without Authentication
  - Version 2 (2c) => Plain, Community Auth
  - Version 3 => Encrypted + Community Auth

- SNMP Port Number: 161/udp

- SNMP DES encryption is not secure and does not work with new OSs

- Some SNMP commands
```
$ snmptranslate -On SNMPV2-MIB::sysName.0
.1.3.6.1.2.1.1.5.0

$ snmpwalk -v2x -c public 127.0.0.1 SNMPv2-MIB::sysName.0
SNMPv2-MIB::sysName.0 = STRING: target-server

$ snmpwalk -v2x -c public 127.0.0.1 .1.3.6.1.2.1.1.5.0
SNMPv2-MIB::sysName.0 = STRING: target-server
```

```
SNMP Monitoring:
    https://mibbrowser.online/mibdb_search.php
    On Target Server:
        # dnf install net-snmp net-snmp-utils
        # vim /etc/snmp/snmpd.conf
          line 41=> com2sec notConfigUser default zabbix-snmp
          line 57 add => view systemview included .1.3.6.1

        # systemctl enable --now snmpd

        # firewall-cmd --add-port=161/udp --permanent
        # firewall-cmd --reload

        # snmpwalk -v 2c -c zabbix-snmp 127.0.0.1

    On Zabbix server:
        # dnf install net-snmp-utils
        # snmpwalk -v 2c -c zabbix-snmp 192.168.1.1
    On zabbix Server:
        
        # dnf install net-snmp-utils
        
        # snmpwalk -v 2c -c zabbix-snmp -O n 192.168.1.101
```


```

====================================

ZABBIX Agent:
    On Zabbix UI:
        Configuration->Hosts->items-> Create Item:
         name: Check Zabbix agent connectivity
         Key: agent.ping
         Show Value Zabbix agent ping status
         Application: ZABBIX Agent
    
    On Zabbix Server:
        # zabbix_server -R config_cache_reload
-------------------------------------------------------- 
    On Target Server:
        # vim /etc/zabbix/zabbix_agent2.conf
                line 418: 
                AllowKey=system.run[systemctl is-*]
        # systemctl restart zabbix-agent2.service
           
    On Zabbix UI:
        Configuration->Hosts->items-> Create Item:
         name: MariaDB Service Running Status (via Agent - Using System Run)
         Key: system.run["systemctl is-active mariadb | grep -c ^a"]
         Application: MariaDB
    
---------------------------------------------------    
    On Target Server:
        
        # vim /etc/zabbix/zabbix_agentd2.d/mariadb_agent.conf:
                UserParameter=mariadb.status,systemctl is-active mariadb | grep -c ^a

        # systemctl restart zabbix-agent2.service
       
    On Zabbix UI:
        Configuration->Hosts->items-> Create Item:
         name: MariaDB Service Running Status (via Agent - Using UserParameter)
         Key: mariadb.status
         Application: MariaDB      
    
===============================
# egrep -v "^(#|$)" /etc/zabbix/zabbix_agent2.conf 

PidFile=/var/run/zabbix/zabbix_agent2.pid
LogFile=/var/log/zabbix/zabbix_agent2.log
LogFileSize=50
Server=192.168.1.150
ServerActive=192.168.1.150
Hostname=anisa-mariadb-01-thdc
BufferSend=300
BufferSize=1000
Alias=system.run.mariadb:system.run["systemctl is-active mariadb | grep -c ^active"]
Include=/etc/zabbix/zabbix_agent2.d/*.conf
ControlSocket=/tmp/agent.sock
AllowKey=system.run[systemctl is-*]

 ----------------------------------------------------   
On Target Server:
        # vim /etc/zabbix/zabbix_agentd2.d/mariadb_agent.conf:
         UserParameter=mariadb.version,rpm -qa | grep -i mariadb-server
               
        # systemctl restart zabbix-agent2.service
            
    On Zabbix UI:
        Configuration->Hosts->Items->Create item:
         Name: MariaDB Version
         Type: zabbix agent
         Key: mariadb.version
         type of information: Character
         History storage period: Do not Keep ...
         Application: MariaDB
         Populates host inventory field= Software Application A
         
         
         # zabbix_server -R config_cache_reload

----------------------------------------------------------                         
                
    On Zabbix UI:
        Configuration->Hosts->Items->Create item:
         Name: MariaDB Version (Using built-in keys)
         Type: zabbix agent
         Key: system.sw.packages[MariaDB-server,,short]
         type of information: Character
         History storage period: Do not Keep ...
         Application: MariaDB
         Populates host inventory field= Software Application A    
-------------------------------------------------------
On Zabbix UI:
        Configuration->Hosts->Items->Create item:
         Name: OS Version
         Type: zabbix agent
         Key: system.sw.os[name]
         type of information: Character
         History storage period: Do not Keep ...
         Application: OS
         Populates host inventory field= OS   
-------------------------------------------------------
On Zabbix UI:
        Configuration->Hosts->Items->Create item:
         Name: OS Full Veriosn
         Type: zabbix agent
         Key: vfs.file.contents[/etc/system-release]
         type of information: Character
         History storage period: Do not Keep ...
         Application: OS
         Populates host inventory field= OS Full 
         
----------------------------------------------------------       
                
    On Target Server:
        # mkdir /var/lib/zabbix
        # chown zabbix:zabbix /var/lib/zabbix
        # chmod 700 /var/lib/zabbix
        # sudo -u zabbix vim /var/lib/zabbix/server-info
Vendor: Anisa
Contact: Mr. Ahmadi => 09123333333
Location: Tehran, IT Room, Rack 5
latitude: 35.7317819905064
longitude: 51.4131612661465
Deployment status: Production

            
    On Zabbix UI:
        Configuration->Hosts->Items->Create item:
         Name: Vendor
         Type: zabbix agent
         Key: vfs.file.regexp[/var/lib/zabbix/server-info,"Vendor: (.+)",,,,\1]
         type of information: Character
         History storage period: Do not Keep ...
         Application: OS
         Populates host inventory field= Vendor  

    On Zabbix UI:
        Configuration->Hosts->Items->Create item:
         Name: Contact Point
         Type: zabbix agent
         Key: vfs.file.regexp[/var/lib/zabbix/server-info,"Contact: (.+)",,,,\1]
         type of information: Character
         History storage period: Do not Keep ...
         Application: OS
         Populates host inventory field= Contact
```

---

# Session 9 (10 on classes)

### SNMP

# Session 10 (11 on classes)
Items (Preprocessing) + Macro

### Macros
- Macros have lots of function for processing/encoding
- Macro types in zabbix 7:
#### 1- Built in Macros
- {MACRO.NAME} => {HOST.NAME} , {ITEM.NAME} , {EVENT.STARTTIME}
#### 2- User defined Macros
- {$MACRO.NAME} , {$DSN.NAME}
#### 3- LLD (Low Level Discovery) Macros
- {#MACRO.NAME} => {#FS.NAME}
- For example in a filesystem related monitoring, monitoring service should be monitoring certain metrics of a filesystem and it needs to discover based on host and apply macros to it. 
```
[
{
"{#FS.NAME}": "/"
},
{
"{#FS.NAME}": "/home"
},
{
"{#FS.NAME}": "/var"
}
]
```

#### 4- Expression Macros
- Mostly in Visualization
- {?EXPRESSION} => {?func(/HOST_NAME/Item.key<,param1><,param2>...)} {?avg(/HOST_NAME/Icmppingloss,5m)}

#### 5- Macro Functions


- Some examples in Preprocessing Items
```

$.bookstore.payment[?(@.product == 'book' )]["success"].first()

$.bookstore.payment..["failed"].sum()

$.bookstore.payment[?(@.product == 'book' || @.product == 'magazine')]


===============================
<?xml version="1.0" encoding="UTF-8"?>
<bookstore>
<payment>
        <product>book</product>
        <success>4</success>
        <failed>5</failed>
</payment>
<payment>
        <product>magazine</product>
        <success>7</success>
        <failed>9</failed>
</payment>
</bookstore>

XPath = sum(/bookstore/payment/success)
Xpath = number(/bookstore/payment[product='book']/success)

=============================
JSON:
{
  "bookstore": {
    "payment": [
      {
        "product": "book",
        "success": 4,
        "failed": 5
      },
      {
        "product": "magazine",
        "success": 7,
        "failed": 9
      }
    ]
  }
}

$.bookstore.payment.*.success.sum()
$.bookstore.payment[?(@.product == 'book')].success.first()

===============================
CSV:

product,success,failed
book,4,5
magazine,7,9
```


# Session 11 (12 on classes)
Items (Preprocessing on SNMP) - web scenario - External check

- For Selenium based monitoring you need to enable WebDreverURL on port 4444 of your zabbix server, then using ITEMS>WEB you can have a JavaScript-ish code for scenario based monitoring

```
Web Scenario Monitoring:
    
on zabbix ui:
    Configuration->hosts->create hosts:
        Host name-> Website Monitoring
        Groups-> Website Monitoring
        Interface Agent-> 127.0.0.1
        
    Configuration->hosts->Website Monitoring->web->create Web scenarios

on tab Sceanrio:
    name-> Anisa Website Scenario
    New Application-> Anisa
    update interval-> 5m

on tab steps:
click add link on stest box:
    name: Opening Anisa First page
    URL: https://anisa.co.ir
    follow redirects->checked
    Required string: آنلاین و حضوری
    Required status code: 200
    
    
How to export value to variable using regex:
    regex:data-csrf_token="([0-9a-z]{64})"
```


### Log File Monitoring:
- A simple one
```
on Target-server:
    
    # mkdir /tmp/zabbix_logmon
    
    # echo $(date +"%F %T") First Log Entry > /tmp/zabbix_logmon/logfile
    # echo $(date +"%F %T") Second Log Entry >> /tmp/zabbix_logmon/logfile1
    # echo $(date +"%F %T") Third Log Entry >> /tmp/zabbix_logmon/logfile1


on browser:
    Configuration-> hosts->items->create item:
        name: Log file1
        Type: zabbix agent (active)
        Key: log[/tmp/zabbix_logmon/logfile1]
        Type of inforation: Log
        Update interval: 1s
        New Application: logfile
        
On Target Server:
    # echo $(date +"%F %T") forth log entry >> /tmp/zabbix_logmon/logfile1
    # echo $(date +"%F %T") fifth log entry >> /tmp/zabbix_logmon/logfile1
```

- A monitoring with regex for error
```
on browser:
    Configuration-> hosts->items->create item:
        name: Log file2
        Type: zabbix agent (active)
        Key: log[/tmp/zabbix_logmon/logfile2,error]
        Type of inforation: Log
        Update interval: 1s
        Application: logfile
    
On Target Server:
    # echo $(date +"%F %T") first log entry >> /tmp/zabbix_logmon/logfile2
    # echo $(date +"%F %T") second log entry - with error >> /tmp/zabbix_logmon/logfile2
    # echo $(date +"%F %T") third log entry >> /tmp/zabbix_logmon/logfile2
    # echo $(date +"%F %T") forth log entry - with error >> /tmp/zabbix_logmon/logfile2
```

- A monitoring with regex for error + warning for 6XX code
``` 
on browser:
    key: log[/tmp/zabbix_logmon/logfile2,"error|warning 6[0-6]"]
    
On Target Server:
    # echo $(date +"%F %T") fifth log entry - warning 605 >> /tmp/zabbix_logmon/logfile2
    # echo $(date +"%F %T") sixth log entry >> /tmp/zabbix_logmon/logfile2
    # echo $(date +"%F %T") seventh log entry - with error >> /tmp/zabbix_logmon/logfile2
    # echo $(date +"%F %T") eighth log entry - with warning 503 >> /tmp/zabbix_logmon/logfile2
    # echo $(date +"%F %T") ninth log entry - with warning 590 >> /tmp/zabbix_logmon/logfile2
```

- Monitoring a log file with dynamic/changeing name
```
on browser:
    Configuration-> hosts->items->create item:
        name: Log file2
        Type: zabbix agent (active)
        Key: logrt["/tmp/zabbix_logmon/access_[0-9]{4}-[0-9]{4}-[0-9]{2}.log"]
        Type of inforation: Log
        Update interval: 1s
        Log Time Format: yyyy-MM-dd hh:mm:ss
        Application: logfile
    
On Target Server:
    # echo $(date +"%F %T") first log entry >> /tmp/zabbix_logmon/access_$(date +"%F").log
    # echo $(date +"%F %T") second log entry - with error >> /tmp/zabbix_logmon/access_$(date +"%F").log
    # echo $(date +"%F %T") third log entry >> /tmp/zabbix_logmon/access_$(date +"%F").log
    # echo $(date +"%F %T") forth log entry - with error >> /tmp/zabbix_logmon/access_$(date +"%F").log
```

## More custom Functionality for zabbix monitoring
- For embedding some custom forms of monitoring there are 3 ways:
1. External Check
2. Zabbix Trapper
3. JavaScript

### External Check
- You have to put script inside machine that monitors desired host
- plcae in ``` /etc/zabbix/zabbix_server.conf --> External Script```


# Session 12 (13 on classes)

## Zabbix Trapper
- Zabbix Trapper is active (push-based)
```
Zabbix Trapper:
    on target server:
        # dnf install zabbix-sender

on zabbix ui:
    Configuration->hosts-> mariadb..->items->create item:

  name=> MariaDB Service Running Status (via Trapper)
  Type=> Zabbix Trapper
  key=>mariadb.status.trapper
  Application => MariaDB

on target server:
  # useradd scriptrunner
  # sudo -u scriptrunner mkdir /home/scriptrunner/scripts

  # sudo -u scriptrunner vim /home/scriptrunner/scripts/mariadb-check.sh

  #!/bin/bash
  zabbix_sender -z 192.168.1.100 -s "mariadb-dcte-M-5-anisa-1" -k mariadb.status.trapper -o `systemctl is-active mariadb | grep -c ^a`

  # chmod u+x /home/scriptrunner/scripts/mariadb-check.sh

  # sudo -u scriptrunner crontab -e

  */5 * * * * /home/scriptrunner/scripts/mariadb-check.sh
```


## Monitoring Databases using zabbix
- We monitor DBs using ODBC

```
Data Base Monitor:
on target server:
    # systemctl status mariadb
    # mysql -uroot -p
    
  > CREATE DATABASE  eshop;
  > use eshop;
  > CREATE TABLE transaction_status  (
id int(11) NOT NULL AUTO_INCREMENT,
time datetime DEFAULT NULL,
payment_gw varchar(45) DEFAULT NULL,
status varchar(45) DEFAULT NULL,
amount int(11) DEFAULT NULL,
PRIMARY KEY (id),
UNIQUE KEY id_UNIQUE (id)
  );
  
  
  # useradd scriptrunner -s /sbin/nologin
  # sudo -u scriptrunner mkdir /home/scriptrunner/scripts
  # sudo -u scriptrunner vim /home/scriptrunner/scripts/data-entry-script.sh

 
###################################
#!/bin/bash

random_count=$(( $RANDOM % 300 + 1 ))

DB_USER='root'
DB_PASSWD='qazwsx'

DB_HOST='localhost'
DB_NAME='eshop'
TABLE='transaction_status'

payment_types=( MellatGW SamanGW SepahGW Wallet Cash )

statuses=( Successful Failed)

for (( i=0; i<=$random_count; i++ ))
do
sleep_amount=$(( ($RANDOM % ( 300 / $random_count )) + 1 ))
sleep $sleep_amount
random_payment_type=$(( $RANDOM % 5 ))
random_status=$(( $RANDOM % 2 ))
mysql --host=$DB_HOST --user=$DB_USER --password=$DB_PASSWD $DB_NAME 2> /dev/null << EOF
INSERT INTO $TABLE (\`time\`, \`payment_gw\`, \`status\`, \`amount\`) VALUES (now(), "${payment_types[$random_payment_type]}", "${statuses[$random_status]}", $(( $RANDOM + 1000)));
EOF
#sleep $(( (300 / $random_count) - $sleep_amount ))
done

#####################################

# chmod u+x /home/scriptrunner/scripts/data-entry-script.sh

# /home/scriptrunner/scripts/data-entry-script.sh
    
For testing the script:
# mysql -uroot -p
    
> use eshop;
> select * from transaction_status;
> quit
  
  
   # sudo -u scriptrunner crontab -e
  */5 * * * * /home/scriptrunner/scripts/data-entry-script.sh
    
  # mysql -uroot -p
  > create user 'zabbix'@'192.168.1.100' identified by 'zabbix_pass';
  > GRANT select on eshop.* TO 'zabbix'@'192.168.1.100';
    
  # firewall-cmd --add-port=3306/tcp --permanent
  # firewall-cmd --reload
    
on zabbix server: 
  # dnf install mariadb-connector-odbc
  # vim /etc/odbc.ini
  [eshop]
  Description = eshop database
  Driver  = MariaDB
  Port = 3306
  Server = 192.168.1.101
  User = zabbix
  Password = zabbix_pass
  Database = eshop
    
    
  # isql Target_server
  > select * from transaction_status;

on zabbix ui:
  Configuration->hosts-> E-shop Machine ->items->create item:

  name=> Payment: MelatGW - succefull
  Type=> Database Monitor
  key=>db.odbc.select[,eshop]
  SQL Query=> slect count(1) from transaction_status where payment_gw="MellatGW" and status="successful";
  Application => MariaDB
  PreProcessing => simple change
```


# Session 13 (14 on classes)
Triggers

- How to write a function in zabbix
```
Expression: func(/host.name/item.key<,param1,...>) operator Threshhold
```

- Aggregations are two types:
1.
2. 



# Theoretical

## Components

## Files & directories

## Tips & Tricks
- If you don't save an item via history, you can't have trigger on it.
- For restarting userParameters in zabbix-agent, you don't need to restart zabbix-agent.service. You can use ``` $ zabbix_agent2 -R userparameter_reload ```
- Preprocessing in Items happens before saving in DB
- In a host, all Item's keys should be unique

## Commands

# Hands On


# acknowledgment
## Contributors

APA 🖖🏻

## Links
- Macro functions: https://www.zabbix.com/documentation/current/en/manual/config/macros/macro_functions


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