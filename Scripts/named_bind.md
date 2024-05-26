Run the following command to check the syntax of the `named.conf*` files:

```
sudo named-checkconf
```

to check the “<mark data-color="rgba(255, 192, 1, 0.3)" style="background-color: rgba(255, 192, 1, 0.3); color: inherit">nyc3.example.com</mark>” forward zone configuration, run the following command (change the names to match your forward zone and file):

```
sudo named-checkzone nyc3.example.com db.nyc3.example.com
```

And to check the “<mark data-color="rgba(255, 192, 1, 0.3)" style="background-color: rgba(255, 192, 1, 0.3); color: inherit">128.10</mark>.in-addr.arpa” reverse zone configuration, run the following command (change the numbers to match your reverse zone and file):

```
sudo named-checkzone 128.10.in-addr.arpa /etc/bind/zones/db.10.128
```
