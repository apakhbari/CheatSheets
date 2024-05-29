# Nginx
```
 __    _  _______  ___   __    _  __   __ 
|  |  | ||       ||   | |  |  | ||  |_|  |
|   |_| ||    ___||   | |   |_| ||       |
|       ||   | __ |   | |       ||       |
|  _    ||   ||  ||   | |  _    | |     | 
| | |   ||   |_| ||   | | | |   ||   _   |
|_|  |__||_______||___| |_|  |__||__| |__|
```

# Table of Contents

- Theoritical
  - Nginx
  - Components
  - policies
  - Tips & Tricks
- Hands On
  - Directories
  - configs
  - commands
- acknowledgment

# Theoritical

## Nginx
- use cases:
    - Web Server
    - Reverse Proxy
    - Caching
    - Load Balancing
    - Media Streaming


```mermaid
graph TD;
    Master Process-->Worker-1;
    Master Process-->Worker-2;
    Master Process-->Worker-3;
    Master Process-->Worker-4;
    OS-->Worker1;
    OS-->Worker2;
    OS-->Worker3;
    OS-->Worker4;
```


# Hands On

## Directories
- Location of / --> ` /usr/share/nginx/html `

## configs

## commands
### Basic Commands
- Start Service
```
$ nginx start
```

- Stop Service
```
$ nginx stop
```

- Check Configuration is OK
```
$ nginx -t
$ nginx -T      # MORE INFORMATION
```

- Send Signals to process
```
$ nginx -s start/stop/reload
```


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
