Q: 

To install a specific version of Zabbix Server (like `1:6.0.6-1+ubuntu18`) on Ubuntu 18, you can follow these steps:

1. **Add Zabbix Repository**  
   First, you'll need to add the Zabbix repository that contains the version you want. Zabbix provides repositories for different distributions and versions. For Zabbix 6.0, use the following commands:

   ```bash
   wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-1%2Bubuntu18.04_all.deb
   sudo dpkg -i zabbix-release_6.0-1+ubuntu18.04_all.deb
   sudo apt update
   ```

2. **Install Specific Zabbix Server Version**
   Once you've added the Zabbix repository, you can install the specific version of the `zabbix-server-pgsql` package.

   ```bash
   sudo apt install zabbix-server-pgsql=1:6.0.6-1+ubuntu18.04
   ```

3. **Install Required Packages**
   You will also need to install other required Zabbix components, such as the frontend and agent:

   ```bash
   sudo apt install zabbix-frontend-php zabbix-agent
   ```

4. **Configure Zabbix Server**
   Edit the Zabbix server configuration file (`/etc/zabbix/zabbix_server.conf`) to set the correct database settings, such as PostgreSQL username, password, and database name.

   ```bash
   sudo nano /etc/zabbix/zabbix_server.conf
   ```

   Ensure that the correct PostgreSQL database information is set:
   ```bash
   DBHost=localhost
   DBName=zabbix
   DBUser=zabbix
   DBPassword=<your_password>
   ```

5. **Initialize Database**
   Run the following commands to set up the Zabbix database in PostgreSQL:

   ```bash
   sudo -u postgres createuser --pwprompt zabbix
   sudo -u postgres createdb -O zabbix zabbix
   zcat /usr/share/doc/zabbix-server-pgsql*/create.sql.gz | sudo -u zabbix psql zabbix
   ```

6. **Start and Enable Zabbix Server**
   Once the configuration is complete, start the Zabbix server and enable it to start at boot:

   ```bash
   sudo systemctl start zabbix-server
   sudo systemctl enable zabbix-server
   ```

7. **Access Zabbix Web Interface**
   Configure your web server (Nginx or Apache) to serve the Zabbix frontend, and access the web interface to finish the setup.

   Once the installation is done, you can access Zabbix through your browser:  
   `http://<server_ip_or_domain>/zabbix`.

Let me know if you need further details on configuring the web server or setting up PostgreSQL!


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Q: regarding of executing: zcat /usr/share/doc/zabbix-sql-scripts/postgresql/schema.sql.gz | sudo -u zabbix psql zabbix
gzip: /usr/share/doc/zabbix-sql-scripts/postgresql/schema.sql.gz: No such file or directory

what went wrong and how to fix it?
Also contents of /usr/share/doc/zabbix-sql-scripts/postgresql/ directory are:
double.sql              proxy.sql               timescaledb.sql
history_pk_prepare.sql  server.sql.gz

To install all the required Zabbix packages for version `1:6.0.6-1+ubuntu18` on Ubuntu 18.04, you can follow these steps. This guide will ensure that all packages, including `zabbix-frontend-php`, `php7.2-pgsql`, `zabbix-nginx-conf`, `zabbix-sql-scripts`, and `zabbix-agent`, are installed for the specified version.

### 1. Add Zabbix Repository

First, add the official Zabbix repository for Ubuntu 18.04 to install version 6.0.6:

```bash
wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-1%2Bubuntu18.04_all.deb
sudo dpkg -i zabbix-release_6.0-1+ubuntu18.04_all.deb
sudo apt update
```

### 2. Install Specific Versions of the Packages

Now install the specific versions of the required packages. Use the `=1:6.0.6-1+ubuntu18.04` suffix to make sure you are installing version 6.0.6:

```bash
sudo apt install zabbix-server-pgsql=1:6.0.6-1+ubuntu18.04 \
                 zabbix-frontend-php=1:6.0.6-1+ubuntu18.04 \
                 zabbix-nginx-conf=1:6.0.6-1+ubuntu18.04 \
                 zabbix-sql-scripts=1:6.0.6-1+ubuntu18.04 \
                 zabbix-agent=1:6.0.6-1+ubuntu18.04
```

### 3. Install PHP and PostgreSQL Extensions

Next, install the required PHP version (`php7.2`) and PostgreSQL extension for PHP:

```bash
sudo apt install php7.2 php7.2-pgsql
```

### 4. Configure Zabbix

After installing all the packages, configure the Zabbix server and frontend.

#### Zabbix Server Configuration:
Edit the Zabbix server configuration file:

```bash
sudo nano /etc/zabbix/zabbix_server.conf
```

Ensure that you configure PostgreSQL details like `DBHost`, `DBName`, `DBUser`, and `DBPassword`:

```bash
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=<your_password>
```

#### Zabbix Frontend Configuration:
Edit the PHP configuration for Zabbix by adjusting the time zone in `/etc/zabbix/php-fpm.conf`:

```bash
sudo nano /etc/zabbix/php-fpm.conf
```

Uncomment and set the appropriate time zone:

```bash
php_value[date.timezone] = Europe/London  # Set your correct timezone
```

### 5. Initialize Zabbix Database

Run the following commands to create a PostgreSQL user and database for Zabbix:

```bash
sudo -u postgres createuser --pwprompt zabbix
sudo -u postgres createdb -O zabbix zabbix
```

Import the initial Zabbix database schema:

```bash
zcat /usr/share/doc/zabbix-sql-scripts/postgresql/schema.sql.gz | sudo -u zabbix psql zabbix
```

### 6. Start and Enable Zabbix Services

Start the Zabbix services and enable them to start on boot:

```bash
sudo systemctl start zabbix-server zabbix-agent zabbix-frontend-php
sudo systemctl enable zabbix-server zabbix-agent zabbix-frontend-php
```

### 7. Set Up Nginx for Zabbix

If you're using Nginx for the Zabbix frontend, configure it using the default Zabbix configuration (`/etc/nginx/conf.d/zabbix.conf`).

Ensure your `server` block looks similar to this:

```bash
server {
    listen          80;
    server_name     your_server_name;

    root            /usr/share/zabbix;

    index           index.php;
    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        fastcgi_pass   unix:/run/php/php7.2-fpm.sock;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }
}
```

### 8. Access Zabbix Web Interface

Once the setup is complete, you can access the Zabbix frontend using a browser by visiting:

```
http://<server_ip_or_domain>/zabbix
```

Let me know if you need further assistance!

---
## PostgreSQL Database Monitoring
### Add PostgreSQL Read-Only User

```
sudo -u postgres psql
```

- Add the user.
```
CREATE USER zbx_monitor WITH PASSWORD '<PASSWORD>' INHERIT;
GRANT pg_monitor TO zbx_monitor;
```

- Confirm user exists
```
select * from pg_catalog.pg_user;
```



thisisforapatest

### Set Up Zabbix PostgreSQL Template Dependencies
- Now to download the Zabbix repository from GitHub. This contains the PostgreSQL database queries used by the template that we will import into Zabbix.
```
git clone https://github.com/zabbix/zabbix.git --depth 1
```
- We now need to copy the ./zabbix/templates/db/postgresql/ folder and contents to the /var/lib/zabbix/ folder.
```
mkdir /var/lib/zabbix
cp -r ./zabbix/templates/db/postgresql/. /var/lib/zabbix/
cd /var/lib/zabbix
ls
```

- We also need to copy just the template_db_postgresql.conf file to /etc/zabbix/zabbix_agentd.d/
```
cp /var/lib/zabbix/template_db_postgresql.conf /etc/zabbix/zabbix_agentd.d/
cd /etc/zabbix/zabbix_agentd.d/
ls
```

### Configure PostgreSQL ```pg_hba.conf``` File
- Now we need to edit the ```pg_hba.conf``` to allow the zbx_monitor user to connect.
```- sudo nano /etc/postgresql/14/main/pg_hba.conf```

- Add these lines to the end
```
host all zbx_monitor 127.0.0.1/32 trust
host all zbx_monitor 0.0.0.0/0 md5
host all zbx_monitor ::0/0 md5
```

### Configure Host and Template in Zabbix
- Restart Zabbix Agent and check status.
```
sudo service zabbix-agent restart
sudo service zabbix-agent status
```

- Go into Zabbix and create a new host named 'postgresql'.
- Assign the template PostgeSQL by Zabbix agent.
- Add to any group you desire. Templates/Databases is a good option.
- Add an Agent interface, and set the IP address of your PostgreSQL server.
- Select the Macros tab and check/set each macro key. (Most keys will be already set to the correct value)

|    Macro key   |                                Value                                |
|:--------------:|:-------------------------------------------------------------------:|
|   {$PG.HOST}   |                              127.0.0.1                              |
| {$PG.PORT}     | 5432                                                                |
| {$PG.USER}     | zbx_monitor                                                         |
| {$PG.PASSWORD} | the same password you used above when creating zbx_monitor the user |
|    {$PG.DB}    |                               postgres                              |

- Press Update and after some time, you will see new values populating in Monitoring → Latest Data