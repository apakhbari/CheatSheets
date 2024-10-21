The issue you're encountering with Zabbix appears to involve multiple problems, primarily revolving around TLS configuration and host recognition for active checks. Here are the steps you can take to resolve the situation:

### 1. **TLS Configuration Issue:**
   The error `connection of type "TLS with PSK" is not allowed for host "JAM-ZBX-1"` indicates that the server configuration does not allow connections using TLS with PSK for the specific host. To resolve this:

   - **Check the host configuration in Zabbix:** Ensure that the host "JAM-ZBX-1" is configured correctly in the Zabbix UI to use "TLS with PSK" under the host's encryption settings.
   - **Verify PSK settings:** Make sure that both the server and agent are using the same PSK (Pre-Shared Key) and that it is correctly configured on both ends. You can verify this by checking the PSK identity and PSK key in `/etc/zabbix/zabbix_agentd.conf` (on the agent) and `/etc/zabbix/zabbix_server.conf` (on the server).

   Example in `zabbix_agentd.conf`:
   ```bash
   TLSConnect=psk
   TLSAccept=psk
   TLSPSKIdentity=my_psk_id
   TLSPSKFile=/etc/zabbix/psk.key
   ```

   Example in `zabbix_server.conf`:
   ```bash
   TLSPSKIdentity=my_psk_id
   TLSPSKFile=/etc/zabbix/psk.key
   ```

   Ensure that the same `TLSPSKIdentity` and the content of the `TLSPSKFile` match between the agent and the server.

### 2. **Active Check Configuration:**
   The logs show `no active checks on server` errors, which means that the Zabbix agent is unable to connect back to the server. You can:

   - **Ensure the agent is allowed to connect:** Ensure that the Zabbix agent is correctly configured to reach the server at the specified IP address or hostname. Verify this in the `zabbix_agentd.conf` file by checking the `Server=` and `ServerActive=` directives. These should point to the correct IP address or hostname of your Zabbix server.

   - Example configuration in `zabbix_agentd.conf`:
     ```bash
     Server=172.26.213.250
     ServerActive=172.26.213.250
     ```

   - If you're using `localhost` or `127.0.0.1`, ensure that the agent is properly resolving the address and can communicate with the server on port `10051`.

### 3. **Server Host Not Found Errors:**
   The Zabbix server logs indicate errors like `cannot send list of active checks to <IP>: host [abcd] not found`. This suggests a mismatch between the hostname defined in Zabbix for the agents and what the agent is reporting to the server.

   - **Check hostname settings:** Ensure that the hostname configured on the agent matches exactly with the one defined in the Zabbix server. In `zabbix_agentd.conf`, verify the `Hostname=` setting.

     Example in `zabbix_agentd.conf`:
     ```bash
     Hostname=JAM-ZBX-1
     ```

   - Make sure the same hostname is registered in the Zabbix UI under the host configuration.

### 4. **Timeout Issue:**
   The error `cannot read response: timed out` may suggest network issues or incorrect server configurations:

   - **Increase timeout values** in the agent and server configuration files (`Timeout=` option in `zabbix_agentd.conf` and `zabbix_server.conf`). Try setting it to a higher value, e.g., `Timeout=30`.

   - **Check network connectivity:** Ensure that there is no firewall or security group blocking traffic between the Zabbix agent and server, especially on port `10051`.

### 5. **MySQL Configuration Errors:**
   The server logs show warnings related to MariaDB configuration (`parser error: Start tag expected, '<' not found`). This indicates issues with reading your MySQL/MariaDB configuration files (`/etc/mysql/mariadb.cnf`).

   - **Fix MariaDB configuration:** Check the `mariadb.cnf` file and ensure that there are no erroneous directives. You may need to review the include directives and ensure the paths and syntax are correct.

   Example configuration (`/etc/mysql/mariadb.cnf`):
   ```bash
   !include /etc/mysql/mariadb.conf.d/*.cnf
   ```

After addressing these areas, restart the Zabbix agent and server to apply the changes and check if the issue is resolved. Let me know if you need further assistance.