It seems I misunderstood your requirement initially. Since Zabbix does not provide an official Docker image for Zabbix Proxy with PostgreSQL, you will need to create the image from scratch. Here's how you can do that.

### Step 1: Create the `Dockerfile`
You can base your Dockerfile on a minimal image (like Ubuntu or Alpine) and install the necessary Zabbix Proxy components along with PostgreSQL client tools.

Here's an example of a `Dockerfile` that installs Zabbix Proxy and configures it with PostgreSQL support:

```Dockerfile
# Use a lightweight base image
FROM ubuntu:22.04

# Set environment variables for PostgreSQL
ENV DB_SERVER_HOST=postgresql-server \
    DB_SERVER_PORT=5432 \
    POSTGRES_DB=zabbix \
    POSTGRES_USER=zabbix \
    POSTGRES_PASSWORD=zabbixpassword

# Install necessary packages
RUN apt-get update && \
    apt-get install -y wget gnupg2 postgresql-client lsb-release && \
    wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4+ubuntu$(lsb_release -sr)_all.deb && \
    dpkg -i zabbix-release_6.0-4+ubuntu$(lsb_release -sr)_all.deb && \
    apt-get update && \
    apt-get install -y zabbix-proxy-pgsql

# Copy your custom Zabbix Proxy configuration
COPY zabbix_proxy.conf /etc/zabbix/zabbix_proxy.conf

# Expose Zabbix Proxy port
EXPOSE 10051

# Set entrypoint to run Zabbix Proxy
ENTRYPOINT ["zabbix_proxy", "--foreground"]

# Default command
CMD ["-c", "/etc/zabbix/zabbix_proxy.conf"]
```

### Step 2: Build the Docker image
Once you've created the `Dockerfile`, you can build the image using the following command:

```bash
docker build -t my-zabbix-proxy-pgsql .
```

### Step 3: Prepare `docker-compose.yml` (Optional)
If you want to manage PostgreSQL and Zabbix Proxy together using Docker Compose, here is an example `docker-compose.yml` file:

```yaml
version: '3'
services:
  zabbix-proxy:
    build: .
    container_name: zabbix-proxy
    environment:
      DB_SERVER_HOST: postgres
      DB_SERVER_PORT: 5432
      POSTGRES_DB: zabbix
      POSTGRES_USER: zabbix
      POSTGRES_PASSWORD: zabbixpassword
    ports:
      - "10051:10051"
    depends_on:
      - postgres
    volumes:
      - ./zabbix_proxy.conf:/etc/zabbix/zabbix_proxy.conf

  postgres:
    image: postgres:15.8-bookworm
    environment:
      POSTGRES_DB: zabbix
      POSTGRES_USER: zabbix
      POSTGRES_PASSWORD: zabbixpassword
    ports:
      - "5432:5432"
    volumes:
      - ./postgres-data:/var/lib/postgresql/data
```

### Step 4: Start the Services
After preparing the Dockerfile and `docker-compose.yml`, you can start the services:

1. **Build the Zabbix Proxy image:**
   ```bash
   docker-compose build
   ```

2. **Start the services:**
   ```bash
   docker-compose up -d
   ```

### Step 5: Configuration (`zabbix_proxy.conf`)
Make sure you have a valid `zabbix_proxy.conf` file. Here’s an example configuration for Zabbix Proxy with PostgreSQL:

```ini
# Zabbix Proxy configuration

# Database connection parameters
DBHost=postgres
DBName=zabbix
DBUser=zabbix
DBPassword=zabbixpassword

# Log to console
LogType=console

# Server details
Server=zabbix-server-address
Hostname=my-zabbix-proxy

# ProxyMode: 0 - active, 1 - passive
ProxyMode=0
```

### Step 6: Additional Considerations

1. **Persistent Data**: PostgreSQL should use a volume to persist its data (`postgres-data`), so you don’t lose data when containers are restarted.
2. **Zabbix Proxy Logs**: Ensure you capture logs properly and monitor the Proxy for any database connection or other runtime issues.
3. **Database Performance**: Monitor your PostgreSQL instance for performance bottlenecks, as Zabbix Proxy can generate significant load.

### Things to Be Concerned About:
- **PostgreSQL Performance**: Ensure your PostgreSQL instance is optimized for the expected load.
- **Scaling**: If you expect a large amount of data from monitored hosts, ensure that your Docker resources (CPU, memory, disk I/O) are sufficient for both Zabbix Proxy and PostgreSQL.
- **Security**: Secure the PostgreSQL instance by properly setting up user permissions and strong passwords. You may want to use Docker secrets for passing credentials securely.

Once everything is running, monitor the logs and fine-tune the configuration to fit your use case. Let me know if you encounter any issues or need further customization.