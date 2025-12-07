This is a great approach. Using **Fluent Bit as a "Sidecar" or "Host Service"** is the standard way to handle this.

The architecture will look like this:

1.  **Fluent Bit** runs in its own container on your Ubuntu server, exposing port `24224`.
2.  **Your App Containers** are configured to send logs to the Docker Daemon.
3.  **Docker Daemon** forwards those logs to Fluent Bit.
4.  **Fluent Bit** processes them (adds your `dividing_name`) and sends them to Graylog.

Here is the complete solution.

### 1\. The Directory Structure

Create a folder on your Ubuntu server (e.g., `/opt/fluent-bit`) to hold the configuration:

```bash
/opt/fluent-bit/
├── docker-compose.yaml
├── fluent-bit.conf
└── functions.lua
```

### 2\. fluent-bit.conf

We will use the **Forward** input (which is what the Docker logging driver speaks). We will also reuse the logic we learned from your K8s setup to ensure the GELF output works perfectly.

Create `/opt/fluent-bit/fluent-bit.conf`:

```ini
[SERVICE]
    Flush        1
    Log_Level    info
    Parsers_File parsers.conf

[INPUT]
    Name   forward
    Listen 0.0.0.0
    Port   24224

# Extract container name from the tag
# We will configure Docker to send tags as "docker.container_name"
[FILTER]
    Name    lua
    Match   *
    script  functions.lua
    call    add_dividing_name

[OUTPUT]
    Name                    gelf
    Match                   *
    Host                    10.10.21.151
    Port                    31220
    Mode                    tcp
    Gelf_Short_Message_Key  log
```

### 3\. functions.lua

This script grabs the container name from the tag and creates your custom `dividing_name` field.

Create `/opt/fluent-bit/functions.lua`:

```lua
function add_dividing_name(tag, timestamp, record)
    -- Expecting tag format: docker.container_name
    -- We split the tag to get the container name
    local container_name = "unknown"
    
    -- The tag comes in as "docker.my-app". We want "my-app"
    local p1, p2 = tag:match("([^.]+).([^.]+)")
    if p2 then
        container_name = p2
    end

    -- Create the custom field: "ubuntu_server_01:container_name"
    -- You can change "ubuntu_prod" to whatever your server name is
    record["dividing_name"] = "ubuntu_prod:" .. container_name
    
    -- Ensure the 'log' key exists for GELF (Docker forward usually sends 'log' or 'message')
    if record["log"] == nil and record["message"] ~= nil then
        record["log"] = record["message"]
    end

    return 1, timestamp, record
end
```

### 4\. docker-compose.yaml (For Fluent Bit)

This runs Fluent Bit and exposes the port so the local Docker Daemon can reach it.

Create `/opt/fluent-bit/docker-compose.yaml`:

```yaml
services:
  fluent-bit:
    image: fluent/fluent-bit:3.2.10
    container_name: fluent-bit-logger
    ports:
      - "24224:24224"
      - "24224:24224/udp"
    volumes:
      - ./fluent-bit.conf:/fluent-bit/etc/fluent-bit.conf
      - ./functions.lua:/fluent-bit/etc/functions.lua
    restart: always
```

**Start Fluent Bit:**

```bash
cd /opt/fluent-bit
docker-compose up -d
```

-----

### 5\. How to Configure Your Applications

Now, for any `docker-compose.yml` file you have for your applications, you simply add the `logging` configuration.

**Crucial Step:** We set the `tag` to `docker.{{.Name}}`. This allows our Lua script to capture the actual container name.

Example Application `docker-compose.yaml`:

```yaml
services:
  my-web-app:
    image: nginx:latest
    ports:
      - "80:80"
    logging:
      driver: "fluentd"
      options:
        # Connects to the Fluent Bit we just started on the host
        fluentd-address: "localhost:24224"
        # Sends the container name as the tag so Lua can read it
        tag: "docker.{{.Name}}"

  my-database:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: password
    logging:
      driver: "fluentd"
      options:
        fluentd-address: "localhost:24224"
        tag: "docker.{{.Name}}"
```

### Why this works:

1.  **Docker Daemon Proxy:** When you set `fluentd-address: localhost:24224` in an app container, the **Docker Daemon** (running on the host OS) captures the logs and sends them to port 24224 on the host. It does *not* try to connect from inside the app container.
2.  **Tagging:** By using `tag: "docker.{{.Name}}"`, a container named `my-web-app` sends logs with the tag `docker.my-web-app`.
3.  **Lua Processing:** Fluent Bit receives the tag, splits it, extracts `my-web-app`, and creates `dividing_name: "ubuntu_prod:my-web-app"`.
4.  **Consistency:** You now have the exact same field structure in Graylog for your K8s cluster (`k8s_prod_50:namespace`) and your Ubuntu server (`ubuntu_prod:container`).