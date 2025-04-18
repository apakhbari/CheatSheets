# Proxy
```
 _______  ______    _______  __   __  __   __ 
|       ||    _ |  |       ||  |_|  ||  | |  |
|    _  ||   | ||  |   _   ||       ||  |_|  |
|   |_| ||   |_||_ |  | |  ||       ||       |
|    ___||    __  ||  |_|  | |     | |_     _|
|   |    |   |  | ||       ||   _   |  |   |  
|___|    |___|  |_||_______||__| |__|  |___|  
```

## Container registries
- [registry.docker.ir](registry.docker.ir)
- [docker.arvancloud.ir](docker.arvancloud.ir)


- [https://github.com/myxuchangbin/dnsmasq_sniproxy_install](https://github.com/myxuchangbin/dnsmasq_sniproxy_install)


- add common sites to ` $ /etc/dnsmasq.d/custom_netflix.conf `, For example:
```
cloud.google.com/91.107.139.134
bogte.com/91.107.139.134
google.com/91.107.139.134
docs.google.com/91.107.139.134
meet.google.com/91.107.139.134
dev//91.107.139.134
microsoft.com/91.107.139.134
nuget.org/91.107.139.134
npmjs.org/91.107.139.134
org/91.107.139.134
gcr.io/91.107.139.134
docker.com/91.107.139.134
hub.docker.com/91.107.139.134
registry-1.docker.io/91.107.139.134
k8s.io/91.107.139.134
pkgs.k8s.io/91.107.139.134
packages.k8s.io/91.107.139.134
helm.sh/91.107.139.134
kubernetes.io/91.107.139.134
cloud.google.com/91.107.139.134
quay.io
```

- also add 
```
$ vim /etc/sniproxy.conf 

table {
  .* *
}

```

# Proxy docker
- put inside deamon.json

# proxy k8s

- [https://github.com/containerd/containerd/blob/main/docs/hosts.md](https://github.com/containerd/containerd/blob/main/docs/hosts.md)

- In containerd settings, search and edit this:
```
[plugins."io.containerd.grpc.v1.cri".registry]
config_path = "/etc/containerd/certs.d"
```

- This directories does not exist. create them. 
```
$ cat /etc/containerd/certs.d/docker.io/hosts.toml

server = "https://registry-1.docker.io"
host."https://registry.dokcer.ir".capabilities = ["pull", "resolve"]

$ restart containerd
```

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