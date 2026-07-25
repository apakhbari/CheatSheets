# Nexus Repo

## Table of contents
- Different Repos
- Initializing

## Different Repos
1. Hosted
- Hosted repos are isolated among themselves
- what is built inside organization
- Intrenal artifact of organization

2. Proxy
- Caching
- A middle-ware between organization and external repos

3. Group 
- Aggregated Hosted + Proxy repos in a single address

- Each Repo has a format, for example APT, Npm, Maven, Docker, ...

## Initializing
- For Nexus repo you need to have a grasp of some metrics, requests/hour requests/day DB
- Questions to ask for reference architecture:
    - whether nexus is only proxy or not?
    - How many CI/CD we have?
    - How many active developers we have?
    - Do we have Anonymous access?
- Nexus has 4 different architectures, 2 of them are community editions and 2 are ernterprise. visit their site for more info

- Dedicated service install or container-based


# acknowledgment
## Contributors

APA 🖖🏻

## Links
- https://youtu.be/f931M4-my1k?si=VmJDw8XDaSAA8h5-

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