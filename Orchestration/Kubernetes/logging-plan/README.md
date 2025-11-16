# Logging Plan on Kubernetes clusters
```
 ___   _   _____   _______        ___      _______  _______  _______  ___   __    _  _______ 
|   | | | |  _  | |       |      |   |    |       ||       ||       ||   | |  |  | ||       |
|   |_| | | |_| | |  _____|      |   |    |   _   ||    ___||    ___||   | |   |_| ||    ___|
|      _||   _   || |_____       |   |    |  | |  ||   | __ |   | __ |   | |       ||   | __ 
|     |_ |  | |  ||_____  |      |   |___ |  |_|  ||   ||  ||   ||  ||   | |  _    ||   ||  |
|    _  ||  |_|  | _____| |      |       ||       ||   |_| ||   |_| ||   | | | |   ||   |_| |
|___| |_||_______||_______|      |_______||_______||_______||_______||___| |_|  |__||_______|
```
## Table of contents


## Overview
## TL;DR (one-line plan)

Run a node-level log collector (DaemonSet — e.g. Fluent Bit) on the source cluster that enriches logs with Kubernetes metadata and ships them to a single Graylog GELF input. In Graylog use streams (or pipelines routing) keyed on the Kubernetes namespace field to separate projects, and set your index set rotation to daily to keep per-day indices.


### Why DaemonSet (recommended) vs sidecar per-pod

- DaemonSet collector (one pod per node) reads container logs from the node (e.g. /var/log/containers/*.log), enriches them with k8s metadata and ships them centrally. This is lightweight, simpler to manage, and scales automatically with nodes. Many production setups use Fluent Bit/Fluentd as DaemonSets to centralize K8s logs. 

- Sidecar per-pod forwards only that pod’s logs. Pros: isolation per-app; cons: huge operational overhead (every pod spec must include the sidecar), higher resource usage, complexity when pods are many/short-lived. Use sidecars only for very special per-pod transformations or security/isolation requirements.

### What to run on the collector
- Fluent Bit (lightweight, great for k8s) — it has a GELF output plugin to send to Graylog. 

- Alternatives: Fluentd, Filebeat, or Vector — all workable; Graylog accepts GELF/Beats/HTTP. Graylog supports Beats input and GELF HTTP/TCP/UDP inputs. 

## Step-by-step Hands-on
### A) Prepare Graylog (first)
1. Create a GELF input in Graylog:
    - `Graylog UI → System → Inputs` → choose GELF TCP or GELF HTTP (TCP is common and reliable; HTTP is firewall-friendly). Launch it on a port (e.g. 12201). Graylog’s GELF inputs accept standard container/app GELF messages. 

2. Optionally create a Beats input if you plan to use Filebeat/Winlogbeat. Graylog’s Beats input expects Beats/Logstash protocol (TCP). 

3. Ensure Graylog is reachable from your source Kubernetes cluster (network, DNS, TLS). If production, enable TLS on the input (use TLS termination or put Graylog behind a TLS LB).

### B) Deploy Fluent Bit as a DaemonSet (collector)
- a minimal example (ConfigMap + DaemonSet). You’ll adapt image versions, resources, securityContext, and TLS to your environment.

1. ConfigMap (fluent-bit config) — key ideas:
- Tail container logs (/var/log/containers/*.log)
- Add Kubernetes metadata (kubernetes filter)
- Output using the gelf plugin to Graylog host:port

2. DaemonSet (mount container logs + config) — simplified:

# acknowledgment
## Contributors
- APA 🖖🏻

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