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
- ElasticSearch keeps logs in Json format (because of its key-value nature and searchability) then make it binary. COre of ElasticSearch is Apache Lucene

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

Add contents to ELK_course
Vid 007
0:33

## Session 8 (10 on classes)

## Session 9 (11 on classes)

## Session 10 (13 on classes)

## Session 11 (14 on classes)

## Session 12 (15 on classes)

## Session 13 (16 on classes)

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