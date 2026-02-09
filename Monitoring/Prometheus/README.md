# Prometheus


## Tips & Tricks
- Prometheus is pull based, prometheus has a push gateway add-on which can be used
- we have 2 different rules: record rule + alert rule. record rule is like a cache and alert rule is for alerting
- P8s use HTTP GET for scraping data



# Classes
## Session 1

## Session 2 - 
- Google's four golden signals to measure in monitoring systems:
  - Latency: The time it takes to service a request
  - Errors: Trend views of request error rate
  - Traffic: Demand being placed pn the system
  - Saturation: View of utilization against max capacity

- Prometheus is good for monitoring dynamic enviornments (like openstack, kubernetes, ...)
- It has a simple yet powerful data model and query language thatr lets you analyze your applications and infrastructure are performing
- software like kubernetes and doceker are already instrumented with prometheus client libraries
- for third-party software that exposes metrics in a non-Prometheus format, there are hundreds of integrations available these are called *exporters* and include HAProxy, MySQL, PostgreSQL, Redis, JMX, SNMP, Consul and Kafka
- for instrumenting your own code, there are client libraries on all the popular languages and runtimes including Go, Java/JVM, C#, .NET, Python, Ruby, Node.JS,Haskell, Erlang and Rust

- Prometheus is like sum of zabbix + snmp, it sends some http requests (called scrape) to its different exporters (such as apache, mysql, node exporter, ... which are on different ports) and gets values of them in return
- Prometheus has its own DB, called TSDB (Time series database)
- A simple text format makes it easy to expose metrics to Prometheus. Other monitoring systems, both open source and commercial, have added support for this format.
- The data model identifies each time series not just with a name, but also with an unordered set of key-value pairs called labels
- The promQL query language alows aggreagation across any of these labels, so you can analyze not just per process, but also per datacenter and per service or by any other labels that you have defined
- These can be graphed in dashboard systems such as grafana
- Labels make maintaining alerts easier, as you can create a single alert covering all possible label values
- A simple Prometheus server can ingest millions of samples per second
- All components os Prometheus can be run in containers

### Architecture
- P8s data is time series based. It is time based and have a few key:value metrics

- The *P8s server* collects time series data, stores it, makes it available for querying and sends alerts based on it
- the *Alertmanager* recieves alert triggers from p8s and handles routing and dispatching of alerts
- The *pushgateway* handles the exposition of metrics that have been pushed from short-lived jobs such as cron or batch jobs
- *applications* that support the p8s exposition format make internal state available through an HTTP endpoint
- *Community-driven* exporters expose metrics from applications that do not support p8s natively
- first-party and third-party dashboarding solutions provide a *visualization* of collected data


### Installing using package
- after downloading and unarchiving prometheus.tar.gz from its site, now we
```
$ useradd -r -s /sbin/nologin prometheus
$ mv prometheus /usr/local/bin
$ mkdir -p /etc/prometheus /var/lib/prometheus
$ chown prometheus. /etc/prometheus /var/lib/prometheus
$ cp prometheus promtool /usr/local/bin
$ cp -a console* /etc/prometheus
$ chown -R prometheus. /etc/prometheus
$ chown prometheus. /usr/local/prom*
```

- let's start with a basic configuration
```
$ vim /etc/prometheus/prometheus.yml

global:
  scrape_interval: 10s
scrape_configs:
  - job_name: Prometheus Server
    static_configs:
      - targets: ['localhost:9090']
```

- let's create its systemd unit
```
vim /usr/lib/systemd/system/prometheus.service

[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
--config.file /etc/prometheus/prometheus.yml \
--storage.tsdb.path /var/lib/prometheus
--web.console.templates=/etc/prometheus/consoles \
--web.console.libraries=/etc/prometheus/console_libraries
ExecReload=/usr/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target
```

## Session 3
### Data flow in Prometheus
#### Memory
- The freshest batch of data is kept in memory for up to 2 hours
- This approach dramatically reduces disk I/O: the most recent data is available in memory, making it fast to query + chunks of data are created in memry, avoiding constant disk writes
#### Write ahead log
- while in memory, data is not persisted and could be lost if the process terminates abnormally
- To prevent this scenario, a write-ahead log (WAL) in disk keeps the state of in-memory data so it can be replayed if p8s crashes or restarts
#### Disk
- After the 2 hour time window, the chunk get written to disk
- these chunks are immutable and, even though data can be deleted, it's not an atomic operation. Instead tombstone files are created with the information of the data that's no longer required
- The way data gets stored in p8s, is organized into a series of directories (blocks) containing the data chunks, the levelDB index for that data, a meta.json file with human readable information about the block, and tombstones for data that's no longer required. Each one of these blocks inside ` /var/lib/prometheus ` represents a database


- A time series in Prometheus is represented as follows:
` <metric_name>[{<label_1="value_1">,<label_N="value_N">}] <datapoint_numerical_value> `
- a metric name is the value of a special label calle ` "__name__" `
- remember that labels surronded by ` "__" ` are internal to prometheus
- every metric name in prometheus must match the following regex: ` [a-zA-z_:][a-zA-z0-9_:] *`
- samples are the collected data points, and they represent the numerical value of time series data
- the components that are required to define a sample are a float64 value, and a timestamp with milisecond precision. samples collected out of order will be discarded

- Cardinality problem: when you have label values that don't have a clear limit, which can increase indefinitely or above hundreds of posstivie values. These metrics might be better suited to be handled in logs-based systems. like email adresses, usernames, request/process/order/transiction ID . instead we might be do count of emails

- Four core Metric Types
  - Counters
  - Gauges
  - Histograms
  - Summaries

#### Counter
- this is strictly *cumulative* metric whose value can only increase. the only exception for this rule is when the metric is reset, which brings it back to zero
- THis is one of the most useful metric types because even if a scrape fails, you won't lose the cumulative increase in the data, which will be availale on the next scrape
- To be clear, in the case of a failed scarpe, granularity would be lost as fewer points will be saved

#### Gague
- A gauge is a metric that snapshots a given measurment at the time of collection, which can increase or decrease (such as temrature, disk space and memory usage)
- If a scrape failes, you will lose that sample, as the next scrape might encounter the metric on a different value

#### Histogram
 recording numerical data that's inherent to each event in a system can be expensive, so some sort of pre-aggregation is usually needed tp conserver at least partial information about what happened
 - However, by pre-calculating aggregations on each instance, a lot of granularity is lost and some calculations can be computationally costly. Also a lot of pre-aggregations can't generally be re-aggregated without losing meaninig
 - Histograms allows you to retain some granularity by counting events into buckets that are configurable on the client side, and also by providing a sume of all observed values

#### Summary
- Summaries are similar to histograms in some ways, but present different trade-offs and are generally less useful
- They are also used to track sizes and latencies, and also provide both a sum and a count of observed events
- summaries can also provide pre-calculated quantiles over a predetermined sliding time windoes
- The main reason to use summary quantiles is when accurate quantile estimation is needed, irrespective of this distribition and range of the observed events
- doing these calculations on the client side also means that the instrumentation and computational cost is a lot higher
- the last downside to mention is that the resulting quantiles are not aggregabel and thus of limited usefulness
- One benefit of summaries is that, without quantiles, they are quite cheap to generate, collect and store

#### Longitudinal and cross-sectional aggregations
- one of core strengths of p8s is that it makes the manipulation of time series data easy, and this slicing and dicing of data usually boils down to two kinds of aggregations, which are often used together: Longitudinal and cross-sectional aggregations
- Some of the most common aggregation functions in time series databases are minimum, maximum, average, count and sum

### Config file
- p8s configuration file can be split into following sections:
  - global
  - scrape_configs
  - alerting
  - rule files
  - remote read
  - remote write

- there is a rule that define:  ` scrape interval = max(half(lookback delta)) ` so if we lost 1 scrape, we still have 1 other scrape from before to show for our metric 

### Installing & Configuring node exporter 
- after downloading and unarchiving node_exporter.tar.gz from its site, now we
```
$ useradd -r -s /sbin/nologin node_exporter
$ mv node_exporter /usr/local/bin
$ chown prometheus. /usr/local/bin/node_exporter
$ cp prometheus promtool /usr/local/bin

$ mkdir -p /etc/prometheus /var/lib/prometheus 
$ cp -a console* /etc/prometheus
$ chown -R prometheus. /etc/prometheus
$ chown prometheus. /usr/local/prom*
```

- let's create its systemd unit
```
$ vim /usr/lib/systemd/system/node_exporter.service

[Unit]
Description=node_exporter
Wants=network-online.target
After=network-online.target

[Service]
User=exporter
Group=exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
ExecReload=/usr/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target
```

## Session 4
- A node_exporter has multiple collectors, which give them a modular architecture, some of them are enabled by default, but can be customized. for enabling it ` --collector.<name> ` and for disabling it ` --no-collector.<name> ` 

### Blackbox exporter
1. HTTP request with parameters like target address and probe type
2. Probe is launched against target
3. Probe returns data to be processed
4. HTTP response with promethes format metrics from the probe data

```
Prometheus <==> blackbox_exporter <==> target
```

- probe-based monitoring for http, tcp, icmp, port connectivity, SNMP and this kind of network connections are with Blackbox_exporter
- blackbox_exporter is powerful in ways that can send requests, then set what expects to recieve, then send an other request based on what it gets
- We can monitor what is needed using ` /etc/prometheus/prometheus.yml ` it is like ` curl -s "https://127.0.0.1:9115/probe?module=http_2xx&target=www.anisa.co.ir" `
```
$ vim /etc/prometheus/prometheus.yml

global:
  scrape_interval: 10s
scrape_configs:
  - job_name: Prometheus Server
    static_configs:
      - targets: ['localhost:9090']
  - job_name: Node Exporter
    static_configs:
      - targets:
        - localhost:9100
        - 192.168.1.201:9100
  - job_name: Blackbox Exporter - Web Monitoring
    metrics_path: /probe
    params:
      module: ['http_2xx']
      target: ['www.anisa.co.ir']
    static_configs:
      - targets: ['localhost:9115']
```

- And if we want to monitor multiple targets:
```
$ vim /etc/prometheus/prometheus.yml

global:
  scrape_interval: 10s
scrape_configs:
  - job_name: Prometheus Server
    static_configs:
      - targets: ['localhost:9090']
  - job_name: Node Exporter
    static_configs:
      - targets:
        - localhost:9100
        - 192.168.1.201:9100
  - job_name: Blackbox Exporter - Web Monitoring
    metrics_path: /probe
    params:
      module: ['http_2xx']
      targets: 
        - 'www.anisa.co.ir'
        - 'www.google.com'
        - 'www.prometheus.io'
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: localhost:9115
```


## Session 5
### Labels
- Labels are a key part of p8s
- Labels are key-value pairs associated with time series that, in addition to the metric name, uniquely identify them
- If you had a metric for HTTP requests that was broken out by path, you might try putting the path in the metric name: ` http_requests_login_total , http_requests_logout_total ` but it would be hard to work in PromQL. In order to calculate the total requests you would need to know every possible HTTP path.
- Instead, to handle this common use case, p8s has labels.
  - ` http_requests_total(path="/login") `
  - `  http_requests_total(path="/logout")  `

- We have two kinds of labels:
  - Instrumentation Label: Deafult labels of metrics 
  - Target Label: Based on target we have, Which job, instance it is

- p8s only supports 64-bit floating numbers as time series values, not any other data types such as strings
- But label valuesa re strings, and there are ceratin limited use cases where it is okay to (ab)use them without getting too far into log based monitoring

### PromQL
- PromQL is p8s query language. while it ends in QL, you will find that it is not SQL-like.
- Labels are a key part of PromQL, and you can use them not only to do arbitrary aggregataion but also to join different metrics together for arithmetic operations

### Aggregation
- Gauges are a snapshot of state, and usually when aggregating them you want to take a sum, average, min and max.
- calculate total filesystem size on each machine with
```
sum without (device, fstype, mountpoint)(node_filesystem_size_bytes)
```
- It is better to do this form of prompt ` sum without(mode)(rate(node_cpu_seconds_total[1m])) `
- A summary metric will usually contain both a _sum and _count and sometimes a time series with no suffix with quantile lebel

- getting avereage of http_request_duration_seconds
```
sum(rate(prometheus_http_request_duration_seconds_sum[1m])) / sum(rate(prometheus_http_request_duration_seconds_count[1m]))
```

- An example. We have a number of a 20 persons class's grades. lets have some calculations
```
10-12   4   <=12:   4
12-14   2   <=14:   6
14-16   5   <=16:   11
16-18   4   <=18:   15
18-20   5   <=20:   20

score_sum=315
score_count=20
score_bucket{le="12"} 4   #le = less equal
score_bucket{le="14"} 6
score_bucket{le="16"} 11
score_bucket{le="18"} 15
score_bucket{le="+inf"}  20   #+inf = to infinity

histogram(quantile(0.9,rate(score_bucket[1m])))  => It is a estimation for 90% of grades. a number that only 10% of grades are above it
```

- Matchers in Promql
  - "=" --> used for exactly. we can also do {foo=""}, {foo!=""}, {foo=~".*"}

## Session 6
### Aggregation Operators
- we have 11 operators
- we have 2 optional clauses: without & by

- a data set for example
```
process_cpu_seconds_total{cpu="0", instance="localhost:9090", job="prometheus", mode="idle"}	134752.1
process_cpu_seconds_total{cpu="1", instance="api.eniac-tech.com", job="cashless-prod", mode="user"}	4167.92
process_cpu_seconds_total{cpu="0", instance="vms.kishcharge.ir", job="vms-prod", mode="irq"}	6575.362494
process_cpu_seconds_total{cpu="2", instance="192.168.34.101:32063", job="vms", mode="idle"}	6539.28341
process_cpu_seconds_total{cpu="2", instance="192.168.51.34:2411", job="switch-stage", mode="steal"}	393.84999999999997
process_cpu_seconds_total{cpu="1", instance="192.168.33.34:2411", job="switch-prod", mode="idle"} 2115.61
```

- when we use ` without clause ` for ` job ` it means just ignore job completly, like it does not exists
```
sum without(mode) (rate(process_cpu_seconds_total{mode!="idle"}[1m]))  --> first this executes (rate(process_cpu_seconds_total{mode!="idle"}[1m]) then sum without(mode)
```

- when we use ` by clause ` it means like a ` group by `  in SQL
```
sum by(cpu,instance) (rate(process_cpu_seconds_total{mode!="idle"}[1m]))
```

- ` rate ` is like ` divide by time /T `


S6
00:23
Add contents to prometheus.md

## Session 7
## Session 8
## Session 9
## Session 10
## Session 11
## Session 12
## Session 13
## Session 14
## Session 15
## Session 16


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