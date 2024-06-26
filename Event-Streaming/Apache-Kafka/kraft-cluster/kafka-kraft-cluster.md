# Kafka Kraft Cluster
```

 ___   _  ______    _______  _______  _______         _______  ___      __   __  _______  _______  _______  ______   
|   | | ||    _ |  |   _   ||       ||       |       |       ||   |    |  | |  ||       ||       ||       ||    _ |  
|   |_| ||   | ||  |  |_|  ||    ___||_     _| ____  |       ||   |    |  | |  ||  _____||_     _||    ___||   | ||  
|      _||   |_||_ |       ||   |___   |   |  |____| |       ||   |    |  |_|  || |_____   |   |  |   |___ |   |_||_ 
|     |_ |    __  ||       ||    ___|  |   |         |      _||   |___ |       ||_____  |  |   |  |    ___||    __  |
|    _  ||   |  | ||   _   ||   |      |   |         |     |_ |       ||       | _____| |  |   |  |   |___ |   |  | |
|___| |_||___|  |_||__| |__||___|      |___|         |_______||_______||_______||_______|  |___|  |_______||___|  |_|

```
# Table Of Contents
- Servers
- Directories
- Setup
    - Initial Steps: 1- Certificates
        - Certificate Authority
        - Root Certificate
        - Intermediate Certificate
        - Kafka Server Certificates
        - Kafka Client Certificates
    - Initial Steps: 2- Java Trust & KeyStores
        - TrustStore
        - KeyStores
        - Verifiying Certificates
    - Initial Steps: 3- IPTables Rules
    - Initial Steps: 4- Creating a unit Service
    - Kafka & KRaft Setup
        - Installation
        - Server Basics
        - Socket Server Settings
        - Log Basics
        - number of partitions
        - Replicataion factor
        - Generating Cluster UUID
        - Formatting storage and log
        - Starting Kafka
- acknowledgment
    - Contributors
    - Links 

# Servers
- 192.168.9.194
- 192.168.9.195
- 192.168.9.196

# Directories
- ``` /opt/kafka_2.13-3.7.0/ ```
- Certificates: ``` /etc/ssl/kafka ``` 
- logs:
    - output of kafka Unit: ``` /var/kafka/kafka.log ```
    - KRaft log directory: ``` /var/kafka/kraft-combined-logs ```
 # Setup
 ## Initial Steps: 1- Certificates using openssl (method-1)

### Create Certification Authority key / cert pair

- Creates a ca.key and ca.crt file for the key and cert respectively. The private key will be used to sign the client & server certs. Both the Kafka server and clients will be configured to trust the ca.crt certificate as a certification authority (i.e. inherently trust any certificates signed by this CA)
```
$ openssl req -new -x509 -keyout ca.key -out ca.crt -days 365 -subj /CN=ca.kafka.sls.ir/OU=DevOps/O=SLS/L=Tehran/C=IR -passin pass:sls1234567 -passout pass:sls1234567
```

### Create server key / cert pair

- The result of the commands below are a keystore file containing a key/cert that is signed by the CA and a truststore file containing the CA cert (meaning the Kafka server will trust any client certs signed by the CA)

#### Create a private key
- method 1: 
```
$ sudo keytool -genkey -alias kafka-2 -dname "CN=kafka-2, OU=DevOps, O=SLS, L=Tehran, ST=Tehran, C=IR" -keystore kafka-2.keystore.jks -keyalg RSA -storepass sls1234567 -keypass sls1234567 && echo $?
```
- method 2: 
```
$ sudo keytool -keystore kafka-3.keystore.jks -alias kafka-3 -validity 3650 -genkey -storepass sls1234567 -keypass sls1234567 -dname "CN=kafka-3" -ext SAN=dns:kafka-3 -keyalg RSA -storetype pkcs12 && echo $?
```

- method 3: 
```
$ sudo keytool -genkey -alias kafka-3 -dname "CN=kafka-3, OU=DevOps, O=SLS, L=Tehran, ST=Tehran, C=IR" -ext SAN=DNS:kafka-3,IP:192.168.9.194 -keystore kafka-3.keystore.jks -keyalg RSA -storetype pkcs12 -storepass sls1234567 -keypass sls1234567 && echo $?
```

#### Create CSR
```
$ sudo keytool -keystore kafka-2.keystore.jks -alias kafka-2 -certreq -file kafka-2.csr -storepass sls1234567 -keypass sls1234567 && echo $?
```
#### Create cert signed by CA
```
$ sudo openssl x509 -req -CA ca.crt -CAkey ca.key -in kafka-2.csr -out kafka-2-ca1-signed.crt -days 9999 -CAcreateserial -passin pass:sls1234567 && echo $?
```

---
INSIDE EACH SERVER RUN:
---

#### Import CA cert into keystore
```
$ sudo keytool -keystore kafka-2.keystore.jks -alias CARoot -import -noprompt -file ca.crt -storepass sls1234567 -keypass sls1234567 && echo $?
```
#### Import signed cert into keystore
```
$ sudo keytool -keystore kafka-2.keystore.jks -alias kafka-2 -import -noprompt -file kafka-2-ca1-signed.crt -storepass sls1234567 -keypass sls1234567 && echo $?
```
#### import CA cert into truststore
```
$ sudo keytool -keystore kafka-2.truststore.jks -alias CARoot -import -noprompt -file ca.crt -storepass sls1234567 -keypass sls1234567 && echo $?
```

#### Copy to directory that is used as a docker volume
```
$ sudo chown -R kafka:kafka /etc/ssl/kafka/
$ sudo chmod -R 777 /etc/ssl/kafka/
```
 ## Initial Steps: 1- Certificates using cfssl (method-2)
 ### Certificate Authority

 - In order to create a CA, we install the *CFSSL toolkit* from https://github.com/cloudflare/cfssl as follows:
```
$ export VERSION=1.6.5 # See https://github.com/cloudflare/cfssl/releases
$ mkdir -p ~/.local/bin
$ curl -L https://github.com/cloudflare/cfssl/releases/download/v${VERSION}/cfssl_${VERSION}_linux_amd64 -o ~/.local/bin/cfssl
$ curl -L https://github.com/cloudflare/cfssl/releases/download/v${VERSION}/cfssljson_${VERSION}_linux_amd64 -o ~/.local/bin/cfssl-json
$ chmod +x ~/.local/bin/cfssl*
```

- As a best practice, we recommend creating a multi-tiered CA structure, including a root certificate and an intermediate certificate. While the root certificate can be kept offline and used only to sign or recoke intermediate certificates, the latter can be used for day-to-day operations i.e. to create our client-server certificates for mTLS. If an intermediate certificate has a security issue, it’s easier and less disruptive to revoke an intermediate certificate than a root certificate.

### Root Certificate

```
$ cat root-ca-csr.json

{
    "CN": "Kafka Root CA",
    "names": [{
        "C": "IR",
        "L": "Tehran",
        "O": "SLS",
        "OU": "DevOps",
        "ST": "Tehran"
    }],
    "key": {
        "algo": "rsa",
        "size": 4096
    }
    ,
    "ca": {
        "expiry": "87600h"
    }
}
```

```
$ cat root-ca-config.json

{
  "signing": {
    "profiles": {
      "intermediate_ca":
      {
          "ca_constraint": {
              "is_ca": true,
              "max_path_len": 0,
              "max_path_len_zero": true
          },
          "expiry": "87600h",
          "usages": [
              "signing",
              "digital signature",
              "key encipherment",
              "cert sign",
              "crl sign",
              "server auth",
              "client auth"
          ]
      }
    }
  }
}
```
- Generate the root certificate in out/root-ca.pem as:
```
$ mkdir out
$ cfssl gencert -initca root-ca-csr.json | cfssl-json -bare out/root-ca
```

### Intermediate Certificate
```
$ cat intermediate-ca-csr.json

{
    "CN": "Kafka Intermediate CA",
    "names": [{
        "C": "IR",
        "L": "Tehran",
        "O": "SLS",
        "OU": "DevOps",
        "ST": "Tehran"
    }],
    "key": {
        "algo": "rsa",
        "size": 4096
    }
    ,
    "ca": {
        "expiry": "87600h"
    }
}
```

```
$ cat intermediate-ca-config.json

{
  "signing": {
    "profiles": {
      "client":
      {
          "expiry": "87600h",
          "usages": [
              "signing",
              "key encipherment",
              "client auth"
          ]
      },
      "server":
      {
          "expiry": "87600h",
          "usages": [
              "signing",
              "key encipherment",
              "server auth",
              "client auth"
          ]
      }
    }
  }
}
```

- Generate and sign the intermediate certificate in out/intermediate-ca.pem as:
```
$ mkdir out
$ cfssl gencert -initca intermediate-ca-csr.json | cfssl-json -bare out/intermediate-ca
```

```
$ cfssl sign -ca out/root-ca.pem -ca-key out/root-ca-key.pem -config root-ca-config.json -profile intermediate_ca out/intermediate-ca.csr 2> intermediate-ca-sign.log | cfssl-json -bare out/intermediate-ca
```

- As it’s recommended to always include the full certificate chain, we create intermediate-full-chain.pem including both, the root and the intermediate certificate as follows:
```
$ cat out/root-ca.pem out/intermediate-ca.pem > out/intermediate-full-chain.pem
```

### Kafka Server Certificates
- In the next step, we create and sign server certificates for all Kafka nodes (i.e. kafka-1, kafka-2 and kafka-3). Make sure that you include the node name as common name (CN) and other hostnames that could be used to communicate in between your Kafka nodes in „Subject Alternative Name“ (SAN) of your certificate. In the CFSSL config, you need to add these hostnames to the hosts property.

- So let’s create the following CSR config for the *kafka-1* host:
```
$ cat kafka-1.csr.json

{
    "CN": "kafka-1",
    "names": [{
        "C": "IR",
        "L": "Tehran",
        "O": "SLS",
        "OU": "DevOps",
        "ST": "Tehran"
    }],
    "key": {
        "algo": "rsa",
        "size": 4096
    },
    "hosts": [
        "192.168.9.194","kafka-1","localhost"    
    ]
}
```
- Now let’s create a server certificate for *kafka-1*:
```
$ cfssl gencert -ca out/intermediate-ca.pem -ca-key out/intermediate-ca-key.pem -config intermediate-ca-config.json -profile server kafka-1-csr.json | cfssl-json -bare out/kafka-1
```
- This must be repeated for all Kafka nodes i.e. kafka-1, kafka-2 and kafka-3.

### Kafka Client Certificates
- Now we can create client certificates for the Kafka clients. For testing purpose, we will create two users: admin-1 and client-1. While we grant full access for the administrative user, the client will get limited access for a specific topic.

- Let’s create the CSR config for admin-1. Make sure that you include the username as common name (CN) in the certificate:
```
$ cat admin-1-csr.json

{
    "CN": "admin-1",
    "names": [{
        "C": "IR",
        "L": "Tehran",
        "O": "SLS",
        "OU": "DevOps",
        "ST": "Tehran"
    }],
    "key": {
        "algo": "rsa",
        "size": 4096
    }
        ,
    "hosts": []
}
```
- Create a client certificate for admin-1:
```
$ cfssl gencert -ca out/intermediate-ca.pem -ca-key out/intermediate-ca-key.pem -config intermediate-ca-config.json -profile client admin-1-csr.json | cfssl-json -bare out/admin-1
```
- This must be repeated for all users i.e. admin-1 and client-1.

## Initial Steps: 2- Java Trust & KeyStores
- Because it is Java and to increase the level of complexity (because it’s Java), we need to create Java Trust- and KeyStores for our CA certificate and for each of our certificates.

### TrustStore
- Let’s start with the TrustStore including a full-chain certificate of your authority as follows:
```
$ keytool -import -noprompt -keystore out/intermediate-full-chain.truststore.jks -alias intermediate-ca -trustcacerts -storepass a-very-secret-secret -file out/intermediate-full-chain.pem
```
### KeyStores
- We need to create a KeyStore for each certificate. To do so, we need to create a PKCS#12 archive first, including the certificate and its key as well as the full-chain certificate of the authority. So for kafka-1, we do as follows:
```
$ openssl pkcs12 -export -inkey out/kafka-1-key.pem -in out/kafka-1.pem -certfile out/intermediate-full-chain.pem -passout pass: -out out/kafka-1.p12
```

- Note that you could pass a password in -passout for this archive. But the Java KeyStore does also support a password protection, so we skip using a password for the PKCS#12 archive.

- Now we can create the Java KeyStore as follows:
```
$ keytool -importkeystore -noprompt -srckeystore out/kafka-1.p12 -srcstoretype pkcs12 -srcstorepass "" -destkeystore out/kafka-1.keystore.jks -deststorepass a-very-secret-secret 
```
- This must be repeated for all server certificates i.e. kafka-1, kafka-2, kafka-3 and for all client certificates i.e. admin-1 and client-1.

### Verifiying Certificates
- For Veriying Certificates are valid:
```
$ openssl verify -CAfile intermediate-full-chain.pem kafka-1.pem
```
## Initial Steps: 3- IPTables Rules
```
-A CHECK_INPUT -p tcp -m tcp --dport 9092 -j ACCEPT
-A CHECK_INPUT -p tcp -m tcp --dport 9093 -j ACCEPT
-A CHECK_INPUT -p udp -m udp --dport 9092 -j ACCEPT
-A CHECK_INPUT -p udp -m udp --dport 9093 -j ACCEPT
```

## Initial Steps: 4- Creating a unit Service
```
$ sudo nano /etc/systemd/system/kafka.service

[Unit]
Description=kafka-server

[Service]
Type=simple
User=kafka
ExecStart=/bin/sh -c '/opt/kafka_2.13-3.7.0/bin/kafka-server-start.sh /opt/kafka_2.13-3.7.>
RemainAfterExit=true
ExecStop=/opt/kafka_2.13-3.7.0/bin/kafka-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
```
## Kafka & KRaft Setup
- For demonstration purpose, we describe a manual deployment for the Kafka node kafka-1 on a Ubuntu 22.04 LTS. Further we assume that all nodes can reach each other using kafka-1, kafka-2 and kafka-3 i.e. by create corresponding DNS entries or adding the hosts to */etc/hosts*.

- Please keep in mind that the following steps must be repeated on all cluster nodes accordingly.
### Installation
```
$ apt update
$ apt install default-jre
$ curl -L https://downloads.apache.org/kafka/3.7.0/kafka_2.13-3.7.0.tgz -o /tmp/kafka.tgz
$ cd /opt
$ tar -xvzf /tmp/kafka.tgz
```
- Note, that we will run Kafka not as root but as dedicated user kafka, so let’s create the user as:
```
$ adduser --system --group kafka
```
- Let’s create the KRaft log directories (this is where Kafka stores the data) and grant access for the kafka user:
```
$ ls /etc/ssl/kafka/
kafka-1.keystore.jks  intermediate-full-chain.truststore.jks
```
- Since we want to use KRaft, the relevant configuration files are located in /opt/kafka_*/config/kraft. To configure the Kafka server (i.e. Broker and Controller), we need to modify the following parts of server.properties:

### Server Basics
```
$ sudo vim /opt/kafka_2.13-3.7.0/config/kraft/server.properties
```

```
# The role of this server. Setting this puts us in KRaft mode
process.roles=broker,controller

# The node id associated with this instance's roles
node.id=0

# The connect string for the controller quorum
controller.quorum.voters=0@kafka-1:9093,1@kafka-2:9093,2@kafka-3:9093
```

### Socket Server Settings
```
#     listeners = PLAINTEXT://your.host.name:9092
listeners=SSL://:9092,CONTROLLER://:9093

# Name of listener used for communication between brokers.
inter.broker.listener.name=SSL

# Listener name, hostname and port the broker will advertise to clients.
# If not set, it uses the value for "listeners".
advertised.listeners=SSL://kafka-1:9092

# A comma-separated list of the names of the listeners used by the controller.
# If no explicit mapping set in `listener.security.protocol.map`, default will be using PLAINTEXT protocol
# This is required if running in KRaft mode.
controller.listener.names=CONTROLLER

# Maps listener names to security protocols, the default is for them to be the same. See the config documentation for more details
listener.security.protocol.map=CONTROLLER:SSL,SSL:SSL
```

- Further include the path to the Trust- and Keystores and their secret as follows:
```
ssl.keystore.location=/etc/ssl/kafka/kafka-1.keystore.jks
ssl.keystore.password=sls1234567
ssl.truststore.location=/etc/ssl/kafka/kafka-1.truststore.jks
ssl.truststore.password=sls1234567
ssl.key.password=sls1234567
```

- Enforce clients that connect to the Kafka brokers must provide a valid client certificate for authentifcation:
```
ssl.client.auth=required
```

- Configure the Standard Authorizer to enable ACL based authorization. Further grant super user permission to the Kafka nodes and the admin-1 user:
```
authorizer.class.name=org.apache.kafka.metadata.authorizer.StandardAuthorizer
super.users=User:kafka-1;User:kafka-2;User:kafka-3;User:admin-1
```

- As an additional hardening, it might be clever to skip allowing everyone if no ACLs were found:
```
allow.everyone.if.no.acl.found=False
```
- Further you need to map the common name (CN) from the mTLS certificates to the Kafka username using ssl.principal.mapping.rules so that you can use the common name i.e. client-1 in your ACLs.


### Log Basics
- Make sure that you set the correct log dir path in log.dirs:

```
# A comma separated list of directories under which to store log files
log.dirs=/var/kafka/kraft-combined-logs
```

### number of partitions
- As the comment states, this configures each new topic’s default number of partitions. Since you have three nodes, set it to a multiple of two:
```
# The default number of log partitions per topic. More partitions allow greater
# parallelism for consumption, but this will also result in more files across
# the brokers.
num.partitions=6
```
- A value of 6 here ensures that each node will hold two topic partitions by default.

### Replicataion factor
- Next, you’ll configure the replication factor for internal topics, which keeps the consumer offsets and transaction states. Find the following lines:
```
offsets.topic.replication.factor=2
transaction.state.log.replication.factor=2
```
- Here, you specify that at least two nodes must be in sync regarding the internal metadata. When you’re done, save and close the file.


> Note that these steps must be repeated on each Kafka nodes i.e. kafka-1, kafka-2 and kafka-3.


### Generating Cluster UUID
- On 1 node:
```
$ KAFKA_CLUSTER_ID="$(/opt/kafka_2.13-3.7.0/bin/kafka-storage.sh random-uuid)"
$ echo $KAFKA_CLUSTER_ID
```
- On other nodes:
```
$ KAFKA_CLUSTER_ID="<UUID>"
```

### Formatting storage and log
```
$ sudo -u kafka /opt/kafka_2.13-3.7.0/bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c /opt/kafka_2.13-3.7.0/config/kraft/server.properties
```

### Starting Kafka
```
$ sudo systemctl start kafka
```
OR
```
$ sudo -u kafka /opt/kafka_2.13-3.7.0/bin/kafka-server-start.sh /opt/kafka_2.13-3.7.0/config/kraft/server.properties
```

- Logs of above command are insied ``` /var/kafka/kafka.log ```

# acknowledgment

## Contributors

APA 🖖🏻

## Links
- https://awesome-it.de/blog/apache-kafka-cluster-with-kraft-mtls/
- https://docs.confluent.io/platform/current/kafka/authentication_ssl.html
- https://github.com/MdAhosanHabib/kafka_SSL
- https://www.digitalocean.com/community/tutorials/introduction-to-kafka
- https://www.digitalocean.com/community/tutorials/how-to-set-up-a-multi-node-kafka-cluster-using-kraft#configuring-second-and-third-node
---
- https://dzone.com/articles/running-kafka-in-kubernetes-with-kraft-mode-and-ss
---
- https://learn.microsoft.com/en-us/azure/hdinsight/kafka/apache-kafka-ssl-encryption-authentication

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