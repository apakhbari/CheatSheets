# named_bind
```
 _______  ___   __    _  ______  
|  _    ||   | |  |  | ||      | 
| |_|   ||   | |   |_| ||  _    |
|       ||   | |       || | |   |
|  _   | |   | |  _    || |_|   |
| |_|   ||   | | | |   ||       |
|_______||___| |_|  |__||______| 

```

## Tips & Tricks
- DNS is UDP but recursor/cache-only DNS are TCP

## Hands-on

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


# acknowledgment
## Contributors

APA 🖖🏻

## Links


## APA, Live long & prosper
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