## Craete Certificate with DNS Challenge
```
$ sudo certbot certonly --manual --preferred-challenges=dns \
-d yourdomain.com -d *.yourdomain.com
```

## Automate the renewal:
```
$ sudo certbot renew --dry-run
```

# View
## Viewing the cert.pem File
```
$ openssl x509 -in /path/to/cert.pem -text -noout
```

## Viewing the fullchain.pem File
The fullchain.pem file contains the full certificate chain, which includes the public certificate (cert.pem) along with intermediate and root certificates. To view it:

```
$ openssl x509 -in /path/to/fullchain.pem -text -noout
```

Since fullchain.pem may contain multiple certificates, you can use the following command to view each certificate in the chain separately:

```
$ awk 'BEGIN {c=0;} /-----BEGIN CERTIFICATE-----/ {c++} { print > "cert" c ".pem"}' < /path/to/fullchain.pem
```

This will split fullchain.pem into separate certificate files (cert1.pem, cert2.pem, etc.). You can then inspect each certificate individually using:

```
$ openssl x509 -in cert1.pem -text -noout
$ openssl x509 -in cert2.pem -text -noout
```