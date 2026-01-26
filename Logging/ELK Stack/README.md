# ELK Stack
```
 _______  ___      ___   _      _______  _______  _______  _______  ___   _ 
|       ||   |    |   | | |    |       ||       ||   _   ||       ||   | | |
|    ___||   |    |   |_| |    |  _____||_     _||  |_|  ||       ||   |_| |
|   |___ |   |    |      _|    | |_____   |   |  |       ||       ||      _|
|    ___||   |___ |     |_     |_____  |  |   |  |       ||      _||     |_ 
|   |___ |       ||    _  |     _____| |  |   |  |   _   ||     |_ |    _  |
|_______||_______||___| |_|    |_______|  |___|  |__| |__||_______||___| |_|
```

## Theoretical
## Introduction

## Features
## Components

## Tips & Tricks
- In Elastic world, data shipping tools stands for Beats and logstash and fleet client
- ElasticSearch keeps logs in Json format (because of its key-value nature and searchability) then make it binary. COre of ElasticSearch is Apache Lucene
- Elk is a SIEM system
- What happens if volume of Input data (IOPS) is more than what is being processed by ElasticSearch, data is lost. If we don't have a cluster, then for buffering stuff we can use a cache/buffer server in front of Elastic. In this case we need a fast disk
- defaul behaviour of elsatic cluster, for each index we have 1 primary shard and 1 replica shard
- in elasticsearch default size of JVM heap size is half of ram on each node
- never ever primary and replica are not in same node
- A p12 file is CERT + Private_key
- For getting more complete stuff on requested API calls from our elasticsearch, we need to add ` ?v ` (verbose) to end of our API call, for example ` curl -k -X GET --user anisa:123456 https://els1.fartakec.local:9200/_cat/nodes?v ` so we have headers of what metrics we have 
- Elastic reads 50% of an index's data from its primary shard and 50% of its data from replica shard so it is faster than a 100% read on a sigle node
- in a 3 nodes cluster, if we lose 2 nodes then first of all some of our data is lost, but not all of it, then elastic make that 1 healthy node to read-only untill other nodes are back again
- As long as cluster is up and we have a master node, no matter what node is down, whatever index we want, we can retrieve its data. By the time our cluster is not healthy and we don't have a master node, we can stll retrieve some data using API-calling our healthy nodes directly (not with cluster-scoped API-calls)
- After failing a node, there is a time window that elastic needs to copy its replicated data on other nodes
- Each shard is bind on a cpu core, so we have parallel querying
- Monitoing disks I/O is important, since after a while disks are going to be slower, so when it hits a threshhold, we need to replace it with a new disk
- In elasticsearch, a document never strips, so for example if we have more than 1 primary shards, then it is NOT acting like RAID0, like 1/3 of data being written on a shard and 1/3 of it on another shard and so on. more than one shard is good for loadbalancing documents between nodes, so if we have 3 primary shards our data is being loadbalanced on 3 different nodes and we don't have all of our indices on a single node. In this use case if we have 1 replica, then it means we have 1 replica for each primary shard, 6 shards in total
- instead of using data shipping tools like Beats and logstash, we can use Fleet Server + fleet client (elastic agent on each machine) to collect metrics and logs. Kibana collect logs from fleet server.
- If we create a user on an elasticsearhc node, we need to create it on other nodes, but we can use ` kibana_system ` user which has lots of permissions and will be synced across our elastic clusters and can be used for many workflows and we can ` /bin/reset_password ` to get its password

## API Calls
- ` es2.fartakec.local:9200/_cat/nodes?v `
- ` es2.fartakec.local:9200/_cat/shards?v `

## Hands On

# Sessions
## Session 1 (1 on classes)
- Log Management:
  - Data Gathering
  - Data Analysing (Visualization, Alerting, Corelation)

- Elastic Stack: consists of ELK Stack (Logstash + ElasticSearch + kibana) + Beats
- ElasticSearch keeps logs in Json format (because of its key-value nature and searchability) then make it binary
- ElasticSearch indexes data

- to start elasticsearch
```
$ vim config/elasticsearch.yaml
Edit cluster.name
Edit node.name
Edit network.host

$ ./bin/elasticsearch
```

- ElasticSearch is accessible on 9200 port

- to add a new user
```
$ ./bin/elasticsearch-users useradd farhad -p 123456 -r superuser
```

## Session 2 (2 on classes)
### ElasticSearch
- by default shards = 1 and replicas = 1 , never ever primary and replicas are same nodes
- After starting ElasticSearch using ` $ ./bin/elasticsearch ` some new configurations are going to be added to ` config/elasticsearch.yaml `

- our certificate needs to be inside ` ./config/certs ` directory, if not it's not going to work
- When we add a p12 cert to our elastic, we need to use  ` ./bin/elasticsearch-keystore add xpack.security.http.ssl.keystore.secure_password` to enter our password of certificate of our http endpoint in order to be https. Now it is saved encrypted

- change disk usage watermark: (when 90% of disk is occupied, it automatically stop node as primary and make it read only and transform data to other shards)
```
$ vim ./config/elasticsearch.yaml

cluster.routing.allocation.disk.watermark.low: 95%  # Default 90%
cluster.routing.allocation.disk.watermark.high: 97%   # start transfer to other shards
cluster.routing.allocation.disk.watermark.flood_stage: 98%    # stop writing 
```

- Engine of ElasticSearch is Apache Lucene, which make our logfiles binary, so everything is faster

### Kibana
- now we need to extract Kibana
- we create a certificate for it
```
[req]
[req]
distinguished_name = req_distinguished_name
req_extensions = req_ext

[req_distinguished_name]
countryName                     = Country Name (2 letter code)
stateOrProvinceName             = State or Province Name (full name)
localityName                    = Locality Name (eg, city)
organizationalUnitName          = Organizational Unit Name (eg, section)
commonName                      = Common Name (eg, your name or your server\'s hostname)
emailAddress                    = Email Address

[req_ext]
subjectAltName = @alt_names

[alt_names]
IP.1 = 172.16.100.1
IP.2 = 10.10.10.200
#IP.3 = 10.10.10.200
#IP.4 = 79.127.7.119
#IP.5 = 194.5.192.250
DNS.1 = kibana1.fartakec.local
DNS.2 = kibana.fartakec.local
#DNS.3 = kibana.fartakec.ir
#DNS.4 = auto.fartakec.local
#DNS.5 = auto.fartakec.com
#DNS.6 = auto.fartakec.ir
#DNS.7 = kibana2.fartakec.com
#DNS.8 = kibana2.fartakec.local
#DNS.9 = kibana2.fartakec.com
```

- we need to make some changes in config file
```
$ vim ./config/kibana.yaml

Edit server.host: give IP
Edit server.name: kibana1

Edit server.ssl.enabled: to true
Edit server.ssl.certificate
Edit server.ssl.key

Edit elasticsearch.ssl.verificationMode: none   (Since our cert is self-signed)
```

- to start it
```
$ ./bin/kibana
```
- now we need to eneter addres of elasticsearch on our dashboard
- now we need to get password of user ` kibana_system ` , we need to ` ./elasticsearch/bin/elasticsearch-reset-password -u kibana_system `
- now we need to wait untill setup is compeleted
- after setup completion, now we can enter Kibana using our previously generated password (not kibana_system)

## Session 3 (5 on classes)
- We communicate with ES using API, Logstash, Agents, Kibana, and Beats are all API based too
- API Method:
1. GET: Retrieve Data, Default of API if  not assigned
2. POST: Send Data
3. PUT: Update index
4. DELETE

- Overall API Syntax:

```
$ curl [-k] [--cacert /path/to/ca] [--user <user:pass>] [-H <header>] [-d <data>] -X <method> url:port 

API in Elastic Search:

Get overall status:
$ curl -k -X GET --user anisa:123456 https://els1.fartakec.local:9200/

make output human readable:
$ curl -k https://els1.fartakec.local:9200/?pretty
$ curl -k https://els1.fartakec.local:9200 | jq

Get Nodes in cluster:
$ curl -k -X GET --user anisa:123456 https://els1.fartakec.local:9200/_cat/nodes?v

Get cluster health:
$ curl -k -X GET --user anisa:123456 https://els1.fartakec.local:9200/_cluster/health | jq

Get list of indices (and its properties):
$ curl -k -X GET --user anisa:123456 https://els1.fartakec.local:9200/_cat/indices?v

Create an index (here "test-api"):
$ curl -k -X PUT --user anisa:123456 https://els1.fartakec.local:9200/test-api | jq

Get an index details (here "test-api"):
$ curl -k -X GET --user anisa:123456 https://els1.fartakec.local:9200/test-api | jq

Delete an index (here "test-api"):
$ curl -k -X DELETE --user anisa:123456 https://els1.fartakec.local:9200/test-api | jq

Create a Document inside an index(here 1):
$ curl -k -X POST --user anisa:123456 https://els1.fartakec.local:9200/test1/_doc/1 -d '{"name": "farhad", "age": 20, "profession": "Network Engineer"}' -H 'Content-Type: application/json'

Retrieve a document(here 1):
$ curl -k -X GET --user anisa:123456 https://els1.fartakec.local:9200/test1/_doc/1 | jq

Delete a document:
$ curl -k -X GET --user anisa:123456 https://els1.fartakec.local:9200/test1/_doc/1 | jq
```

## Session 4 (6 on classes)
### Logstash
- Logstash understands syslog from one point and can forward them using API to elasticsearch
- Logstash: Data Gathering + Data pre-processing + Data Transmission

- we need to have a pipeline in ` ./config/pipelines.yml `
- a pipeline consisted of:
1. Input
2. Filter (can be removed)
3. Output

- Let's have a simple pipeline that prints every input inside stdout, and also send logs to elasticsearch
```
input {
  udp {
    port => 5140
    codec => plain
  }
}

filter {

}

output {
  elasticsearch {
    hosts => ["https://els1.fartakec.local:9200"]
    index => "router-logs-%{+YYYY.MM.dd}"
    user => "anisa"
    password => "123456"
    ssl_enabled => true
    ssl_verification_mode => "none"
    ssl_certificate_authorities => "/home/farhad/ca/cacert.pem"
  }
  stdout {
    codec => rubydebug
   }
}
```

- for running. logstash it's the same, but we need to pass pipeline to it
```
$ ./bin/logstash -f config/confs/simple.yml
```

- For configuring Routers to send syslog to Logstash
```
r1
==============
Building configuration...

Current configuration : 1635 bytes
!
upgrade fpd auto
version 15.3
service timestamps debug datetime msec
service timestamps log datetime msec
no service password-encryption
!
hostname R1
!
boot-start-marker
boot-end-marker
!
aqm-register-fnf
!
logging console informational
logging monitor informational
!
no aaa new-model
no ip icmp rate-limit unreachable
!
!
!         
!
!
!
no ip domain lookup
ip cef
no ipv6 cef
!
multilink bundle-name authenticated
!
!
!
!
!
!
!
!
!
!
redundancy
!
!
ip tcp synwait-time 5
!         
!
!
!
!
!
!
!
!
!
interface Ethernet0/0
 no ip address
 shutdown
 duplex auto
!
interface GigabitEthernet0/0
 ip address 172.16.1.2 255.255.255.0
 duplex full
 speed 1000
 media-type gbic
 negotiation auto
!
interface GigabitEthernet1/0
 ip address 192.168.150.1 255.255.255.0
 shutdown
 negotiation auto
!
interface GigabitEthernet2/0
 no ip address
 shutdown
 negotiation auto
!
interface GigabitEthernet3/0
 no ip address
 shutdown
 negotiation auto
!
!
router eigrp 1
 network 172.16.1.0 0.0.0.255
 network 192.168.150.0
!
ip forward-protocol nd
no ip http server
no ip http secure-server
!
!         
!
logging source-interface GigabitEthernet0/0
logging host 172.16.1.1 transport udp port 5140
no cdp log mismatch duplex
!
!
!
control-plane
!
!
mgcp behavior rsip-range tgcp-only
mgcp behavior comedia-role none
mgcp behavior comedia-check-media-src disable
mgcp behavior comedia-sdp-force disable
!
mgcp profile default
!
!
!
gatekeeper
 shutdown
!
!         
line con 0
 exec-timeout 0 0
 privilege level 15
 logging synchronous
 stopbits 1
line aux 0
 exec-timeout 0 0
 privilege level 15
 logging synchronous
 stopbits 1
line vty 0 4
 login
 transport input all
!
!
end





r2
==================
Building configuration...

Current configuration : 1625 bytes
!
upgrade fpd auto
version 15.3
service timestamps debug datetime msec
service timestamps log datetime msec
no service password-encryption
!
hostname R2
!
boot-start-marker
boot-end-marker
!
aqm-register-fnf
!
logging console informational
logging monitor informational
!
no aaa new-model
no ip icmp rate-limit unreachable
!
!
!         
!
!
!
no ip domain lookup
ip cef
no ipv6 cef
!
multilink bundle-name authenticated
!
!
!
!
!
!
!
!
!
!
redundancy
!
!
ip tcp synwait-time 5
!         
!
!
!
!
!
!
!
!
!
interface Ethernet0/0
 no ip address
 shutdown
 duplex auto
!
interface GigabitEthernet0/0
 ip address 172.16.1.3 255.255.255.0
 duplex full
 speed 1000
 media-type gbic
 negotiation auto
!
interface GigabitEthernet1/0
 ip address 192.168.150.2 255.255.255.0
 negotiation auto
!
interface GigabitEthernet2/0
 no ip address
 shutdown
 negotiation auto
!
interface GigabitEthernet3/0
 no ip address
 shutdown
 negotiation auto
!
!
router eigrp 1
 network 172.16.1.0 0.0.0.255
 network 192.168.150.0
!
ip forward-protocol nd
no ip http server
no ip http secure-server
!
!
!         
logging source-interface GigabitEthernet0/0
logging host 172.16.1.1 transport udp port 5140
no cdp log mismatch duplex
!
!
!
control-plane
!
!
mgcp behavior rsip-range tgcp-only
mgcp behavior comedia-role none
mgcp behavior comedia-check-media-src disable
mgcp behavior comedia-sdp-force disable
!
mgcp profile default
!
!
!
gatekeeper
 shutdown
!
!
line con 0
 exec-timeout 0 0
 privilege level 15
 logging synchronous
 stopbits 1
line aux 0
 exec-timeout 0 0
 privilege level 15
 logging synchronous
 stopbits 1
line vty 0 4
 login
 transport input all
!
!
end
```

## Session 5 (7 on classes)
- Logstash Input
  - File (text)
  - CSV
  - STDIN

  - Network Input:
    - Beat(s)
    - TCP
    - UDP
    - HTTP(S)
    - Syslog

  - Message Queues:
    - Kafka
    - RabbitMQ
    - JMS

  - DataBase
  - Cloud Service
  - Plugin

- Logstash Filter
  - Grok
  - Mutate
  - Date
  - GeoIP
  - CSV
  - JSON
  - Split
  - XML
  - Drop
  - Clone     

- Grok make unstructured data of logs into a structured field-value data
- ` GREEDYDATE ` means match all data till end of line
```
input {
file {
  path => "/var/log/apache2/access.log"
  discover_interval => 1
  stat_interval => 1
}
file {
  path => "/var/log/auth.log"
  discover_interval => 1
  stat_interval => 1
}
}

filter {
  if [path] == "/var/log/apache2/access.log"
    grok {
      match => {"message" => "%{IP:client_ip} %{DATA:identity} %{DATA:authentication} \[%{DATA:time}\] \"%{WORD:http_method}" }
    }
  if [path] == "/var/log/auth.log"
    grok {
      match => {"message" => "%{TIMESTAMOISO8601:time}" }
    }
  else {      # We write this for all logs that are not going to match with above groks
    grok {
      match => {"message" => "%{GREEDYDATE:message}"}
    }
  }
}

output {
  elasticsearch {
    hosts => ["https://els1.fartakec.local:9200"]
    index => "router-logs-%{+YYYY.MM.dd}"
    user => "anisa"
    password => "123456"
    ssl_enabled => true
    ssl_verification_mode => "none"
    ssl_certificate_authorities => "/home/farhad/ca/cacert.pem"
  }
  stdout {
    codec => rubydebug
   }
}
```

## Session 6 (8 on classes)

```
input {
file {
  path => "/var/log/apache2/access.log"
  discover_interval => 1
  stat_interval => 1
}
file {
  path => "/var/log/auth.log"
  discover_interval => 1
  stat_interval => 1
}
}

filter {
  if [log][file][path] == "/var/log/apache2/access.log" {
    grok {
      match => {"message" => "%{IP:client_ip} %{DATA:identity} %{DATA:authentication} \[%{DATA:time}\] \"%{WORD:http_method}" }
    }}
  if [log][file][path] == "/var/log/auth.log" {
    grok {
      match => {"message" => "%{TIMESTAMOISO8601:time}" }
    }}
  else {      # We write this for all logs that are not going to match with above groks
    grok {
      match => {"message" => "%{GREEDYDATE:message}"}
    }
  }
}

output {
  if [log][file][path] == "/var/log/apache2/access.log" {
    elasticsearch {
      hosts => ["https://els1.fartakec.local:9200"]
      index => "router-logs-%{+YYYY.MM.dd}"
      user => "anisa"
      password => "123456"
      ssl_enabled => true
      ssl_verification_mode => "none"
      ssl_certificate_authorities => "/home/farhad/ca/cacert.pem"
    }
  }
  if [log][file][path] == "/var/log/auth.log" {
    elasticsearch {
      hosts => ["https://els1.fartakec.local:9200"]
      index => "auth-logs-%{+YYYY.MM.dd}"
      user => "anisa"
      password => "123456"
      ssl_enabled => true
      ssl_verification_mode => "none"
      ssl_certificate_authorities => "/home/farhad/ca/cacert.pem"
    }
  }
  stdout {
    codec => rubydebug
   }
}
```

## Session 7 (9 on classes)
- when insatlling ElasticSearch using apt/rpm its bin file is located at ` /usr/share/elasticsearch/bin `

- DataStream is a layer above index, so when we want to search in it, it is easier

### Beats
- AuditBeat
- FileBeat
- HeartBeat
- MetricBeat
- PacketBeat
- WinLogBeat

- Beats are lightweight data shipping tools

## Session 8 (10 on classes)

## Session 9 (11 on classes)
- All beats can be configured to send data to Kibana directly, these have pre-made dashboards that you can use but for using those you need to pass ` setup --dashboards --strict-perms=false ` flag

### AuditBeat
- AuditBeat has a file integrity check
- AuditBeat has two sections for multiple time fetching, for example there is a 12 h check and a 5 m check

### PacketBeat
- You choose a network interface, then it trace all packets that are sent/recieved
- PacketBeat creates lots of data

- packetBeat can't capture network packets, it needs sudo access and then when we are running it, we need to pass ` --strict-perms=false ` flag to it so it can be executed

### MetricBeat
- MetricBeat has a module directory, which are a lots of things that you can collect metrics from, all of them have a ` .disabled ` file extension, for enabling any of them, remove this file extension
- MetricBeat have some pre-enabled modules, located in ` module ` directory

## Session 10 (13 on classes)
- User Management in ELK:
1. Scripts
2. API
3. Kibana (Still API)

- User Rolls are the way elastic handles users
- For craeting a roll we need to ` curl `

```
create a role:
curl -k -X POST "https://els1.fartakec.local:9200/_security/role/test1" -u anisa:123456 -H "Content-Type: application/json"  -d '    
    {
      "cluster": ["all"],
      "indices": [
        {
          "names": ["index1", "index2"],
          "privileges": ["read", "write"] 
        }
      ],
      "run_as": ["other_user"]
    }'
======================================================================================
Create a user:
curl -k  -X POST "https://els1.fartakec.local:9200/_security/user/test-api" -u anisa:123456 -H "Content-Type: application/json"  -d '
{
  "password" : "123456",
  "roles" : ["test1", "superuser"],
  "full_name" : "user userpour",
  "email" : "user@fartakec.local",
  "metadata" : { "department" : "engineering" }
}'
======================================================================================
Modify a user role:
 curl -k  -X POST "https://els1.fartakec.local:9200/_security/user/test-api" -u anisa:123456 -H "Content-Type: application/json"  -d '
{
  "roles" : ["superuser","superuser"]
}'

Note: after this API call, always {"created":false} is appeared. this is not error and changes has been applied.
======================================================================================
Change password of a user:
curl -k  -X POST "https://els1.fartakec.local:9200/_security/user/test-api/_password" -u anisa:123456 -H "Content-Type: application/json"  -d '
{                      
  "password" : "654321"
}'
======================================================================================
Delete a user:
curl -k  -X DELETE "https://els1.fartakec.local:9200/_security/user/test-api" -u anisa:123456
======================================================================================
```

### Cluster

- What happens if volume of Input data (IOPS) is more than what is being processed by ElasticSearch, data is lost. If we don't have a cluster, then for buffering stuff we can use a cache/buffer server in front of Elastic. In this case we need a fast disk
- Health:
1. Green: All shards (primary + replica)
2. Yellow: only primary shards
3. Red: No shard

- Elastic's cluster is like a RAID 1
- Shards allow horizontal scaling, it can be primary or replicate
- shards are partly indexes that are stored on nodes
- defaul behaviour of elsatic cluster, for each index we have 1 primary shard and 1 replica shard
- never ever primary and replica are not in same node
- based on how many nodes we have (n), search ability is n time faster

## Session 11 (14 on classes) - Clusterning ElasticSearch with certificates, Clustering kibana

- In order to have a certificate between our Elastic componenets, in order to them verify each other and a man in the middle attack cab't happen, we use to create certificate for servers.
/usr/share/local/elasticsearch/elasticsearch-certutil ca

- Create user for kibana integration with elasticsearch (with special permission)
```
curl -k -u elastic:PASSWORD -X PUT "https://els1.frtakec.local:9200/_security/user/kibana_user" -H "Content-Type: application/json" -d '{"role": ["superuser", "kibana_system_custom"]}'
{
  "indices": [
    {
      "names" : [
        ".kibana*",
        ".kibana_alerting_*",
        ".kibana_security_solution*",
        ".kibana_alerting_cases_*",
      ],
      "privileges": [
        "read",
        "write",
        "create_index",
        "manage",
        "view_index_metadata"
      ],
      "allow_restricted_indices": true
    }
  ]
}
```

- Create user for Kibana
```
curl -k -u elastic:PASSWORD -X PUT "https://els1.frtakec.local:9200/_security/user/{username}" -d elastic:PASSWORD -H "Content-Type: application/json" -d '
{
  "password" : "user_password",
  "roles" : ["superuser", "kibana_system_custom"],
  "full_name" : "User Full Name"
  "email" : "user@example.com",
  "metadata" " { "department" : "engineering" }
}'
```

- Add created role to this user:
```
curl -k -u elastic:PASSWORD -X PUT "https://els1.fartakec.local:9200/_security/user/kibana-user" -d elastic:PASSWORD -H "Content-Type: application/json" -d '
{
  "roles" : ["superuser", "kibana_system_custom"]
}'
```


## Session 12 (15 on classes)

- For connecting Our kibana to elasticsearch cluster, we need to conenct it to multiple node of our elastic. Take note that we need a user that was created using API to work on all of our elasticsearch, since users that are created using ` /bin ` scripts, are only working on a single node that was created on it
```
/etc/kibana.yml
...
elasticsearch.hosts: ["https://es1.fartakec.local:9200", "https://es2.fartakec.local:9200", "https://es3.fartakec.local:9200"]
```

## Session 13 (16 on classes)

- Increasing number of primary shards --> increasing write speed
- Increasing number of replica shards --> increasing read speed
- In elasticsearch, a document never strips, so for example if we have more than 1 primary shards, then it is NOT acting like RAID0, like 1/3 of data being written on a shard and 1/3 of it on another shard and so on. more than one shard is good for loadbalancing documents between nodes, so if we have 3 primary shards our data is being loadbalanced on 3 different nodes and we don't have all of our indices on a single node. In this use case if we have 1 replica, then it means we have 1 replica for each primary shard, 6 shards in total
- Cons of increasing number of primary shards, since each shard has its iwn architecture, then JVM heap size is going to increase and we have less RAM available. Also tracking shards on different nodes have overhead for cluster + we can't change number of primary shards after creation
- max number of replicas: Nodes - 1 --> since primary and replica are not on same node

### Alerting
- Rule --> Alert --> Connector
- For using alerting we need to add encription key to kibana
```
$ ./usr/share/kibana/bin/kibana-encription-keys generate
```
- then it is going to output 3 lines of settings, add it inside ` /etc/kibana/kibana.yml `

- Kibana has three different forms for querying:
1. KQL (or Lucene): is deprecateed
2. Query DSL: json-based, what is currently being used 
3. ES|QL: looks liks SQL queries

- In free version of Elastic + Kibana, we only have writing to log file action. So we can't send Email or SMS ot this kind of things
- We use ` Index Connector ` as a turn-around for licensed connectors
- for installing python's library for elasticsearch:
```
$ sudo apt install python3-elasticsearch
$ pyenv/bin/python3.12 -m pip install elasticsearch
```

- now we write a script for alerting
```

```



## Session 14 (17 on classes) - Keepalived + Kibana
- When we use kibana + keepalived, we need to set ` publicBaseURL ` to our keepalived URL so it is working fine. Since its default port is ` 5601 ` if we are using ` 443 ` port, we need to define it in our URL

## Session 15 (18 on classes)
- Since we want our Kibana instance to use port 443 and this port is elevated port, we need to ` setcap ` to executable file of Kibana ` $ sudo setcap 'cap_net_bind_service=+ep' /usr/share/kibana/bin/kibana `  ep stands for execute permission. then we can view capabilities of a file using ` $ getcap /usr/share/kibana/bin/kibana `

### Fleet
- instead of using data shipping tools like Beats and logstash, we can use Fleet Server + fleet client (elastic agent on each machine) to collect metrics and logs. Kibana collect logs from fleet server.
- fleet policy is used for fleet server and fleet client, so it is how elastic understands which one is a server and which one is client
- If we use command that is inside Kibana UI for importing fleet server we are going to face a problem, we need to add ` --fleet-server-es-ca=<ADDRESS OF PEM FILE OF CA> --insecure ` to its command
- fleet agent is smae file, the key factor that indicate if it is going to be a fleet-server or fleet-clinet, is its agent-policy
- It is not possible to process fleet using logstash

### Backup + snapshots
- after version 8-9 of elastic, you can't create an instant snapshot/backup. What is possible is to create a repository for snapshot, then setting a policy for time of snapshot
- For restoring indices, what we need is a closed index, since if index is open, it means it is open to getting new data and when we close it, then we can restore data from snapshot on it

### Index Template
- when we create an index template, we are creating a template for our indices to be created.
- Index mode:
  - Standard: what we usually use
  - Time series: for metrics data
  - LogsDB: for storing logs data
  - Lookup: optimized for ESQL
- Rule of thumb: do not delete/edit any of default index templates unless you really know what you are doing

### Index Lifecycle Management
- Hot (active data) --> Warm --> Cold --> Delete
- In hot phase we have rede + write but in other phases we don't have such thing
- We can assign data to which sort of disks we have + number of shards it have based on time
- by default Elastic's default is 50 G or 30 days for retention
- then we assign an ILM to an index template

### Node Roles
- we can have roles for our nodes in ` elasticsearch.yml `
  - data
  - master
  - data_hot
  - data_warm
  - data_cold
  - ingest
  - ml
  - ...


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