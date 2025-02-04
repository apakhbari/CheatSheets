# Grafana

```
 _______  ______    _______  _______  _______  __    _  _______ 
|       ||    _ |  |   _   ||       ||   _   ||  |  | ||   _   |
|    ___||   | ||  |  |_|  ||    ___||  |_|  ||   |_| ||  |_|  |
|   | __ |   |_||_ |       ||   |___ |       ||       ||       |
|   ||  ||    __  ||       ||    ___||       ||  _    ||       |
|   |_| ||   |  | ||   _   ||   |    |   _   || | |   ||   _   |
|_______||___|  |_||__| |__||___|    |__| |__||_|  |__||__| |__|
```

**Course https://www.udemy.com/course/grafana-tutorial/**

**https://sbcode.net/grafana/add-ssl/**

https://sbcode.net/zabbix/iptables-cheatsheet/

`$ ls | sed 's/.\{4\}$//' | sed 's/^.\{4\}//' | sed 's/^/### /'`

# Table of Contents

- setup
- MYSQL
- Loki
- Prometheus
- Influxdb
- zabbix
- Elasticsearch

## Setup

### Installing grafana

- on ubuntu:

```
sudo apt update
sudo apt-get install -y adduser libfontconfig1 musl
wget https://dl.grafana.com/oss/release/grafana_8.2.3_amd64.deb
sudo dpkg -i grafana_8.2.3_amd64.deb

```

- The installation has now completed. You can now start the Grafana service & Check the status

```
sudo service grafana-server start
sudo service grafana-server status

```

- Your Grafana server will be hosted at --> http://[your Grafana server ip]:3000
- user: admin - password: admin

### point domain name

- set a DNS record for your ip address

### Reverse Proxy Grafana with Nginx

- install ngninx
- CD to the Nginx sites-enabled folder & Create a new Nginx configuration for Grafana

```
cd /etc/nginx/sites-enabled
sudo nano YOUR-DOMAIN-NAME.conf
```

- And copy/paste the example below, changing YOUR-DOMAIN-NAME to your actual domain name you've set up. Mine was grafana.sbcode.net.

```
server {
    listen 80;
    listen [::]:80;
    server_name  YOUR-DOMAIN-NAME;

    location / {
        proxy_set_header Host $http_host;
        proxy_pass           http://localhost:3000/;
    }
}
```

- Save and restart Nginx

```
sudo service nginx restart
sudo service nginx status
```

Test it by visiting again --> http://YOUR-DOMAIN-NAME

- Visiting your IP address directly will still show the default Nginx welcome page. If you don't want this to happen, then you can delete its configuration using the command below.

```
rm /etc/nginx/sites-enabled/default
```

### Add SSL

### Reset Password

- If you forgot your password then you can reset it using the grafana-cli command

```
grafana-cli --homepath "/usr/share/grafana" admin reset-admin-password admin
```

- Your username/password will now be admin/admin

### Create out First Data Source

### Panel Rows

### Panel Presentation Options

### Graph Panel \_ Visualisation Options

### Graph Panel \_ Fields & Overrides

### Graph Panel \_ Transformations

### Course Update Notice

### Stat Panel

### Gauge Panel

### Bar Gauge Panel

### Table Panel

## MySQL

### Create a MySQL Data Source

- Install mysql

```
sudo apt update
sudo apt install mysql-server
sudo service mysql status
```

- Now that we have a MySQL server, we will install a dedicated collector for it that will periodically gather statistics about the MySQL server and store them into a table containing rows with times and values (my2.status)

- The dashboard will be the popular 2MySQL Simple Dashboard (7991) that you can download from https://grafana.com/grafana/dashboards?dataSource=mysql

- The collector script that I will use can be downloaded from https://github.com/meob/my2Collector

- I have MySQL 8.#.#, so I will download the file called my2_80.sql. If you have MySQL 5, then download my2.sql

```
wget https://raw.githubusercontent.com/meob/my2Collector/master/my2_80.sql
```

- Open the script that was downloaded

```
sudo nano my2_80.sql
```

- Find these lines at the end of the script where it creates a specific user,

```
-- Use a specific user (suggested)
-- create user my2@'%' identified by 'P1e@seCh@ngeMe';
-- grant all on my2.* to my2@'%';
-- grant select on performance_schema.* to my2@'%';
```

- uncomment and change the password to something that you think is better. E.g.,

```
-- Use a specific user (suggested)
create user my2@'%' identified by 'password';
grant all on my2.* to my2@'%';
grant select on performance_schema.* to my2@'%';
```

- Save the changes and then run the SQL script,

```
mysql < my2_80.sql
```

- Now open MySQL and do some checks.

```
mysql

> show databases;
> show variables where variable_name = 'event_scheduler';
> select host, user from mysql.user;
> use my2;
> show tables;
> select * from current;
> select * from status;
> quit
```

- If when running the above lines, it shows that the event_scheduler is not enabled, then we will need to enable it so that the collector runs in the background. You can do this by editing the my.cnf file

```
sudo nano /etc/mysql/my.cnf
```

- Add lines to the end of the file

```
[mysqld]
event_scheduler = on
```

- Save and restart MySQL.

```
sudo service mysql restart
```

- We will create a specific user that can read the my2 database with select permissions only. We won't use the my2 user we created earlier since it has more permissions than our Grafana server actually needs.

```
mysql
> CREATE USER 'grafana'@'###.###.###.###' IDENTIFIED BY 'password';
> GRANT SELECT ON my2.* TO 'grafana'@'###.###.###.###';
> FLUSH PRIVILEGES;
> quit
```

- Note that we have now added 2 extra database users,

  - grafana@localhost : Used by the Grafana dashboard, to query the collected data from the MySQL server. This user has been granted the SELECT privilege only.
  - my2@localhost : Used by the MySQL event scheduler to collect statistics and save them into the DB for use by the Grafana dashboard. This user has been granted ALL privileges.

- If you installed your MySQL onto a different server, then by default it will not allow external connections. To allow remote connections on the MySQL server.

```
sudo nano /etc/mysql/my.cnf
```

- Change the bind address to 0.0.0.0 or add this text below to the end of the file if it doesn't already exist.

```
[mysqld]
bind-address    = 0.0.0.0
```

- Save and restart MySQL.

```
sudo service mysql restart
```

- Save the data source in Grafana and the connection should now be ok.
- We can do a quick test using the Explore option on Grafana. Open the Explore tab, select the MySQL data source and use this query below.

```
SELECT
  variable_value+0 as value,
  timest as time_sec
FROM my2.status
WHERE variable_name='THREADS_CONNECTED'
ORDER BY timest ASC;
```

#### Firewall

- If your MySQL and Grafana servers are on different servers, then you will need to allow incoming connections on port 3306. If using an unrestricted Ubuntu server as I do, port 3306 will already be allowed. Depending on your cloud provider, you may need to manually create a rule to allow incoming connections on port 3306. You can also restrict the connecting IP address or domain that can connect if you want.
- On my MySQL server, I can run these iptables rules to restrict incoming connections to port 3306 only for my Grafana server.

```
iptables -A INPUT -p tcp -s <your Grafana servers domain name or ip address> --dport 3306 -j ACCEPT
iptables -A INPUT -p tcp --dport 3306 -j DROP
iptables -L
```

- **IMPORTANT**: iptables settings will be lost in case of system reboot. You will need to reapply them manually, or
- install **iptables-persistent**

```
sudo apt install iptables-persistent
```

- This will save your settings into two files called,
  `/etc/iptables/rules.v4`
  `/etc/iptables/rules.v6`

- Any changes you make to the iptables configuration won't be auto saved to these persistent files, so if you want to update these files with any changes, then use the commands,

```
iptables-save > /etc/iptables/rules.v4
iptables-save > /etc/iptables/rules.v6
```

#### Troubleshooting

##### ERROR : db query error: query failed

- If when connecting to a MySQL data source, you see the error `db query error: query failed - please inspect Grafana server log for details.`

- You can tail the Grafana log using the command

```
tail -f /var/log/grafana/grafana.log
```

- Your error may be directly visible in the output of the above command, if not, try to connect again using the MySQL data sources Save & Test button, and look for the error as it is logged in real time.

- If the error is similar to `"Error 1045: Access denied for user 'grafana'@'[IP ADDRESS OF YOUR GRAFANA SERVER]' (using password: YES)"`, then you haven't added the user to MySQL correctly.

- When you add the "read only" user to MySQL, you indicate which IP addresses the user is connecting from and which objects it is allowed to read.

- E.g., If your Grafana servers IP Address is 10.20.30.40, and that is the IP address that the MySQL server will get the connection attempt from, then the MySQL commands to create the user and allow read on the tables are,

```
> CREATE USER 'grafana'@'10.20.30.40' IDENTIFIED BY 'password';
> GRANT SELECT ON my2.* TO 'grafana'@'10.20.30.40';
> FLUSH PRIVILEGES;
```

- If you installed MySQL locally on the same server as your Grafana server, then it would connect using localhost, so your commands would then be

```
> CREATE USER 'grafana'@'localhost' IDENTIFIED BY 'password';
> GRANT SELECT ON my2.* TO 'grafana'@'localhost';
> FLUSH PRIVILEGES;
```

##### ERROR : SET PASSWORD has no significance for user 'root'@'localhost'

##### ERROR : Duplicate key name 'idx01'

### Install a MySQL Dashboard and Collector

### Create a Custom MySQL Time Series Query

### Graphing Non Time Series SQL Data in Grafana

### Logs Panel

## Loki

### Install Loki Binary and Start as a Service

- To keep this as simple as possible, we will install the Loki binary as a service on our existing Grafana server.
- To check the latest version of Grafana Loki, visit the Loki releases page. https://github.com/grafana/loki/releases/

```
cd /usr/local/bin
curl -O -L "https://github.com/grafana/loki/releases/download/v2.4.1/loki-linux-amd64.zip"
```

- Now unzip the downloaded file,

```
apt install unzip
unzip "loki-linux-amd64.zip"
```

- And allow execute permission on the Loki binary

```
chmod a+x "loki-linux-amd64"
```

#### Create the Loki config

- Now create the Loki config file.

```
sudo nano config-loki.yml
```

- And add this text. This default configuration was copied from https://raw.githubusercontent.com/grafana/loki/master/cmd/loki/loki-local-config.yaml. There may be changes to this config depending on any future updates to Loki.

```
auth_enabled: false

server:
  http_listen_port: 3100
  grpc_listen_port: 9096

common:
  path_prefix: /tmp/loki
  storage:
    filesystem:
      chunks_directory: /tmp/loki/chunks
      rules_directory: /tmp/loki/rules
  replication_factor: 1
  ring:
    kvstore:
      store: inmemory

schema_config:
  configs:
    - from: 2020-10-24
      store: boltdb-shipper
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h

ruler:
  alertmanager_url: http://localhost:9093
```

#### Configure Loki to run as a service

- Now we will configure Loki to run as a service so that it stays running in the background.
- Create a user specifically for the Loki service

```
sudo useradd --system loki
```

- Create a file called loki.service

```
sudo nano /etc/systemd/system/loki.service
```

- Add the script and save

```
[Unit]
Description=Loki service
After=network.target

[Service]
Type=simple
User=loki
ExecStart=/usr/local/bin/loki-linux-amd64 -config.file /usr/local/bin/config-loki.yml

[Install]
WantedBy=multi-user.target
```

- Now start and check the service is running.

```
sudo service loki start
sudo service loki status
```

- If you reboot your server, the Loki Service may not restart automatically. You can set the Loki service to auto restart after reboot by entering,

```
sudo systemctl enable loki.service
```

#### Configure Firewall

- When your Loki server is running, it may be accessible remotely on port 3100. If you only want localhost to be able to connect, then type

```
iptables -A INPUT -p tcp -s localhost --dport 3100 -j ACCEPT
iptables -A INPUT -p tcp --dport 3100 -j DROP
iptables -L
```

- After blocking port 3100 for external requests, you can verify that local request are still possible by using,

```
curl "127.0.0.1:3100/metrics"

```

- Also, Loki exposes port 9096 for gRPC communications. This port may also be accessible across the internet. To close it using iptables, then use,

```
iptables -A INPUT -p tcp -s <your grafana servers domain name or ip address> --dport 9096 -j ACCEPT
iptables -A INPUT -p tcp -s localhost --dport 9096 -j ACCEPT
iptables -A INPUT -p tcp --dport 9096 -j DROP
iptables -L
```

- **IMPORTANT**: iptables settings will be lost in case of system reboot. You will need to reapply them manually, or
- install **iptables-persistent**

```
sudo apt install iptables-persistent
```

- This will save your settings into two files called,
  `/etc/iptables/rules.v4`
  `/etc/iptables/rules.v6`

- Any changes you make to the iptables configuration won't be auto saved to these persistent files, so if you want to update these files with any changes, then use the commands,

```
iptables-save > /etc/iptables/rules.v4
iptables-save > /etc/iptables/rules.v6
```

#### Troubleshooting

##### Permission Denied, Internal Server Error

- If you get any of these errors

  - `Loki: Internal Server Error. 500. open /tmp/loki/index/index_2697: permission denied`
  - `"failed to flush user" "open /tmp/loki/chunks/...etc : permission denied"`
  - `Loki: Internal Server Error. 500. Internal Server Error"`

- You should check the owner of the folders configured in the storage_config section of the the config-loki.yml to match the name of the user configured in the loki.service script above.

- My user is loki, and the folders begins with /tmp/loki so I recursively set the owner.

```
chown -R loki:loki /tmp/loki
```

- You may need to restart the Loki service and checking again its status.
- If when connecting to Loki using the Grafana data source configuration, you see the error "Loki: Bad Gateway. 502. Bad Gateway", this will happen if the Loki service is not running, your have entered the wrong URL, or ports are blocked by a firewall. The default Loki install uses both ports 3100 for HTTP and 9096 for gRPC. See my iptables rules above for my explicit rules which I've setup on my Grafana server that is also hosting the Loki service.

##### Data source connected, but no labels received

- When connecting to your Loki data source for the first time, you may see the error,
  - Data source connected, but no labels received. Verify that Loki and Promtail is configured properly.
- Note how it says, Data source connected at the beginning of the warning. Recent versions of Loki, despite having a successful connection, will still indicate that you have no labels because you don't have Promtail sending any data to it yet. Promtail is set up and discussed in the next lesson.

##### Unable to connect with Loki. Please check the server logs for more details

- To view the Grafana server logs,

```
tail /var/log/grafana/grafana.log
```

- To filter by errors,

```
tail /var/log/grafana/grafana.log | grep level=error
```

### Install Promtail Binary and Start as a Service

- Now we will create the Promtail service that will act as the collector for Loki.
- We can also get the Promtail binary from the same place as Loki. To check the latest version of Promtail, visit the Loki releases page. https://github.com/grafana/loki/releases/

```
cd /usr/local/bin
curl -O -L "https://github.com/grafana/loki/releases/download/v2.4.1/promtail-linux-amd64.zip"
unzip "promtail-linux-amd64.zip"
```

- And allow the execute permission on the Promtail binary

```
sudo chmod a+x "promtail-linux-amd64"
```

- Now we will create the Promtail config file. This default configuration was copied from https://raw.githubusercontent.com/grafana/loki/master/clients/cmd/promtail/promtail-local-config.yaml. There may be changes to this config depending on any future updates to Loki.

```
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: 'http://localhost:3100/loki/api/v1/push'

scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: varlogs
          __path__: /var/log/*log
```

#### Configure Promtail as a Service

- Now we will configure Promtail as a service so that we can keep it running in the background.
- Create user specifically for the Promtail service

```
sudo useradd --system promtail
```

- Create a file called promtail.service

```
sudo nano /etc/systemd/system/promtail.service
```

- And add this script,

```
[Unit]
Description=Promtail service
After=network.target

[Service]
Type=simple
User=promtail
ExecStart=/usr/local/bin/promtail-linux-amd64 -config.file /usr/local/bin/config-promtail.yml

[Install]
WantedBy=multi-user.target
```

- Now start and check the service is running.

```
sudo service promtail start
sudo service promtail status
```

- Now, since this example uses Promtail to read system log files, the promtail user won't yet have permissions to read them.
- So add the user promtail to the adm group

```
usermod -a -G adm promtail
```

- Verify that the user is now in the adm group

```
id promtail
```

- Restart Promtail and check status

```
sudo service promtail restart
sudo service promtail status
```

#### Configure Firewall

- When your Promtail server is running, it will be accessible remotely. If you only want localhost to be able to connect, then type

```
iptables -A INPUT -p tcp -s localhost --dport 9080 -j ACCEPT
iptables -A INPUT -p tcp --dport 9080 -j DROP
iptables -L
```

- Also, I have hard coded my Promtail service to use port 9097 for gRPC communications. This port may also be accessible across the internet. To close it using iptables, then use,

```
iptables -A INPUT -p tcp -s <your servers domain name or ip address> --dport 9097 -j ACCEPT
iptables -A INPUT -p tcp -s localhost --dport 9097 -j ACCEPT
iptables -A INPUT -p tcp --dport 9097 -j DROP
iptables -L
```

- After blocking port 9080 for external requests, you can verify that local request still work using

```
curl "127.0.0.1:9080/metrics"
```

#### Troubleshooting

##### Permission Denied

- `msg="error creating promtail" error="open /tmp/positions.yaml: permission denied"`

- You should check the owner of the file configured in the positions section of the config-promtail.yml matches the name of the user configured in the promtail.service script above.

- My user is promtail, and the positions is set as /tmp/positions.yaml, so I set the owner.

```
chown promtail:promtail /tmp/positions.yaml
```

- If you set up Promtail service with to run as a specific user, and you are using Promtail to view adm and you don't see any data in Grafana, but you can see the job name, then possibly you need to add the user Promtail to the adm group.

```
usermod -a -G adm promtail
```

- You may need to restart the Promtail service and checking again its status.

##### Tail Promtail

- On Linux, you can check the syslog for any Promtail related entries by using the command,

```
tail -f /var/log/syslog | grep promtail
```

### LogQL

- Now that we have a loki data source we can query it with the LogQL query language.
- In this video, we will try out many LogQL queries on the Loki data source we've setup.
- There are two types of LogQL queries:

  - Log queries returning the contents of log lines as streams.
  - Metric queries that convert logs into value matrixes.

- A LogQL query consists of

  - The log str eam selector
  - Filter expression

- We can use operations on both the log stream selectors and filter expressions to refine them.

#### Log Stream Selectors

##### Operators

- = : equals
- != : not equals
- =~ : regex matches
- !~ : regex does not match

EXAMPLES

- Return all log lines for the job varlog
  `{job="varlogs"}`

- Return all log lines for the filename /var/log/syslog
  `{filename="/var/log/syslog"}`

- Return all log lines for the job varlogs and the filename /var/log/auth.log
  `{filename="/var/log/auth.log",job="varlogs"}`

- Show all log lines for 2 jobs with different names
  `{filename=~"/var/log/auth.log|/var/log/syslog"}`

- Show everything you have using regex
  `{filename=~".+"}`

- Show data from all filenames, except for syslog
  `{filename=~".+",filename!="/var/log/syslog"}`

#### Filter Expressions

##### Operators

Used for testing text within log line streams.

- |= : equals
- != : not equals
- |~ : regex matches
- !~ : regex does not match

EXAMPLES

- Return lines including the text "error"
  `{job="varlogs"} |= "error"`

- Return lines not including the text "error"
  `{job="varlogs"} != "error"`

- Return lines including the text "error" or "info" using regex
  `{job="varlogs"} |~ "error|info"`

- Return lines not including the text "error" or "info" using regex
  `{job="varlogs"} !~ "error|info"`

- Return lines including the text "error" but not including "info"
  `{job="varlogs"} |= "error" != "info"`

- Return lines including the text "Invalid user" and including ("bob" or "redis") using regex
  `{job="varlogs"} |~ "Invalid user (bob|redis)"`

- Return lines including the text "status 403" or "status 503" using regex
  `{job="varlogs"} |~ "status [45]03"`

##### Scalar Vectors and Series of Scalar Vectors

- The data so far is returned as streams of log lines. We can graph these in visualizations if we convert them to scalar vectors or even multiple series of scalar vectors.

- We can aggregate the lines into numeric values, such as counts, which then become known as a scalar vectors. The functions below will auto create new scalar vectors based on the labels present in a log stream.

1. count_over_time : Shows the total count of log lines for time range
2. rate : Similar as count_over_time but converted to number of entries per second --> rate = count_over_time / 60 / range(m) eg, 12 / 60 / 2 = 0.1
3. bytes_over_time : Number of bytes in each log stream in the range
4. bytesrate : Similar to \_bytes_over_time but converted to number of bytes per second

EXAMPLES

- The count of jobs at 1 minutes time intervals

```
count_over_time({job="varlogs"}[1m])
```

- The rate of logs per minute. Rate is similar to count_over_time but shows the entries per second.

```
rate({job="varlogs"}[1m])
```

- The count of errors at 1h time intervals

```
count_over_time({job="varlogs"} |= "error" [1h])
```

##### Aggregate Functions

An aggregate function converts multiple series of vectors into a single vector.

- sum : Calculate the total of all vectors in the range at time
- min : Show the minimum value from all vectors in the range at time
- max : Show the maximum value from all vectors in the range at time
- avg : Calculate the average of the values from all vectors in the range at time
- stddev : Calculate the standard deviation of the values from all vectors in the range at time
- stdvar : Calculate the standard variance of the values from all vectors in the range at time
- count : Count the number of elements all all vectors in the range at time
- bottomk : Select lowest k values in all the vectors in the range at time
- topk : Select highest k values in all the vectors in the range at time

EXAMPLES

- Calculate the total of all vectors in the range at time
  `sum(count_over_time({job="varlogs"}[1m]))`

- Show the minimum value from all vectors in the range at time
  `min(count_over_time({job="varlogs"}[1m]))`

- Show the maximum value from all vectors in the range at time
  `max(count_over_time({job="varlogs"}[1m]))`

- Show only the top 2 values from all vectors in the range at time
  `topk(2, count_over_time({job="varlogs"}[1h]))`

##### Aggregate Group

- Convert a scalar vector into a series of vectors grouped by filename

EXAMPLES

- Group a single log stream by filename

```
sum(count_over_time({job="varlogs"}[1m])) by (filename)
```

- Group multiple log streams by host

```
sum(count_over_time({job=~"varlogs"}[1m])) by (host)
```

- Group multiple log streams by filename and host

```
sum(count_over_time({job=~"varlogs"}[1m])) by (filename,host)
```

##### Comparison Operators

Comparison Operators. Used for testing numeric values present in scalars and vectors.

- == (equality)
- != (inequality)
- > (greater than)
- > = (greater than or equal to)
- < (less than)
- <= (less than or equal to)

EXAMPLES

- Returns values greater than 4

```
sum(count_over_time({job="varlogs"}[1m])) > 4
```

- Returns values less than or equal to 1

```
sum(count_over_time({job="varlogs"}[1m])) <= 1
```

##### Logical Operators

These can be applied to both vectors and series of vectors

- and : Bother sides must be true
- or : Either side must be true
- unless : Return values unless value

EXAMPLES

- Returns values greater than 4 or values less then or equal to 1

```
sum(count_over_time({job="varlogs"}[1m])) > 4 or sum(count_over_time({job="varlogs"}[1m])) <= 1
```

- Return values between 100 and 200

```
sum(count_over_time({job="varlogs"}[1m])) > 100 and sum(count_over_time({job="varlogs"}[1m])) < 200
```

##### Arithmetic Operators

- \+ : Add
- \- : Subtract
- \* : Multiply
- / : Divide
- % : Modulus
- ^ : Power/Exponentiation

EXAMPLES

```
sum(count_over_time({job="varlogs"}[1m])) * 10 and
sum(count_over_time({job="varlogs"}[1m])) % 2
```

##### Operator order

- Many Operators can be used at a time. The order follows the PEMDAS construct. PEMDAS is an acronym for the words parenthesis, exponents, multiplication, division, addition, subtraction.

EXAMPLES

- A nonsensical example

```
sum(count_over_time({job="varlogs"}[1m])) % 4 * 2 ^ 2 + 2
# is the same as
((sum(count_over_time({job="varlogs"}[1m])) % 4 * (2 ^ 2)) + 2)
```

- Proving that count_over_time / 60 / range(m) = rate

```
rate({job="varlogs"}[2m]) == count_over_time({job="varlogs"}[2m]) / 60 / 2
# is the same as
rate({job="varlogs"}[2m]) == ((count_over_time({job="varlogs"}[2m]) / 60) / 2)
```

### Install a Second Promtail Service

- We can install a Promtail service on other servers, and point them to an existing Loki service already running on a different server. If you have multiple Promtail se rvices distributed around your network, and all pushing data to one main Loki service, then there are a few more considerations.

- Follow all the same instructions on the Install Promtail Binary as a Service. When adding the promtail user, don't forget to add it to the adm group so that it can read the log files in the /var/log/ folder.

- Also, so that we can query each server independently in Grafana, we should add extra labels to our Promtail configurations. E.g., adding a label for host name is a good option. This will allow us to run log stream selectors depending on the host label.

- My Promtail config looks like this. I've manually set the grpc_listen_port, set the URL that Promtail should push data to, and added a host label.

```
server:
  http_listen_port: 9080
  grpc_listen_port: 9097      # <----

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://<IP address or domain name of your loki service>:3100/loki/api/v1/push      # <----

scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: varlogs
          __path__: /var/log/*log
          host: mysql      # <----
```

- I have also added the host label to my other Promtail service running on my Grafana server, but set it as host: grafana

- Remember to restart and check the Promtail service if you change any configurations.

```
sudo service promtail start
sudo service promtail status
```

#### Firewall

- If your setup matches mine, and you are using IPTables to manage your firewall, then Promtail won't be able to send data to the Loki service running on the Grafana server.

- I can insert a firewall rule into iptables to allow a specific IP address to access port 3100.

```
iptables -I INPUT 3 -p tcp -s <IP Address of server sending data> --dport 3100 -j ACCEPT
```

- Note that your iptables configuration may be different from mine, so check the line number that you want to insert to.

- Use the command below to list IP tables rules and showing line numbers.

```
iptables -L --line-numbers
```

- The Promtail on MySQL should new be able to get data into Loki running in the Grafana server. We should be able to read it through the Loki data source we've setup in Grafana user interface.

#### Encryption

Now, it is important to note that log files can contain very sensitive information. My current setup that I've just demonstrated is not encrypting the data as it is sent across the public network to my Grafana server. Normally you would set up a virtual private network for internal communications between your servers, but in case you don't have this option, we can use the existing Nginx proxy that we installed in the section Reverse Proxy Grafana with Nginx.

I will add a new location record to the existing Nginx configuration so that we can utilize the existing SSL certificate that we installed in the Add SSL section.

On my Grafana server, I have edited my Nginx configuration.

```
sudo nano /etc/nginx/sites-enabled/YOUR-DOMAIN-NAME.conf
```

And added the new location configuration.

```
...
    location /loki/ {
        allow  ###.###.###.###;
        deny all;
        proxy_pass           http://localhost:3100/;
    }
...
```

- After making changes to the Nginx configuration, test it using

```
nginx -t
```

- If all ok, restart and check status.

```
sudo service nginx restart
sudo service nginx status
```

- Next, I need to update the Promtail client configuration on my MySQL server since the address of the Loki service that it is pushing to, has now changed.

- I update the clients property to use the new location that I created in the Nginx proxy.

- E.g. Note that your domain name or IP will be different from mine,

```
...
clients:
  - url: https://grafana.sbcode.net/loki/loki/api/v1/push
...
```

- Now, since I no longer need the iptables rule on my Grafana server to allow the MySQL server to connect to port 3100 directly, I can delete it.

```
iptables -D INPUT 3
```

- I delete rule at INPUT line 3, since that is where I inserted it earlier. Note that your iptables configuration may be different from mine so check the line number that you want to delete.

- With both the Nginx allow and deny rules set, and ensuring the Loki endpoint can only be accessed externally via https, than I have made sure that the data being sent to my Loki service is encrypted and comes from an allowed source.

### Annotation Queries Linking the Log and Graph Panels

- I enhance the quick dashboard that I created in the LogQL section and add an annotation query to help me visualize invalid user login attempts much better.

- The queries

```{job="varlogs"}
count_over_time({job="varlogs"}[1m])
```

- The annotation queries I demonstrated in this video were,

```
{job="varlogs"} |= "invalid user"
{job="varlogs"} |= "invalid user" != "level=info"
{filename="/var/log/auth.log"} |= "invalid user"
```

### Read Nginx Logs with Promtail

- We will add to our Promtail scrape configs, the ability to read the Nginx access and error logs.

```
cd /usr/local/bin/
```

- We need to add a new job_name to our existing Promtail scrape_configs in the config_promtail.yml file.

```
sudo nano config_promtail.yml
```

```
server:
  http_listen_port: 9080
  grpc_listen_port: 9097

positions:
  filename: /tmp/positions.yaml

clients:
  - url: 'http://localhost:3100/loki/api/v1/push'

scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: varlogs
          __path__: /var/log/*log
          host: grafana

  - job_name: nginx     # <-----
    static_configs:
      - targets:
          - localhost
        labels:
          job: nginx
          __path__: /var/log/nginx/*log
          host: grafana
```

Restart the Promtail service and check its status.

```
sudo service promtail restart
sudo service promtail status
```

#### Using the Loki Pattern Parser

- Since Loki v2.3.0, we can dynamically create new labels at query time by using a pattern parser in the LogQL query.

- E.g., we can split up the contents of an Nginx log line into several more components that we can then use as labels to query further.

```
{job="nginx"} | pattern `<_> - - <_> "<method> <_> <_>" <status> <_> <_> "<_>" <_>`
```

- The above query, passes the pattern over the results of the nginx log stream and add an extra two extra labels for method and status. It is similar to using a regex pattern to extra portions of a string, but faster.

- Nginx log lines consist of many values split by spaces. E.g.,

```
206.189.7.141 - - [29/Nov/2021:08:22:54 +0000] "POST /loki/loki/api/v1/push HTTP/1.1" 204 0 "-" "promtail/"
213.205.198.138 - - [29/Nov/2021:08:23:54 +0000] "GET /public/build/grafanaPlugin.9293a56f182a84c40c07.js HTTP/1.1" 200 11042 "https://grafana.sbcode.net/?orgId=1" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/1.2 (KHTML, like Gecko) Chrome/1.2.3.4 Safari/537.36 Edg/1.2.3.4"
213.205.198.138 - - [29/Nov/2021:08:23:55 +0000] "GET /api/search?limit=30&starred=true HTTP/1.1" 200 2 "https://grafana.sbcode.net/?orgId=1" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/1.2 (KHTML, like Gecko) Chrome/1.2.3.4 Safari/537.36 Edg/1.2.3.4"
```

You can extract many values from the above sample if required

- remote_addr
- remote_user
- time_local
- method
- request
- protocol
- status
- body_bytes_sent
- http_referer
- http_user_agent

- A pattern to extract remote_addr and time_local from the above sample would be,

```
{job="nginx"} | pattern `<remote_addr> - - <time_local> "<_> <_> <_>" <_> <_> <_> "<_>" <_>`
```

- It is possible to extract all the values into labels at the same time, but unless you are explicitly using them, then it is not advisable since it requires more resources to run.

#### Troubleshooting

##### Permission Denied

- You may see the error "permission denied". Ensure that your Promtail user is in the same group that can read the log files listed in your scope configs **path** setting.

- E.g., log files in Linux systems can usually be read by users in the adm group.

- You can add your promtail user to the adm group by running

```
sudo usermod -a -G adm promtail
```

## Prometheus

### Install Prometheus Service and Data Source

- Prometheus is already available on the default Ubuntu 20.04 repositories. So we can just install it, and it will be set up as a service already.

```
sudo apt install prometheus
```

- It has installed two services named prometheus and prometheus-node-exporter. We can check them using

```
sudo service prometheus status
sudo service prometheus-node-exporter status
```

- We can test the Prometheus metrics endpoint is running locally by using the command

```
curl http://127.0.0.1:9090/metrics
```

- If your server is on the public internet, it may be accessible via the address http://[your domain or IP]:9100/. If you are not using a dedicated firewall, then you can block it for external users by using these iptables rules below.

```
iptables -A INPUT -p tcp -s localhost --dport 9090 -j ACCEPT
iptables -A INPUT -p tcp --dport 9090 -j DROP
iptables -L
```

After installing Prometheus using apt, yum, dnf, etc., it is also likely to have,

- installed a local Prometheus Node Exporter,
- created and started 2 services for Prometheus and Prometheus Node Exporter,
- created a specific user called prometheus that both services are running under.

- You can check the prometheus user using the command

```
id prometheus
```

- You can check which processes it is running by using the command

```
ps -u prometheus
```

- You can see which ports each process is listening on by using the command

```
ss -ntlp | grep prometheus
```

- The Prometheus Node Exporter also creates a metrics HTTP endpoint on port 9100. You can check it locally using

```
curl http://127.0.0.1:9100/metrics
```

- If your server is on the public internet, and you haven't configured a dedicated firewall, it may be accessible via the address http://[your domain or IP]:9100/
- You can also restrict access to port 9100 using iptables if you need.

```
iptables -A INPUT -p tcp -s localhost --dport 9100 -j ACCEPT
iptables -A INPUT -p tcp --dport 9100 -j DROP
iptables -L
```

### Install Prometheus Dashboard

### Setup Grafana Metrics Prometheus Dashboard

- Depending on your Grafana and Prometheus versions, the pre-built Grafana Metrics dashboard may partly work or not at all.

- In this video, I will show the steps that I used to get it to work.

- Install the Grafana Metrics dashboard from the Prometheus Data Source ⇾ Dashboards tab.

- The Prometheus service, since it is local will, retrieve Grafana stats from the URL http://127.0.0.1:3000/metrics

- We need to add a scrape target into the Prometheus configuration for a job called grafana

```
sudo nano /etc/prometheus/prometheus.yml
```

- Scroll down and add a new job name grafana to the scrape_configs section.

```
# Sample config for Prometheus.

global:
    scrape_interval: 15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
    evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
    # scrape_timeout is set to the global default (10s).

    # Attach these labels to any time series or alerts when communicating with
    # external systems (federation, remote storage, Alertmanager).
    external_labels:
        monitor: 'example'

# Alertmanager configuration
alerting:
    alertmanagers:
        - static_configs:
              - targets: ['localhost:9093']

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
    # - "first_rules.yml"
    # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
    # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
    - job_name: 'prometheus'

      # Override the global default and scrape targets from this job every 5 seconds.
      scrape_interval: 5s
      scrape_timeout: 5s

      # metrics_path defaults to '/metrics'
      # scheme defaults to 'http'.

      static_configs:
          - targets: ['localhost:9090']

    - job_name: node
      # If prometheus-node-exporter is installed, grab stats about the local
      # machine by default.
      static_configs:
          - targets: ['localhost:9100']

    - job_name: grafana       # <------
      static_configs:
          - targets: ['localhost:3000']
```

- Save and restart the Prometheus service

```
sudo service prometheus restart
sudo service prometheus status
```

- Go back into the Grafana UI, Open the Explore tab, select the Prometheus data source and filter by job and there should be a new job named grafana

#### Grafana Metrics Endpoint

- Grafana will return metrics data by default.

- You can verify or change the settings in the grafana.ini file.

```
sudo nano /etc/grafana/grafana.ini
```

- Scroll down and find the metrics settings and ensure they are set as

```
# Metrics available at HTTP API Url /metrics
[metrics]
# Disable / Enable internal metrics
enabled             = true
# Disable total stats (stat_totals_*) metrics to be generated
disable_total_stats = false
```

- Optionally, you can also set the authentication settings of the metrics endpoint.

```
basic_auth_username =
basic_auth_password =
```

- If you changed the grafana.ini, then you will need to restart the Grafana service.

```
sudo service grafana-server restart
sudo service grafana-server status
```

- The Grafana metrics will be visible at URL http://localhost:3000/metrics.
- Since my /metrics endpoint could be accessed remotely, I also created a new Nginx location in my site config to deny access to the /metrics URL path. Note that this does not prevent calling the /metrics endpoint locally, just externally via the Nginx reverse proxy. So the local prometheus service is still able to call the Grafana metrics endpoint.

```
sudo nano /etc/nginx/sites-enabled/YOUR-DOMAIN-NAME.conf
```

```
---
location /metrics {
deny all;
}
```

After changing any Nginx configs, verify the configs are ok using,

```
nginx -t
```

- and the restart, and check status.

```
sudo service nginx restart
sudo service nginx status
```

### Install Second Prometheus Node Exporter

- I will install a Prometheus Node Exporter on a different server and connect to it using the main Prometheus service. On the other server install it,

```
sudo apt install prometheus-node-exporter
```

- Check its status.

```
sudo service prometheus-node-exporter status
```

- It has created a specific user called prometheus. We can inspect it.

```
id prometheus
ps -u prometheus
ss -ntlp | grep prometheus
```

- It is now exposing the metrics endpoint on http://[your domain or ip]:9100
- Now to create a scrape config on the Prometheus server that retrieves metrics from this new URL.

- Go back onto your main Prometheus server and edit the existing scrape config for node and add the new metrics endpoint for the other server.

```
sudo nano /etc/prometheus/prometheus.yml
```

```
...
scrape_configs:
...
- job_name: node
  # If prometheus-node-exporter is installed, grab stats about the local
  # machine by default.
  static_configs:
    - targets: ['localhost:9100']
    - targets: ['IP_ADDRESS_OR_DOMAIN_NAME_OF OTHER_SERVER:9100']   # <---------
```

#### Firewall

- If your server is on the public internet, and you haven't configured a dedicated firewall, it may be accessible via the address http://[your domain or IP]:9100/

#### Nginx Reverse Proxy

- If you have Nginx running on your other server already, with a domain name and an SSL certificate setup, then you can add a location to an existing website config.

- For the following instructions, presume that I have already installed Nginx, with a custom domain and installed an SSL certificate as outlined in the sections below, but customized for this other server where I've just installed the Prometheus Node Exporter.

- Add the location to your websites existing Nginx configuration

```
sudo nano /etc/nginx/sites-enabled/YOUR-EXISTING-CONFIGURATION.conf
```

```
...
    location /metrics {
        allow  ###.###.###.###;
        deny all;
        proxy_pass           http://localhost:9100/metrics;
    }
...
```

## Influxdb

### Install InfluxDB Server and Data Source

- We are going to install InfluxDB v2, the InfluxDB data source, a Telegraf agent and then collect some data.
- InfluxDB is a database useful for storing large amounts of time stamped data.
- Telegraf is an agent that supports plugins, and it will save its data into InfluxDB.
- Note : The configuration of Grafana, InfluxDB and Telegraf is commonly known on the internet as the TIG stack.

- The first part is to Install the InfluxDB2 service and create the data source in Grafana. The installation commands for your OS are at https://portal.influxdata.com/downloads/

```
wget -q https://repos.influxdata.com/influxdata-archive_compat.key
echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null
echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | sudo tee /etc/apt/sources.list.d/influxdata.list
sudo apt-get update && sudo apt-get install influxdb2
```

- The InfluxDB service is usually not started by default. We can start it and check its status.

```
sudo service influxdb start
sudo service influxdb status
```

- We can now visit the InfluxDB UI at the address http://[Your Domain name or IP address]:8086
- If your InfluxDB web address is accessible from the internet, then I recommend setting some firewall rules using the methods available to you.
- When you first access the InfluxDB UI, it will require you to create a user and password to log in.
- After logging in, we need to create a user, password, organization and bucket name.
- I have named my organization sbcode and my bucket telegraf. Your username and password for accessing InfluxDB can also be anything you want.
- Also, you can name your organization anything you like, just remember it though, since you will need it when creating the data source in the Grafana UI.
- Using the InfluxDB UI, make sure you have a bucket named telegraf, a scraper named anything you like, and an access token to allow the InfluxDB data source to connect with.

#### Firewall

- If your server is on the public internet, and you haven't configured a dedicated firewall, it may be accessible via the address http://[your domain or IP]:8086/
- You can restrict access to port 8086 using iptables.

```
iptables -A INPUT -p tcp -s <domain name or ip of allowed host> --dport 8086 -j ACCEPT
iptables -A INPUT -p tcp --dport 8086 -j DROP
iptables -L
```

### Install Telegraf Agent and Configure for InfluxDB

- Now to install the Telegraf agent and configure the output plugin to save data into the InfluxDB2. The installation commands for your OS are at https://portal.influxdata.com/downloads/

- Download the package (Telegraf v1.27.1).

```
wget https://dl.influxdata.com/telegraf/releases/telegraf_1.27.1-1_amd64.deb
```

- Install it using the package manager.

```
sudo dpkg -i telegraf_1.27.1-1_amd64.deb
```

- It is normally started by default. We can check its status.

```
sudo service telegraf status
sudo service telegraf start

```

- CD into the new Telegraf folder

```
cd /etc/telegraf
```

- Create a backup of the existing Telegraf config.

```
cp telegraf.conf telegraf.conf.bak
```

- Delete the telegraf.conf

```
rm telegraf.conf
```

- Create a new telegraf.conf

```
sudo nano telegraf.conf
```

- Paste this minimal configuration text into it.

```
[agent]
  interval = "10s"
  round_interval = true
  metric_batch_size = 1000
  metric_buffer_limit = 10000
  collection_jitter = "0s"
  flush_interval = "10s"
  flush_jitter = "0s"
  precision = ""
  hostname = ""
  omit_hostname = false

[[outputs.influxdb_v2]]
  urls = ["http://127.0.0.1:8086"]
  token = "YOUR TELEGRAF READ/WRITE TOKEN"
  organization = "YOUR ORG NAME"
  bucket = "telegraf"

[[inputs.cpu]]
  percpu = true
  totalcpu = true
  collect_cpu_time = false
  report_active = false
[[inputs.disk]]
  ignore_fs = ["tmpfs", "devtmpfs", "devfs", "iso9660", "overlay", "aufs", "squashfs"]
[[inputs.diskio]]
[[inputs.mem]]
[[inputs.net]]
[[inputs.processes]]
[[inputs.swap]]
[[inputs.system]]
```

We can create one.

1. In the InfluxDB UI, Select Telegraf, and then the CREATE CONFIGURATION button.
2. Choose the bucket named Telegraf.
3. Select the source System, and then press the [CONTINUE CONFIGURING] button.
4. Name your configuration System
5. Press [SAVE AND TEST]
6. Copy the token from the first command shown to you.

E.g.,

```
export INFLUX_TOKEN=abcdefgABCDEFG12345678abcdefhABCDFEFG123456abcdefgABCDEFG12345678abcdefhABCDFEFG123456==
```

- Copy the part after export INFLUX_TOKEN=, so that would be

```
abcdefgABCDEFG12345678abcdefhABCDFEFG123456abcdefgABCDEFG12345678abcdefhABCDFEFG123456==
```

- Replace the text YOUR TELEGRAF READ/WRITE TOKEN from the configuration above, with your new token. Your token will be different from mine.

- Replace YOUR ORG NAME with the organization that you created when you first set up InfluxDB.

- Press the [FINISH] button in the InfluxDB UI.

- Using SSH, restart Telegraf and check its status.

```
sudo service telegraf restart
sudo service telegraf status
```

- InfluxDB should now be able to query some extra metrics, and you should be able to also query them in Grafana as demonstrated in the video. Example flux query

```
from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop:v.timeRangeStop)
  |> filter(fn: (r) =>
    r._measurement == "cpu"
    and r._field == "usage_user"
  )
```

### Install A Dashboard For Default InfluxDB_Telegraf Metrics

### Install SNMP Agent and Configure Telegraf SNMP Input

- SNMP stands for Simple Network Management Protocol.

- We can configure Telegraf to read SNMP, save it into InfluxDB and view it in Grafana.

- Common devices that support SNMP are routers, switches, printers, servers, workstations and other devices found on IP networks.

- Not every network device supports SNMP, or has it enabled, and there is a good chance you don't have an SNMP enabled device available that you can use in this section.

- So, I will show you how to install SNMP on an Ubuntu 20.04 server.

```
sudo apt install snmp snmpd snmp-mibs-downloader
```

- Do a test query

```
snmpwalk -v 2c -c public 127.0.0.1 .
```

- The response should show results with OID numbers like in this example output

```
iso.3.6.1.2.1.1.1.0 = STRING: "Linux grafana 4.15.0-72-generic #81-Ubuntu SMP Tue Nov 26 12:20:02 UTC 2019 x86_64"
iso.3.6.1.2.1.1.2.0 = OID: iso.3.6.1.4.1.8072.3.2.10
iso.3.6.1.2.1.1.3.0 = Timeticks: (443) 0:00:04.43
iso.3.6.1.2.1.1.4.0 = STRING: "Me <me@example.org>"
iso.3.6.1.2.1.1.5.0 = STRING: "grafana"
iso.3.6.1.2.1.1.6.0 = STRING: "Sitting on the Dock of the Bay"
iso.3.6.1.2.1.1.7.0 = INTEGER: 72
iso.3.6.1.2.1.1.8.0 = Timeticks: (11) 0:00:00.11
iso.3.6.1.2.1.1.9.1.2.1 = OID: iso.3.6.1.6.3.11.3.1.1
iso.3.6.1.2.1.1.9.1.2.2 = OID: iso.3.6.1.6.3.15.2.1.1
iso.3.6.1.2.1.1.9.1.2.3 = OID: iso.3.6.1.6.3.10.3.1.1
...
etc
```

- Now to enable MIB descriptions instead of OIDs.

- Edit the snmp.conf file

```
sudo nano /etc/snmp/snmp.conf
```

- comment out the line mibs as below, using a #

```
#mibs
```

- Save, and retry a query.

```
snmpwalk -v 2c -c public 127.0.0.1 .
```

- Save, and retry a query.

```
snmpwalk -v 2c -c public 127.0.0.1 .
```

- It should now show the MIBs descriptions in the results like in this example output.

```
SNMPv2-MIB::sysDescr.0 = STRING: Linux grafana 4.15.0-72-generic #81-Ubuntu SMP Tue Nov 26 12:20:02 UTC 2019 x86_64
SNMPv2-MIB::sysObjectID.0 = OID: NET-SNMP-MIB::netSnmpAgentOIDs.10
DISMAN-EVENT-MIB::sysUpTimeInstance = Timeticks: (3015) 0:00:30.15
SNMPv2-MIB::sysContact.0 = STRING: Me <me@example.org>
SNMPv2-MIB::sysName.0 = STRING: grafana
SNMPv2-MIB::sysLocation.0 = STRING: Sitting on the Dock of the Bay
SNMPv2-MIB::sysServices.0 = INTEGER: 72
SNMPv2-MIB::sysORLastChange.0 = Timeticks: (11) 0:00:00.11
SNMPv2-MIB::sysORID.1 = OID: SNMP-MPD-MIB::snmpMPDCompliance
SNMPv2-MIB::sysORID.2 = OID: SNMP-USER-BASED-SM-MIB::usmMIBCompliance
SNMPv2-MIB::sysORID.3 = OID: SNMP-FRAMEWORK-MIB::snmpFrameworkMIBCompliance
...
etc
```

- Now to configure Telegraf to read SNMP

```
sudo nano /etc/telegraf/telegraf.conf
```

- Add this script below to the telegraf.conf file.

```
[[inputs.snmp]]
  agents = ["udp://127.0.0.1:161"]

  [[inputs.snmp.field]]
    oid = "RFC1213-MIB::sysUpTime.0"
    name = "uptime"

  [[inputs.snmp.field]]
    oid = "RFC1213-MIB::sysName.0"
    name = "source"
    is_tag = true

  [[inputs.snmp.table]]
    oid = "IF-MIB::ifTable"
    name = "interface"
    inherit_tags = ["source"]

    [[inputs.snmp.table.field]]
      oid = "IF-MIB::ifDescr"
      name = "ifDescr"
      is_tag = true
```

- Save the above configuration addition, restart Telegraf and check status.

```
sudo service telegraf restart
sudo service telegraf status
```

- ⚠️ NOTE : By default SNMPD restricts how much information it returns. So currently we won't get any IF-MIB:: data from a SNMP query.

- Go back into snmpd.conf and edit the view section to return more data.

```
sudo nano /etc/snmp/snmpd.conf
```

- Change lines

```
...
view   systemonly  included   .1.3.6.1.2.1.1
view   systemonly  included   .1.3.6.1.2.1.25.1
...
```

- to

```
...
view   systemonly  included   .1.3.6.1.2.1
#view   systemonly  included   .1.3.6.1.2.1.25.1
...
```

- This will now return all data with the OID prefixes .1.3.6.1.2.1 which also includes interface information.

- After a few moments, the snmp.table information should be queryable in InfluxDB and in Grafana through the interface measurement.

#### Sample Queries

- Some sample queries to try against the InfluxDB data source in the Grafana explore tab.

```
from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["_measurement"] == "interface")
  |> yield(name: "mean")
```

```
from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["_measurement"] == "snmp")
  |> filter(fn: (r) => r["_field"] == "uptime")
  |> aggregateWindow(every: v.windowPeriod, fn: mean, createEmpty: false)
  |> yield(name: "mean")
```

### Add Multiple SNMP Devices to Telegraf Config

- I can add many more SNMP agents to the Telegraf config.
- In order for Telegraf to connect to external SNMP agents, those other SNMP agents will need to be configured to allow my Telegraf agent to connect remotely.

- On my servers, that I'd like monitor using SNMP, I install SNMPD using

```
sudo apt install snmpd
```

- I then configure snmpd.conf.

```
sudo nano /etc/snmp/snmpd.conf
```

- I change below,

```
...
agentAddress 127.0.0.1,[::1]
...
```

- to allow remote connections,

```
...
agentAddress udp:161
...
```

- and I change below

```
...
view   systemonly  included   .1.3.6.1.2.1.1
view   systemonly  included   .1.3.6.1.2.1.25.1
...
```

- to return more data,

```
...
view   systemonly  included   .1.3.6.1.2.1
#view   systemonly  included   .1.3.6.1.2.1.25.1
...
```

- If your server is on the internet, and you don't have a firewall in place, then the SNMPD service can be connected to remotely by anybody on the internet.

- You can use iptables to restrict UDP connections on port 161 to the localhost and any external servers domain or ip that needs access to it.

```
iptables -A INPUT -p udp -s [domain name or ip] --dport 161 -j ACCEPT
iptables -A INPUT -p udp -s localhost --dport 161 -j ACCEPT
iptables -A INPUT -p udp --dport 161 -j DROP
iptables -L
```

- Restart the SNMPD service

```
sudo service snmpd restart
```

- I then go back to my InfluxDB server, and test that I can query the new SNMPD on the other server using SNMPWALK.

```
snmpwalk -v 2c -c public [domain name or ip] .
```

- I then reconfigure the Telegraf conf to add the information for my external SNMP agent.

- I add the IP address to the existing agents property array in the [[inputs.snmp]] section.

- I can repeat the above process for other servers or devices that I want to monitor using SNMP.

- After I've added all my SNMP agent configs to the telegraf.conf, I then restart the Telegraf service. The information will then become available in InfluxDB and then Grafana through the InfluxDB data source configuration.

```
sudo service telegraf restart
```

- The complete SNMP inputs configuration for my 3 servers is below for your reference.

```
[[inputs.snmp]]
  agents = [
    "udp://127.0.0.1:161",
    "udp://10.133.0.4:161",
    "udp://10.133.0.3:161"
  ]

  [[inputs.snmp.field]]
    oid = "RFC1213-MIB::sysUpTime.0"
    name = "uptime"

  [[inputs.snmp.field]]
    oid = "RFC1213-MIB::sysName.0"
    name = "source"
    is_tag = true

  [[inputs.snmp.table]]
    oid = "IF-MIB::ifTable"
    name = "interface"
    inherit_tags = ["source"]

    [[inputs.snmp.table.field]]
      oid = "IF-MIB::ifDescr"
      name = "ifDescr"
      is_tag = true
```

- And this is the Flux query that shows uptime for all my 3 SNMPD services.

```
from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["_measurement"] == "snmp")
  |> filter(fn: (r) => r["_field"] == "uptime")
  |> aggregateWindow(every: v.windowPeriod, fn: mean, createEmpty: false)
  |> yield(name: "mean")
```

### Import SNMP Dashboard that uses InfluxDB and Telegraf

## Zabbix

### Create and Configure a Zabbix Data Source

- You can connect directly to Zabbix via the API method. If you want faster performance than it is advised to also setup a MySQL data source for your Zabbix connection. The MySQL data source will instead connect directly to the Zabbix database and bypass the API layer for certain queries.

#### Create Zabbix Specific MySQL Data Source

- We can create a MySQL Data Source that will connect directly to the Zabbix Servers MySQL Database. This is useful if you want to improve performance.
- SSH onto the Zabbix Server,
- Create a user in MySQL, with read only access, that the Grafana MySQL data source will use to connect with.

```
mysql
```

```
> CREATE USER 'grafana'@'GRAFANA SERVER IP ADDRESS' IDENTIFIED BY 'password';

> GRANT SELECT ON zabbix.* TO 'grafana'@'GRAFANA SERVER IP ADDRESS';

> FLUSH PRIVILEGES;

> select host, user from mysql.user;

> QUIT;
```

- Also allow remote connections on MySQL

```
sudo nano /etc/mysql/my.cnf
```

- Change or Add the bind address value to the end of the file.

```
[mysqld]
bind-address    = 0.0.0.0
```

- Restart the MySQL and check the status.

```
sudo service mysql restart
sudo service mysql status
```

#### Install Zabbix Data Source Plugin

- Now it's time to install the Zabbix Data Source plugin that will connect to the Zabbix API, and also use the new MySQL data source we just created.

- It is easiest to use the Grafana UI to install the Zabbix data source plugin and set it up. You can also do it manually by continuing to use the methods below which is more useful for older versions of Grafana.

- SSH onto the Grafana Server and add the Zabbix Data Source plugin using the CLI

```
grafana-cli plugins install alexanderzobnin-zabbix-app
```

- Since Grafana v7, unsigned plugins won't be visible unless you explicitly allow them in the Grafana.ini file.
- Open /etc/grafana/grafana.ini, and uncomment the line

```
;allow_loading_unsigned_plugins
```

and change to

```
allow_loading_unsigned_plugins = alexanderzobnin-zabbix-datasource
```

- And then restart the Grafana server

```
sudo service grafana-server restart
```

- I then use the Grafana UI to enable the Zabbix Data Source Plugin, and then configure it.

- The required API URL will be, https://[your zabbix server ip or domain name]/zabbix/api_jsonrpc.php
- Also select the 'Direct DB Access' to be the new MySQL data source you just created.
- Save and Continue

### Import Zabbix Dashboards

### Create Advanced Custom Zabbix Dashboard

## Elasticsearch

### Elasticsearch Data Source and Database

- I demonstrate installing and querying Elasticsearch 7.16.
- Elasticsearch uses the JavaVM. So I recommend a minimum spec of 2GB RAM for the server that you use for the Elasticsearch service.
- I am using Debian Package Instructions from https://www.elastic.co/guide/en/elasticsearch/reference/current/install-elasticsearch.html
- Download and install the public signing key.

```
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
```

- Install dependencies

```
sudo apt-get install apt-transport-https
```

- Save the repository definition

```
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
```

- Update and install the Elasticsearch package

```
sudo apt-get update && sudo apt-get install elasticsearch
```

- Confirm status and start.

```
sudo service elasticsearch status
sudo service elasticsearch start
```

- If you have a problem, you can view Elasticsearch logs using

```
sudo journalctl --unit elasticsearch
```

- A new user was created named elasticsearch

```
ps -u elasticsearch
```

- Test the http interface is running by using curl

```
curl "http://localhost:9200"
```

- View the configuration files in /etc/elasticsearch/

```
cd /etc/elasticsearch/
ls -lh
```

- Edit the elasticsearch.yml to allow remote connections through the http interface.

```
sudo nano /etc/elasticsearch/elasticsearch.yml
```

- Use these settings

```
cluster.name: my-application
node.name: node-1
network.host: 0.0.0.0
http.port: 9200
cluster.initial_master_nodes: ["node-1"]
```

- Save, restart and check status

```
sudo service elasticsearch restart
```

- Create an example index

```
curl -X PUT "http://localhost:9200/index1"
```

- View the index metadata

```
curl "http://localhost:9200/index1?pretty"
```

- Add some data to the index

```
curl -H "Content-Type: application/json" -XPOST "http://localhost:9200/index1/_doc" -d '{"abc":123, "name":"xyx", "@timestamp" : "'$(date -Iseconds)'"}'
```

- View the contents of the index

```
curl "http://localhost:9200/index1/_search?pretty"
```

- View available indexes in your Elasticsearch

```
curl http://localhost:9200/_cat/indices
```

- Delete an index

```
curl -XDELETE 'http://localhost:9200/index1'
```

- Use IPTables to restrict port 9200

```
iptables -A INPUT -p tcp -s localhost --dport 9200 -j ACCEPT
iptables -A INPUT -p tcp -s ###.###.###.### --dport 9200 -j ACCEPT
iptables -A INPUT -p tcp --dport 9200 -j DROP
iptables -L
```

### Setup Elasticsearch Filebeat

- I demonstrate how to setup a Filebeat service to read systemd logs.
- Filebeat download instructions can be found at https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-installation-configuration.html#installation

- I downloaded the debian package manager version.

```
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.16.1-amd64.deb
sudo dpkg -i filebeat-7.16.1-amd64.deb
```

```
cd /etc/filebeat
ls -lh
```

- Enable a module for Filebeat to run.
- Get a list.

```
filebeat modules list
```

- I enable the system module

```
filebeat modules enable system
```

- Now edit the filebeat configuration.

```
sudo nano /etc/filebeat/filebeat.yml
```

- Update the address of your Elasticsearch server.

```
output.elasticsearch:
  hosts: ["<IP Address of your Elasticsearch Server>:9200"]
```

- Restart and check status.

```
sudo service filebeat start
sudo service filebeat status
```

- You can also disable a module

```
filebeat modules disable system
```

- If you enable/disable a module, then restart Filebeat.

```
sudo service filebeat restart
sudo service filebeat status
```

#### Firewall

- The Elasticsearch service may or may not have a firewall blocking this new filebeat from sending to it. If you used IPtables from the last lesson, then you can add another IPtables rule to allow the IP address of this new filebeat service to send.

- So on my Elasticsearch server, I get the iptables rules line numbers.

```
iptables -L --line-numbers
```

- I insert the new rule for my new Filebeat services IP before the DROP rule.

```
iptables -I INPUT 2 -p tcp -s x.x.x.x --dport 9200 -j ACCEPT
```

- Persist changes.

```
iptables-save > /etc/iptables/rules.v4
```

- Now we can set up a new data source in Grafana, or modify the existing and test it using the explore tab.

- If you didn't use IPtables, but your cloud providers firewall options to mange your firewall, then you need to allow this servers IP address, that you just installed Filebeat onto, to send to your Elasticsearch servers IP address on port 9200. I demonstrate setting my firewall rules in the video.

- I can verify that my Filebeat can send to my Elasticsearch server by making curl requests from the server running Filebeat.

```
curl "http://<IP Address of your Elasticsearch Server>:9200"
```

- and to get the name of the new index created by this new Filebeat service,

```
curl "http://<IP Address of your Elasticsearch Server>:9200/_cat/indices"
```

### Setup Elasticseach Metricbeat

- I will set this up on the same linux server where the Filebeat process is already running.

- Download Metricbeat for your OS from https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-installation-configuration.html#installation

- My OS is a Debian based Ubuntu 20.04

```
curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.16.1-amd64.deb
sudo dpkg -i metricbeat-7.16.1-amd64.deb
```

- View the available modules and status

```
metricbeat modules list
```

- (Optional) Enable the linux module

```
metricbeat modules enable linux
```

- Navigate to the Metricbeat folder.

```
cd /etc/metricbeat
ls -lh
```

- Edit the Metricbeat settings.

```
sudo nano /etc/metricbeat/metricbeat.yml
```

- Update the address of your Elasticsearch server.

```
output.elasticsearch:
  hosts: ["<IP Address of your Elasticsearch Server>:9200"]
```

- Restart and check status.

```
sudo service metricbeat start
sudo service metricbeat status
```

#### Firewall

- Don't forget about any firewalls rules you don't have or need to add.

- Verify that your Metricbeat process can send to your Elasticsearch server by making curl requests from the server running Metricbeat.

```
curl "http://<IP Address of your Elasticsearch Server>:9200"
```

- and to get the name of the new index created by this new Metricbeat service,

```
curl "http://<IP Address of your Elasticsearch Server>:9200/_cat/indices"
```

### Setup an Advanced Elasticsearch Dashboard

- Now to install an advanced dashboard that uses both the Filebeat and Metricbeat datasources at the same time.

- Now to install the 'OS stats - Linux' dashboard from https://grafana.com/grafana/dashboards/12626

- Import a new dashboard using the ID 12626

- Choose the correct Filebeat and Metricbeat datasources and then continue.

- Not all panels will contain data, so you will need to edit the /etc/metricbeat/modules.d/system.yml file on the host running Metricbeat.

- My /etc/metricbeat/modules.d/system.yml has these settings

```
# Module: system
# Docs: https://www.elastic.co/guide/en/beats/metricbeat/7.10/metricbeat-module-system.html

- module: system
  period: 30s
  metricsets:
      - cpu
      - load
      - memory
      - network
      - process
      - process_summary
      - socket_summary
      #- entropy
      #- core
      - diskio
      #- socket
      - service
      - users
  process.include_top_n:
      by_cpu: 5 # include top 5 processes by CPU
      by_memory: 5 # include top 5 processes by memory

- module: system
  period: 1m
  metricsets:
      - filesystem
      - fsstat
  processors:
      - drop_event.when.regexp:
            system.filesystem.mount_point: '^/(sys|cgroup|proc|dev|etc|host|lib|snap)($|/)'

- module: system
  period: 15m
  metricsets:
      - uptime
#- module: system
#  period: 5m
#  metricsets:
#    - raid
#  raid.mount_point: '/'
```

### Dashboard Variables

### Dynamic Table from Variables

### Dynamic Singlestats from Variables

### Dynamic Graphs from Variables

### Create an Email Alert Notification Channel

- I want to send alerts using Grafana, but I need to first create an alert contact point.
- In this lecture I will create a new channel for email alerts.
- Before starting, ensure that your version of Grafana is 8.3 or higher. We will be using the newer unified alerting user interface.

```
wget https://dl.grafana.com/oss/release/grafana_8.3.3_amd64.deb
sudo dpkg -i grafana_8.3.3_amd64.deb
```

- Next, you will need an SMTP server. Many corporations will provide an SMTP service for their staff. This same service can be used to send emails from Grafana.

- You will need an email account in your email provider, admin@your-domain.tld perhaps may be good. You will also need an accessible SMTP server address, e.g., mail.example.com and a port, usually 25 or 465.

- In this video, I already have a domain that I purchased from Namecheap. For an extra $1 a month, I can get an email service add-on that I can use to send and receive emails. I will configure Grafana to use this email service.

- If you have a corporate email service that you already connect your work mobile phone to, then the set-up process and settings will be very similar. You will be able to use Grafana to send emails using your work email address.

- Next to configure Grafana SMTP settings

```
sudo nano /etc/grafana/grafana.ini
```

- Find the SMTP specific settings, uncomment and edit.

```
sudo nano /etc/grafana/grafana.ini
```

- Below are some sample settings. Your actual settings will depend on the domain name of your SMTP service.

```
[smtp]
enabled = true
host = mail.your-smtp-providers-domain.tld:465
user = admin@your-domain.tld
password = """your-password-wrapped-in-triple-quotes"""
from_address = admin@your-domain.tld
from_name = Grafana
ehlo_identity = your-smtp-providers-domain.tld
```

- Restart Grafana and check its status.

```
sudo service grafana-server restart
sudo service grafana-server status
```

- Go back into Grafana and into your new Email notification channel settings, and try to send a test email to yourself.

#### Set up Send-Only SMTP using PostFix

- If you don't have an SMTP server available, you can install a local send only SMTP server on your Grafana server itself.

```
sudo apt install mailutils
```

- At the prompt, I choose Internet Site
- After the installation is finished, I need to configure the Postfix SMTP server.

```
sudo nano /etc/postfix/main.cf
```

- I edit 2 values at the bottom being,

```
inet_interfaces = loopback-only
inet_protocols = ipv4
```

- Then restart postfix

```
sudo service postfix restart
```

- I can test the SMTP server sends emails using

```
echo "This is the body" | mail -s "This is the subject" -a "FROM:root@your-domain.tld" your@email-address
```

- Sending an email from the command line must work before you continue. "Work", means that you got an email in your inbox.
- Next to configure Grafana SMTP settings

```
sudo nano /etc/grafana/grafana.ini
```

- Find the SMTP specific settings, uncomment and edit

```
[smtp]
enabled = true
host = localhost:25
skip_verify = true
from_address = admin@[your grafana domain name or ip]
from_name = Grafana
ehlo_identity = [your grafana domain name or ip]
```

- Restart Grafana

```
sudo service grafana-server restart
```

- Go back into Grafana, into your new Email notification channel settings and try to send a test email.

- Check your SPAM folder.

#### Troubleshooting

- If you have trouble sending and receiving emails through Grafana, you can check the Grafana log file. Note that passwords need to be wrapped in triple quotes if they have the characters # or ;

```
cat /var/log/grafana/grafana.log | grep email
```

### Create Alerts for SNMP No Data

### Create a Custom Webhook Alert Notification Channel for SMS using AWS SNS

### Create Telegram Bot Alert Channel

- We can also add Telegram as a Contact Point for Alerting.

- To do this install the Telegram app on your phone or PC. It will be easiest to set this up on your PC first.

- You will need a BOT API Token and Chat ID.

- Open Telegram, and create a new Bot by searching for @BotFather and then typing /newbot

- Follow the prompts to create a name and username for your bot. The username must end in bot and must be unique.

- You will get given a HTTP API token which is your BOT API Token to be used in Grafana. It will be in the form XXXXXXXXX: YYYYYYYYYYYYYYYYYYYYYYYYYYYYY

- You then need the Chat ID. To get this, you first need to create a group and then add the new bot to it.

- Then press the View Group Info option for the group, click your bot users name in the members list, and press the SEND MESSAGE button.

- Then send any message to the user.

- Then, in your browser, visit the url https://api.telegram.org/botXXX:YYY/getUpdates (replace the XXX:YYY with the BOT API token you just got from Telegram)

- In the JSON response, you should see a node with a message that has the type=group. This node will also have an Id. Copy this Id into the Chat ID field in Grafana.

- Now you can test the new Telegram contact point in Grafana using the Test button.

- There should be a sample alert from Grafana inside your new Telegram group messages window.

#### Troubleshooting

- If the getUpdates URL doesn't return a node containing a chat group with an id, then try sending another message with different text.

- You can also try, removing your bot from the group, and then re adding your bot to the group, selecting it from the group members list,
  send it a new message, then try the getUpdates URL again. Also, if the chat id is a negative number, make sure you copy the negative symbol as well when setting the chat id in the script. E.g.,

- If chat id = -123456789, occasionally quickly copying and pasting you may forget the - character and copy just 123456789

### Value Groups_Tags with the Zabbix Data Source

### Value Groups_Tags with the InfluxDB_Telegraf Data Source

### Create a Cisco Switch Dashboard from the Zabbix Data Source

### Create a Cisco Switch Dashboard from the InfluxDB_Telegraf Data Source

### Disk Read_Write Rates Dashboard with the Zabbix Data Source

### rnal-assets-links

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
