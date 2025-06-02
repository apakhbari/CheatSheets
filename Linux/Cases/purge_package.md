```
sudo cp -r /var/lib/mysql ./var_lib_mysql
sudo cp -r /etc/mysql ./etc_mysql

sudo apt-get purge -y libmariadb3:amd64  mariadb-backup mariadb-client-10.7 mariadb-client-core-10.7 mariadb-common mariadb-server mariadb-server-10.7 mariadb-server-core-10.7

sudo rm -rf /etc/mysql /var/lib/mysql /var/log/myqsl

sudo apt-get autoremove
sudo apt-get autoclean
sudo apt update
```