# Prometheus


## Tips & Tricks
- Prometheus is pull based, prometheus has a push gateway add-on which can be used

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

02:06

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

S3
53:00
Add contents to prometheus.md

## Session 4
## Session 5
## Session 6
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