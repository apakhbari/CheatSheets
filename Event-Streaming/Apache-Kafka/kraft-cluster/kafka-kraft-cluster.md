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
        "C": "DE",
        "L": "Karlsruhe",
        "O": "awesome information technology GmbH",
        "OU": "IT",
        "ST": "Baden-Wuerttemberg"
    }],
    "key": {
        "algo": "rsa",
        "size": 4096
    },
    "hosts": [
        "kafka-1.example.com","localhost"    
    ]
}
```
-Now let’s create a server certificate for *kafka-1*:
```
$ cfssl gencert -ca out/intermediate-ca.pem -ca-key out/intermediate-ca-key.pem -config intermediate-ca-config.json -profile server kafka-1-csr.json | cfssl-json -bare out/kafka-1
```
- This must be repeated for all Kafka nodes i.e. kafka-1, kafka-2 and kafka-3.

### Kafka Client Certificates
```

```



# acknowledgment

## Contributors

APA 🖖🏻

## Links
- https://awesome-it.de/blog/apache-kafka-cluster-with-kraft-mtls/
- https://docs.confluent.io/platform/current/kafka/authentication_ssl.html

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