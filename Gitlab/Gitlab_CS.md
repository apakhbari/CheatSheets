# Gitlab
```
 _______  ___   _______  ___      _______  _______ 
|       ||   | |       ||   |    |   _   ||  _    |
|    ___||   | |_     _||   |    |  |_|  || |_|   |
|   | __ |   |   |   |  |   |    |       ||       |
|   ||  ||   |   |   |  |   |___ |       ||  _   | 
|   |_| ||   |   |   |  |       ||   _   || |_|   |
|_______||___|   |___|  |_______||__| |__||_______|
```

## Pre-Flight
1. ``` $ export GITLAB_HOME=/srv/gitlab ```
2. ``` $ sudo touch $GITLAB_HOME/backup/opt_gitlab_embedded_bin/gitaly-backup ```
3. ``` $ sudo touch $GITLAB_HOME/key/public.key ```

## Creating using Docker-compose
``` $ docker-compose -p gitlab -f /srv/gitlab/dir/docker-compose.yml up -d```

## Creating Using Terminal
- ``` $ sudo docker run --detach --hostname 192.168.2.20 --publish 443:443 --publish 80:80 --publish 22:22 --name gitlab --restart always --volume $GITLAB_HOME/config:/etc/gitlab --volume $GITLAB_HOME/logs:/var/log/gitlab --volume $GITLAB_HOME/data:/var/opt/gitlab --volume $GITLAB_HOME/backup/var_opt_gitlab_backups:/var/opt/gitlab/backups --volume $GITLAB_HOME/backup/opt_gitlab_embedded_bin/gitaly-backup:/opt/gitlab/embedded/bin/gitaly-backup --volume $GITLAB_HOME/backup/secret_gitlab:/secret/gitlab --volume $GITLAB_HOME/backup/etc_gitlab_config_backup:/etc/gitlab/config_backup --volume $GITLAB_HOME/key/public.key:/opt/gitlab/embedded/service/gitlab-rails/.license_encryption_key.pub --shm-size 256m gitlab/gitlab-ce:latest ```
- ``` $ sudo docker run --detach --hostname 192.168.2.222 --publish 443:443 --publish 80:80 --publish 22:22 --name gitlab --restart always --volume $GITLAB_HOME/config:/etc/gitlab --volume $GITLAB_HOME/logs:/var/log/gitlab --volume $GITLAB_HOME/data:/var/opt/gitlab --shm-size 256m gitlab/gitlab-ee:latest ```

Volume Mounts:
- $GITLAB_HOME/config:/etc/gitlab 
- $GITLAB_HOME/logs:/var/log/gitlab 
- $GITLAB_HOME/data:/var/opt/gitlab
- $GITLAB_HOME/key/public.key:/opt/gitlab/embedded/service/gitlab-rails/.license_encryption_key.pub  --> license key purposes

Volume Mounts For Backup purposes:
- $GITLAB_HOME/backup/var_opt_gitlab_backups:/var/opt/gitlab/backups 
- $GITLAB_HOME/backup/opt_gitlab_embedded_bin_gitaly_backup:/opt/gitlab/embedded/bin/gitaly-backup
- $GITLAB_HOME/backup/secret_gitlab:/secret/gitlab 
- $GITLAB_HOME/backup/etc_gitlab_config_backup:/etc/gitlab/config_backup

## Create Backup
1. If this directoy does not exixst, then create it: ``` $ docker exec -t <CONTAINER_NAME> mkdir -p /secret/gitlab/backups/ ```
2. ``` $ docker exec -t <CONTAINER_NAME> gitlab-backup create```
3. ``` $ docker exec -t <CONTAINER_NAME> /bin/sh -c 'gitlab-ctl backup-etc && cd /etc/gitlab/config_backup && cp $(ls -t | head -n1) /secret/gitlab/backups/' ```

## Create Backup (in recent version, script fails)
1. ``` $ docker exec -t <CONTAINER_NAME> gitlab-backup create SKIP=repositories ```
2. separately back up the ```/var/opt/gitlab/git-data/repositories``` folder
```
tar czf /srv/gitlab/backup/var_opt_gitlab_backups/"$(date '+%Y_%m_%d')_16.8.1_gitlab_backup_manual_repositories.tar.gz" /srv/gitlab/data/git-data/repositories
```

## Create Automatic Backup using crontab
- ``` $ sudo crontab -e -u root ```
```
0 4 * * * /scripts/gitlab-data-backup.sh
0 3 * * 4 /scripts/gitlab-config-backup.sh
0 5 * * * /scripts/gitlab-data-backup-manual.sh
30 5 * * * /scripts/gitlab-repo-backup-manual.sh
# 30 03 * * * /scripts/remove-older-than-10-days.sh
```
- What they do:
  - Backup application Data At 04:00 everyday ```00 04 * * * docker exec -t "$(docker container ls --all --quiet --filter "name=gitlab")" gitlab-backup create```
  - Backup configuration and secrets At 03:00 on Thursday ```00 03 * * 4 docker exec -t "$(docker container ls --all --quiet --filter "name=gitlab")" /bin/sh -c 'gitlab-ctl backup-etc && cd /etc/gitlab/config_backup && cp $(ls -t | head -n1) /secret/gitlab/backups/'```
  - Delet files oldewr than 10 days ```00 03 * * 4 find /srv/gitlab -type f -mtime +10 -name '*.gz' -execdir rm -- '{}' \;``` [find: the unix command for finding files/directories/links and etc & /path/to/: the directory to start your search in & type f: only find files & name '*.gz': list files that ends with .gz & mtime +7: only consider the ones with modification time older than 7 days & execdir ... \;: for each such result found, do the following command in .... & rm -- '{}': remove the file; the {} part is where the find result gets substituted into from the previous part. -- means end of command parameters avoid prompting error for those files starting with hyphen.]

 ## License
 - Back-up current public key: ``` /opt/gitlab/embedded/service/gitlab-rails/.license_encryption_key.pub ```
 - Inside ``` ./opt/gitlab/embedded/service/gitlab-rails/ee/app/models/license.rb ``` Modify the activation script, Change line 247 to ``` restricted_attr(:plan).presence || ULTIMATE_PLAN ```
 - uncomment and change ``` /etc/gitlab/gitlab.rb ``` number line 728: ``` gitlab_rails['initial_license_file'] = '/etc/gitlab/result.gitlab-licene' ```

## Update
1. Take a backup. As a minimum, back up the database and the GitLab secrets file.
2. Stop the running container:
```
sudo docker stop gitlab
```
3. Remove the existing container:
```
sudo docker rm gitlab
```
4. Pull the new image:
```
sudo docker pull gitlab/gitlab-ee:<version>-ee.0
```
5. Ensure that the GITLAB_HOME environment variable is defined:
```
echo $GITLAB_HOME
```
6. Create the container once again with the previously specified options.

## Runner
On amd64 Linux:
Download and install binary
```
# Download the binary for your system
$ sudo curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64

# Give it permission to execute
$ sudo chmod +x /usr/local/bin/gitlab-runner

# Create a GitLab Runner user
$ sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash

# Install and run as a service
$ sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
$ sudo gitlab-runner start
```

IMPORTANT:
- add ```privileged = true``` inside [runners.docker] in ```/etc/gitlab-runner/config.toml```
```
  [runners.docker]
    tls_verify = false
    image = "ruby:2.7"
    privileged = true
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/cache"]
    shm_size = 0
    network_mtu = 0
~                        
```
Command to register runner
```
$ sudo gitlab-runner register --url http://192.168.2.20/ --registration-token GR13489416ahexL4GUJ3BUzghppmb
```
Result would be
```
Configuration (with the authentication token) was saved in "/etc/gitlab-runner/config.toml"
```

## Cases
### ssh connection was refused
- Problem: 
```
adak@adak-HP-EliteDesk-800-G5-SFF:~$ ssh -Tv git@192.168.2.20
debug1: connect to address 192.168.2.20 port 22: Connection refused
ssh: connect to host 192.168.2.20 port 22: Connection refused
```
- Solution:
It was a permission problem. It seems that the ssh keys are saved with 0777 permission, that prevents ssh from starting.
```
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Permissions 0777 for '/etc/gitlab/ssh_host_xxxxxxx_key' are too open.
It is required that your private key files are NOT accessible by others.
This private key will be ignored.
key_load_private: bad permissions
Could not load host key: /etc/gitlab/ssh_host_xxxxxxx_key
```
login inside your dockerize Gitlab with ``` $ docker exec -it gitlab /bin/bash ```

check why is not started with ``` $ cat /var/log/gitlab/sshd/current ```

If you see similar logs a quick fix is ``` $ chmod 400 /etc/gitlab/ssh_host_* ```

Then restart ssh service with ``` $ /etc/init.d/ssh restart ```

# acknowledgment
## Contributors

APA 🖖🏻

## Links
https://hub.docker.com/r/gitlab/gitlab-ce/tags

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
