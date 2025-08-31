# Certs
```
 _______  _______  ______    _______  _______ 
|       ||       ||    _ |  |       ||       |
|       ||    ___||   | ||  |_     _||  _____|
|       ||   |___ |   |_||_   |   |  | |_____ 
|      _||    ___||    __  |  |   |  |_____  |
|     |_ |   |___ |   |  | |  |   |   _____| |
|_______||_______||___|  |_|  |___|  |_______|
```

## Types
- PEM: Text
- DER: Binary (Windows)
- PKCS: Cert + PrivateKey

## Sample config.csr.conf
```
[ req ]
default_bits       = 2048
prompt             = no
default_md         = sha256
distinguished_name = dn
req_extensions     = v3_req

[ dn ]
CN = $domain_name
C = C
ST = ST
L = L
O = O
OU = OU

[ v3_req ]
keyUsage=keyEncipherment, dataEncipherment
extendedKeyUsage=serverAuth
subjectAltName = @alt_names

[ alt_names ]
IP.1 = 
IP.2 = 
DNS.1 = $domain_name
DNS.2 = www.$domain_name
```

## For creating a CERT without a privatekey passphrase
```
$ openssl req --out my.csr -new -newkey rsa:2048 -nodes (no passphrase for privatekey) -keyout private.key -config config.csr.conf
```

## For transforming cert.pem to cert.p12
```
$ openssl pkcs12 -export -in cert.pem -inkey private.key -out cert.p12
```
- Java apps usually work with PKCS12
- for most of Java apps we need a passphrase of 6 characters for our cert to work


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