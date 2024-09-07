## Craete Certificate with DNS Challenge
```
$ sudo certbot certonly --manual --preferred-challenges=dns \
-d yourdomain.com -d *.yourdomain.com
```

## Automate the renewal:
```
$ sudo certbot renew --dry-run
```

