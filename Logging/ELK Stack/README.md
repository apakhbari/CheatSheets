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
- ElasticSearch keeps logs in Json format (because of its key-value nature and searchability) then make it binary

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
- by default shards = 1 and replicas = 1 , never ever primary and replicas are same nodes
- After starting ElasticSearch using ` $ ./bin/elasticsearch ` some new configurations are going to be added to ` config/elasticsearch.yaml `

Rec002
Add contents to ELK_course
02:58

## Session 3 (5 on classes)
## Session 4 (6 on classes)

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
## Session 6 (8 on classes)
## Session 7 (9 on classes)
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