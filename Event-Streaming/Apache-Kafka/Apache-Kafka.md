# kafka
```
 ___   _  _______  _______  ___   _  _______ 
|   | | ||   _   ||       ||   | | ||   _   |
|   |_| ||  |_|  ||    ___||   |_| ||  |_|  |
|      _||       ||   |___ |      _||       |
|     |_ |       ||    ___||     |_ |       |
|    _  ||   _   ||   |    |    _  ||   _   |
|___| |_||__| |__||___|    |___| |_||__| |__|
```

```
ls > names.txt
sed -i "/\b\(vtt\)\b/d" names.txt
cat names.txt | sed 's/^/### /' | sed 's/.\{4\}$//'
```

# Table of Contents

- Theoritical
  - Apache Kafka
  - Components
  - policies
  - Tips & Tricks
- Hands On
  - Directories
  - configs
  - commands
- Contents of course
- acknowledgment

# Theoritical

## Components
### Apache Kafka
- Apache Kafka is distributed publish-subscribe messaging system

### Broker
```mermaid
graph LR
A[Producer] -->B[Broker]
B --> C[Consumer]
```

### Controller
- One of the brokers serves as the controller, which is responsible for managing the states of partitionins and replicas and for performing administrative tasks like reassigning partitions.
- Zookeeper's job is only to select controller. Nothing else.

### Zookeeper
- main responsibilities of zookeeper
  - Maintain list of active brokers
  - elects controller
  - Manages configuration of the topics and partitions
- A cluster of zookepers are called ensemble
- in every zookeeper cluster you should set up quorum. Qourum is the minimum quantity of the servers that should be up and running in order to be operational.
- It is recommended to have odd number of servers in the zookeeper enemble and set qourum to *(n+1)/2* where n is quantity of servers

### Topics & Partitions
- If topic "cities" is created with default configuration (single partition), broker will create a folder *cities-0* for single partition
- A partition is simply a seperate folder with differtn files
- Producers decide to write on which partition
- Partition Leader handles partition read/write operation. Producers and consumers only communicate with Leader broker of a specific partition, other replicated brokers are for active/passive backup plans
- It is best practice to set replication to 3. so there is 1 active and 2 passive partition available


### Consumer / Producers
- Producer: send messages to Kafka Cluster
- Consumer: receive messages from kafka cluster
- Kafka has a built-in producer called kafka-console-producer
- Kafka cluster stores messages even if they were already consumed by one of the consumers. Same messages may be read multiple times by different consumers
- Multiple consumers and multiple producers could exchange messages via *single centralized storage point* - kafka cluster
- Producers and Consumers don't know about each other
- Producers and Consumers may appear and disappear. but Kafka doesn't care about that. It's job is to store messages and recive or send them on demand
- Every consumer must be part of a consumer group

### Messages
- New messages will append at the end. You can not insert any messages before previous messages.
- Every message inside of the topic has unique number called "Offset". First message in each topic has offset 0. Consumers start reading messages starting from specific offset. For example:
```
Topic Cities:
> Paris [offset 0]
> London [offset 1]
> Sydney [offset 2]
> Delhi  [offset 3]
> Madrid [offset 4]
```
- Messages are Immutable
- It is best practice to keep messages as small as possible
- Message Structure
  - Timestamp --> Can configure to be assigned via broker or producer.
  - Offset Number (unique across partition)
  - Key (Optional)
  - Value (sequence of bytes) 


## policies
- Kafka doesn't store all messages forever and after specific amount of time (or when size of the log exceeds configured max size) messages are deleted.
- Default log retention period is *7 Days (168 hours)*

## Tips & Tricks
- ReplicationFactor of Topics means how many times a topic should be replicated on different kafka servers/brokers.
- If Brokers should be publicly accessible you need to adjust "advertised.listeners" property in Broker config

# Hands On
## Directories
- /tmp/kafka-logs --> Logs

## Configs
### configs/server.properties
- by default number of partitions for topics is 1.

### Default Ports
|     Service     | Port |
|:---------------:|:----:|
| Server / Broker | 9092 |
|    Zookeeper    | 2182 |

## Commands

- START ZOOKEEPER
```
$ bin/zookeeper-server-start.sh config/zookeeper.properties
```

- START KAFKA BROKER
``` 
$ bin/kafka-server-start.sh config/server.properties
```

- CREATE TOPIC
``` $ bin/kafka-topics.sh \
--bootstrap-server localhost:9092 \
--create \
--replication-factor 1 \
--partitions 3 \
--topic test
 ```

- LIST TOPICS
``` $ bin/kafka-topics.sh \
--bootstrap-server localhost:9092 \
--list
```

- TOPIC DETAILS
```
$ bin/kafka-topics.sh \
--bootstrap-server localhost:9092 \
--describe \
--topic test
```

- START CONSOLE PRODUCER
```
$ bin/kafka-console-producer.sh \
--broker-list localhost:9092 \
--topic test
```

- START CONSOLE CONSUMER
```
$ bin/kafka-console-consumer.sh \
--bootstrap-server localhost:9092 \
--topic test
```

- START CONSOLE CONSUMER AND READ MESSAGES FROM BEGINNING
```
$ bin/kafka-console-consumer.sh \
--bootstrap-server localhost:9092 \
--topic test \
--from-beginning
```

- START CONSOLE CONSUMER WITH SPECIFIC CONSUMER GROUP
``` $
bin/kafka-console-consumer.sh \
--bootstrap-server localhost:9092 \
--topic test \
--group test \
--from-beginning
```

- LIST CONSUMER GROUPS
```
$ bin/kafka-consumer-groups.sh \
--bootstrap-server localhost:9092 \
--list
```



- CONSUMER GROUP DETAILS
```
$ bin/kafka-consumer-groups.sh \
--bootstrap-server localhost:9092 \
--group test \
--describe
```


# Contents of course
## 1 - Introduction
## 2 - Apache Kafka Installation Overview
## 3 - Installing Apache Kafka on the remote Ubuntu server
## 4 - Installing Apache Kafka on Windows
## 5 - Starting Apache Zookeeper and Kafka Broker

## 6 - Creating and exploring Kafka Topic
### 22 - SECTION 5 Introduction
### 23 - How to connect to Kafka cluster
### 24 - Create new Kafka topic
### 25 - What happened after creation of the new topic
### 26 - Read details about topic

## 7 - Producing and consuming Messages
### 27 - SECTION 6 Introduction
### 28 - Send some messages using Kafka Console Producer
### 29 - Consuming messages using Kafka Console Consumer
### 30 - Consuming messages from the beginning
### 31 - Running multiple consumers
### 32 - Running multiple producers
### 33 - What was changed in the Kafka logs

## 8 - What is Apache Kafka and how it works
### 34 - SECTION 7 Introduction
### 35 - What is Apache Kafka
### 36 - Broker
### 37 - Broker cluster
### 38 - Zookeeper
### 39 - Zookeeper ensemble
### 40 - Multiple Kafka clusters
### 41 - Default ports of Zookeeper and Broker
### 42 - Kafka Topic
### 43 - Message structure
### 44 - Topics and Partitions
### 45 - Spreading messages across partitions
### 46 - Partition Leader and Followers
### 47 - Controller and its responsibilities
### 48 - How Producers write messages to the topic
### 49 - How Consumers read messages from the topic

## 9 - GitHub Repository and Diagrams for the course
### 50 - SECTION 8 Introduction
### 51 - GitHub repository and list of basic Kafka commands
### 52 - Diagrams for the course

## 10 - EXAMPLE 1 Topic with Multiple Partitions

## 11 - EXAMPLE 2 Kafka Cluster with Multiple Brokers

## 12 - EXAMPLE 3 Multiple Brokers and Topic with Replication

## 13 - EXAMPLE 4 Kafka Consumer Groups

## 14 - EXAMPLE 5 Performance Testing

## 15 - PROJECT 1 Java

## 16 - PROJECT 2 Nodejs

## 17 - PROJECT 3 Python

## 18 - Course Summary

# acknowledgment

## Contributors

APA 🖖🏻

## Links
- Course: https://www.udemy.com/course/apache_kafka/?couponCode=2021PM20

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
