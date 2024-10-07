To ensure that all connections are encrypted and utilize TLS/SSL, you will need to:

1. Set up TLS certificates for the Zabbix web interface (nginx).
2. Enable encrypted connections for PostgreSQL.
3. Optionally configure the Zabbix server and agent to use encryption for communication.

Here’s the modified `docker-compose.yml` with the changes needed:

### Updated `docker-compose.yml` for HTTPS/TLS encryption:

```yaml
version: '3.7'
services:
  zabbix-server:
    image: zabbix/zabbix-server-pgsql:7.0-ubuntu-latest
    container_name: zabbix-server-pgsql
    ports:
      - "10055:10051"
    environment:
      - DB_SERVER_HOST=postgresql
      - POSTGRES_USER=zabbix
      - POSTGRES_PASSWORD=yourpassword
      - POSTGRES_DB=zabbix_db
      - ZBX_TLSCONNECT=psk    # Configure for PSK-based TLS
      - ZBX_TLSPSKIDENTIFIER=PSK_001  # Define your PSK identifier
      - ZBX_TLSPSK=yourpsksecret  # Replace with your actual PSK
    depends_on:
      - postgresql
    volumes:
      - /home/apa/docker_vol/zabbix/data:/var/lib/zabbix
    restart: unless-stopped

  postgresql:
    image: postgres:15.8-bookworm
    container_name: pgsql-dev
    ports:
      - "5435:5432"
    environment:
      - POSTGRES_USER=zabbix
      - POSTGRES_PASSWORD=yourpassword
      - POSTGRES_DB=zabbix_db
      - POSTGRES_INITDB_ARGS=--data-checksums
    volumes:
      - /home/apa/docker_vol/postgres/data:/var/lib/postgresql/data
    restart: unless-stopped

  zabbix-web-nginx-pgsql:
    image: zabbix/zabbix-web-nginx-pgsql:7.0-ubuntu-latest
    container_name: zabbix-web
    ports:
      - "8443:8443"  # HTTPS only
    environment:
      - DB_SERVER_HOST=postgresql
      - POSTGRES_USER=zabbix
      - POSTGRES_PASSWORD=yourpassword
      - POSTGRES_DB=zabbix_db
      - ZBX_SERVER_HOST=zabbix-server-pgsql
      - VIRTUAL_HOST=yourdomain.com  # Use your domain or IP
      - LETSENCRYPT_HOST=yourdomain.com  # Use for Let's Encrypt
      - LETSENCRYPT_EMAIL=youremail@domain.com
    depends_on:
      - zabbix-server
      - postgresql
    volumes:
      - /etc/nginx/certs:/etc/nginx/certs:ro  # Your TLS certificates
      - /etc/nginx/conf.d:/etc/nginx/conf.d:ro  # Nginx config
    restart: unless-stopped

  zabbix-agent2:
    image: zabbix/zabbix-agent2:7.0-ubuntu-latest
    container_name: zabbix-agent2
    environment:
      - ZBX_SERVER_HOST=zabbix-server-pgsql
      - ZBX_LISTEN_PORT=10060
      - ZBX_TLSCONNECT=psk    # Enable PSK encryption
      - ZBX_TLSPSKIDENTIFIER=PSK_001  # Define PSK identifier
      - ZBX_TLSPSK=yourpsksecret  # Replace with your actual PSK
    depends_on:
      - zabbix-server
    ports:
      - "10060:10060"
    restart: unless-stopped
```

### Key Changes:

1. **TLS/SSL Certificates for Nginx (Zabbix Web Interface)**:
   - The Zabbix web service is now only exposing the HTTPS port (`8443`).
   - You’ll need to mount your TLS certificates into the Nginx container. This example assumes you’ll store your certificates in `/etc/nginx/certs`.
   - Use Let’s Encrypt (or any other method) to manage the certificates. If using Let’s Encrypt, you'll need a reverse proxy like Traefik or Nginx Proxy Manager to handle the certificate management.

2. **Encrypted PostgreSQL Connections**:
   - PostgreSQL can be configured to require SSL/TLS connections. This would involve generating and installing SSL certificates on the PostgreSQL server and configuring the `postgresql.conf` and `pg_hba.conf` files to enforce TLS connections.
   - Depending on your needs, you can add custom PostgreSQL configuration via volumes for SSL settings.

3. **PSK Encryption for Zabbix Server-Agent Communication**:
   - The Zabbix server and agent are configured to use Pre-Shared Key (PSK) encryption for secure communication. Replace `yourpsksecret` with your actual PSK.
   - TLS/SSL encryption between the Zabbix server and its clients is established using PSK. You can also configure certificate-based TLS if desired.

These changes make the connections between your services secure, ensuring that data is transmitted using encryption methods.