The error indicates that the `zbx_monitor` user is attempting to connect to PostgreSQL, but the password authentication is failing. To fix this, follow these steps:

### Steps to Fix the Password Authentication Issue:

1. **Verify the `zbx_monitor` User's Password**:
   - Ensure that the password you are using for the `zbx_monitor` user is correct. You can reset the password in PostgreSQL if necessary.
   - To reset the password for `zbx_monitor`, log into PostgreSQL with an administrative user (e.g., `postgres`):
     ```bash
     psql -U postgres -d postgres
     ```
     Then run the following SQL command to set a new password:
     ```sql
     ALTER USER zbx_monitor WITH PASSWORD 'new_password';
     ```
     Replace `'new_password'` with the desired password.

2. **Check the `pg_hba.conf` File**:
   - PostgreSQL uses the `pg_hba.conf` file to control how clients authenticate. Ensure that the file allows the `zbx_monitor` user to connect from `localhost` using password authentication.
   - Open the `pg_hba.conf` file, usually located in `/etc/postgresql/<version>/main/` or `/var/lib/pgsql/<version>/data/`, and check for a line like this:
     ```
     host    all             zbx_monitor     127.0.0.1/32            md5
     ```
   - If this line is missing or misconfigured, add or correct it to allow password authentication for `zbx_monitor` from `localhost` using `md5` (or `scram-sha-256` if your setup uses it).
   - After modifying `pg_hba.conf`, reload PostgreSQL to apply the changes:
     ```bash
     sudo systemctl reload postgresql
     ```

3. **Update the Zabbix Agent Configuration**:
   - If you are using a custom password for the `zbx_monitor` user in the Zabbix agent configuration, make sure it matches the one you set in PostgreSQL.
   - Verify that the `UserParameter` (if used) or the Zabbix template for PostgreSQL monitoring contains the correct username and password. If necessary, add or update the password:
     ```ini
     UserParameter=pgsql.connections[*],psql -h $1 -p $2 -U $3 -d $4 -W "your_password" -c "SELECT count(*) FROM pg_stat_activity;"
     ```
     Alternatively, you can configure `.pgpass` for automatic password authentication (see the next step).

4. **Use `.pgpass` for Automatic Authentication** (optional):
   - You can configure a `.pgpass` file in the home directory of the Zabbix agent user to store the password securely, avoiding the need to specify it in commands.
   - Create a `.pgpass` file in the Zabbix user's home directory (`/home/zabbix/.pgpass`):
     ```
     localhost:5432:postgres:zbx_monitor:your_password
     ```
   - Set the correct permissions for the `.pgpass` file:
     ```bash
     chmod 600 /home/zabbix/.pgpass
     ```
   - Ensure that the Zabbix agent runs as the correct user and has access to this file.

5. **Test the Connection**:
   - After updating the password or configuration, test the connection again:
     ```bash
     psql -h localhost -p 5432 -U zbx_monitor -d postgres
     ```

If the connection succeeds, Zabbix should now be able to gather data from PostgreSQL. Let me know if this resolves the issue or if further adjustments are needed!


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

To resolve the authentication issue and allow the `zbx_monitor` user to connect via password authentication, we'll need to modify the `pg_hba.conf` file to permit `zbx_monitor` to connect using `scram-sha-256` or `md5`, depending on the authentication method you've set for this user.

Here’s the updated `pg_hba.conf` file with the necessary changes:

```conf
# Database administrative login by Unix domain socket
local   all             postgres                                peer

# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             all             127.0.0.1/32            scram-sha-256
# IPv6 local connections:
host    all             all             ::1/128                 scram-sha-256

# Allow zbx_monitor user to connect from localhost using scram-sha-256
host    all             zbx_monitor     127.0.0.1/32            scram-sha-256

# Allow replication connections from localhost, by a user with the
# replication privilege.
local   replication     all                                     peer
host    replication     all             127.0.0.1/32            scram-sha-256
host    replication     all             ::1/128                 scram-sha-256
```

### Key Changes:
1. **Added specific entry for `zbx_monitor`**:
   - The line `host    all    zbx_monitor    127.0.0.1/32    scram-sha-256` allows the `zbx_monitor` user to authenticate using `scram-sha-256` on `localhost`.

### Next Steps:
1. **Reload PostgreSQL**:
   - After updating `pg_hba.conf`, reload PostgreSQL to apply the changes:
     ```bash
     sudo systemctl reload postgresql
     ```

2. **Test the Connection Again**:
   - After reloading, test the connection:
     ```bash
     psql -h localhost -p 5432 -U zbx_monitor -d postgres
     ```

3. **Verify Password Type**:
   - If you encounter further authentication issues, ensure that the `zbx_monitor` user's password is using `scram-sha-256`. You can reset the password to force the encryption type:
     ```sql
     ALTER USER zbx_monitor WITH PASSWORD 'your_password' ENCRYPTED USING 'scram-sha-256';
     ```

Let me know if the connection succeeds with these changes!