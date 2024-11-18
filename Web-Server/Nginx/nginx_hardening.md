# Nginx
```
 __    _  _______  ___   __    _  __   __ 
|  |  | ||       ||   | |  |  | ||  |_|  |
|   |_| ||    ___||   | |   |_| ||       |
|       ||   | __ |   | |       ||       |
|  _    ||   ||  ||   | |  _    | |     | 
| | |   ||   |_| ||   | | | |   ||   _   |
|_|  |__||_______||___| |_|  |__||__| |__|
```

# Overview

- **Apache** is thread-based, while **NGINX** is worker-based. It implements the C10K problem, allowing for 10,000 concurrent connections.

## Process Architecture

- **Master Process** → **Child Process** (in RAM) → **Workers** (as many as CPU cores)
  - Workers have shared memory for handling sessions.
  - Each worker has its own threads.
  
### Workers

- Each worker includes:
  1. Cache Manager
  2. Cache Loader
- Handles rate limiting and session definitions.

**Tip:** If running NGINX on SELinux, set `execmem` boolean to true and enable `http_setrlimit`.

## Memory and Connection Management

- NGINX loads content into RAM.
- Each connection is considered an open file.

### Process Status

- To view NGINX processes:
  ```bash
  $ ps -aux | grep nginx
  ```
  - The master process runs as root (due to privileged ports), while worker processes run under the `nginx` user.

### Header Information

- To check response headers:
  ```bash
  $ curl -I my.server.com
  ```
  - If not hardened, the NGINX version will be displayed.

## Compiling NGINX Without Version Exposure

- To hide the version:
  ```bash
  $ vim /root/nginx/src/ngx_http_header_filter_module.c  # Lines 49-51
  $ vim /root/nginx/src/core/nginx.h                      # Change NGINX to IIS
  $ vim /etc/nginx/nginx.conf
  ```

### Configuration Changes

- Update line 14 to set the number of open files:
  ```nginx
  events {
      worker_connections 4096;  # Prevents slow HTTP
  }
  ```

- Update line 23 to disable server tokens:
  ```nginx
  http {
      server_tokens off;  # Removes version info
  }
  ```

## Controlling Buffer Overflow Attacks

```nginx
http {
    client_body_buffer_size 128k;
    client_header_buffer_size 2k;
    large_client_header_buffers 4 8k;
}
```

## Syntax Check

- To check NGINX configuration for syntax errors:
  ```bash
  $ nginx -t
  ```

## Timeout Settings

```nginx
client_body_timeout 30s;
client_header_timeout 30s;
keepalive_timeout 45s;
```

## HTTP Headers

- **X-Forwarded-For (XFF)**: Indicates the original IP of a user when a request is sent through a CDN.
- **Referrer Header**: Indicates the source from where the user landed on your site, e.g., `google.com`.

## Limiting Concurrent Connections

```nginx
http {
    limit_conn_zone $binary_remote_addr zone=one:10m;  # 10MB storage

    server {
        limit_conn one 40;  # Limits to 40 concurrent connections
    }
}
```

## Limiting Request Rate

```nginx
http {
    limit_req_zone $binary_remote_addr zone=two:10m rate=250r/s;

    location / {
        limit_req zone=two;  # Apply rate limiting
    }
}
```

## Limiting Request Methods

```nginx
location / {
    limit_except HEAD POST {
        deny all;  # Deny all except HEAD and POST
    }
}
```

## Limiting User Agents

For enterprise use, avoid this due to overhead:

```nginx
location / {
    if ($http_user_agent ~* (wget|curl|acunetix|mirai|nessus)) {
        return 444;  # Block specified user agents
    }
}
```

#### Example Command

```bash
$ curl --user-agent "jafar" -X GET 127.0.0.1
```

## Security Headers

- Avoid clickjacking:
  ```nginx
  http {
      add_header X-Frame-Options SAMEORIGIN;
  }
  ```

- Prevent content type sniffing:
  ```nginx
  http {
      add_header X-Content-Type-Options nosniff;
  }
  ```

- Protect against XSS attacks:
  ```nginx
  add_header X-XSS-Protection "1; mode=block";
  ```

- **HSTS**: Force users to access your site over HTTPS (port 443).
  
- **Content Security Policy (CSP)** header: 
  ```nginx
  # Configuration for CSP should be added here
  ```