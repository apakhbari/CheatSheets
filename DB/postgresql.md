```
 _______  _______  _______  _______  _______  ______    _______  _______  _______  ___     
|       ||       ||       ||       ||       ||    _ |  |       ||       ||       ||   |    
|    _  ||   _   ||  _____||_     _||    ___||   | ||  |    ___||  _____||   _   ||   |    
|   |_| ||  | |  || |_____   |   |  |   | __ |   |_||_ |   |___ | |_____ |  | |  ||   |    
|    ___||  |_|  ||_____  |  |   |  |   ||  ||    __  ||    ___||_____  ||  |_|  ||   |___ 
|   |    |       | _____| |  |   |  |   |_| ||   |  | ||   |___  _____| ||      | |       |
|___|    |_______||_______|  |___|  |_______||___|  |_||_______||_______||____||_||_______|
```

## List & View
\l - Display database
\c - Connect to database
\dn - List schemas
\dt - List tables inside public schemas
\dt schema1.* - List tables inside a particular schema.
                For example: 'schema1'.

## Change Password
```
ALTER USER user_name WITH PASSWORD 'new_password';
```