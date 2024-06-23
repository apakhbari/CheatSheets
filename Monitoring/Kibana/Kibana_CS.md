# Kibana

```
 ___   _  ___   _______  _______  __    _  _______ 
|   | | ||   | |  _    ||   _   ||  |  | ||   _   |
|   |_| ||   | | |_|   ||  |_|  ||   |_| ||  |_|  |
|      _||   | |       ||       ||       ||       |
|     |_ |   | |  _   | |       ||  _    ||       |
|    _  ||   | | |_|   ||   _   || | |   ||   _   |
|___| |_||___| |_______||__| |__||_|  |__||__| |__|
```

# Table of Contents


# Introduction
- ELK stack:
  - Logstash: Collect & transform
  - Elasticsearch: Search & analyze
  - Kibana: Visualize & Manage

## Elasticsearch
- Is Apache Lucene based real-time ditributed and open source data analytic engine
- Heart of Elastic stack
- Stores data in JSON Format Documents

### Features of Elasticsearch
- Easy to scale
- HA
- RESTful API
- Advanced searc features
- Multi Tenancy
- Big data
- Open Source

### Basic Terms
- Cluster: Provide organized indexing and search capabilities - identified by name
- Node: identified by name
- Index: Collection of Documents with similar charecteristics - Similar to Relational DB - identified by name
- Document: Basic unit of indexed information - Expressed in JSON - similar to objects in an object oriented programming language - Each document has unique ID
- Shard: Subdivision of Index into multiple pieces - Allow horizontally scal the content volume  Increase performance throughput - Number of shard can be secified while creating an index
- Replicas: copies of shards - Provides HA
- Type: Used to store different types of document in the same index - Removed from latest version of elasticsearch
- Mapping: Defines how a document and its fields get stored and indexed - Can eiter be defined explicitly, or will be generated automatically when a document is indexed - Each index has one mapping type which determines how the document will be indexed

### Configuration Files
- elasticsearch.yml
- jvm.options
- log4j2.properties

### Default Setting
- Default HTTP Port: 9200
- Default cluster name: Elasticsearch

## Kibana
### Features of Elasticsearch
- Data Exploration and anlaytic tool
- Web based app
- open source
- integrates with elasticsearch
- Provides Effective Search capabilities

### How can it be useful?
- Provides various visualization options
  - Charts
  - Maps
  - Data Tables & Metrics

- Can be used for:
  - Log Management
  - Security and Compliance Monitoring
  - Application monitoring
  - Business intelligence

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
