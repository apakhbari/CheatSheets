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
- Setup
- Initial Steps
    - Certificate Authority

 # Setup
 ## Initial Steps - Certificates
 ### Certificate Authority

 - In order to create a CA, we install the CFSSL toolkit from https://github.com/cloudflare/cfssl as follows:
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
cat root-ca-csr.json
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
cat root-ca-config.json
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
cat intermediate-ca-csr.json
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
cat intermediate-ca-config.json
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
cat kafka-1.csr.json
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
        "192.168.9.194","localhost"    
    ]
}
```
-Now let’s create a server certificate for *kafka-1*:
```
$ cfssl gencert -ca out/intermediate-ca.pem -ca-key out/intermediate-ca-key.pem -config intermediate-ca-config.json -profile server kafka-1-csr.json | cfssl-json -bare out/kafka-1
```
- This must be repeated for all Kafka nodes i.e. kafka-1, kafka-2 and kafka-3.

### Kafka Client Certificates
- Now we can create client certificates for the Kafka clients. For testing purpose, we will create two users: admin-1 and client-1. While we grant full access for the administrative user, the client will get limited access for a specific topic.

- Let’s create the CSR config for admin-1. Make sure that you include the username as common name (CN) in the certificate:
```
cat admin-1-csr.json
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

### Java Trust- & KeyStores
- Because it is Java and to increase the level of complexity (because it’s Java), we need to create Java Trust- and KeyStores for our CA certificate and for each of our certificates.

### TrustStore
- Let’s start with the TrustStore including a full-chain certificate of your authority as follows:
```
$ keytool -import -noprompt -keystore out/intermediate-full-chain.truststore.jks -alias intermediate-ca -trustcacerts -storepass a-very-secret-secret out/intermediate-full-chain.pem
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

- For Veriying Certificate is valid:
```
$ openssl verify -CAfile intermediate-full-chain.pem kafka-1.pem
```
### IPTables Rules
```
-A CHECK_INPUT -p tcp -m tcp --dport 9092 -j ACCEPT
-A CHECK_INPUT -p tcp -m tcp --dport 9093 -j ACCEPT
-A CHECK_INPUT -p udp -m udp --dport 9092 -j ACCEPT
-A CHECK_INPUT -p udp -m udp --dport 9093 -j ACCEPT
```


### Creating a unit Service
```
$ sudo nano /etc/systemd/system/kafka.service
```

```
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

### Generating UUID
- On 1 node:
```
$ KAFKA_CLUSTER_ID="$(/opt/kafka_2.13-3.7.0/bin/kafka-storage.sh random-uuid)"
$ echo $KAFKA_CLUSTER_ID
```
- - On other nodes:
```
KAFKA_CLUSTER_ID="<UUID>"
```

### Formatting storage and log
```
$ sudo -u kafka /opt/kafka_2.13-3.7.0/bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c /opt/kafka_2.13-3.7.0/config/kraft/server.properties

```

# acknowledgment

## Contributors

APA 🖖🏻

## Links
- https://awesome-it.de/blog/apache-kafka-cluster-with-kraft-mtls/
- https://docs.confluent.io/platform/current/kafka/authentication_ssl.html
- https://github.com/MdAhosanHabib/kafka_SSL
- system service: https://www.digitalocean.com/community/tutorials/introduction-to-kafka
- https://www.digitalocean.com/community/tutorials/how-to-set-up-a-multi-node-kafka-cluster-using-kraft#configuring-second-and-third-node

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
