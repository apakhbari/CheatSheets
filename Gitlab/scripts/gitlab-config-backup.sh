docker exec -t "$(docker container ls --all --quiet --filter "name=gitlab")" /bin/sh -c 'gitlab-ctl backup-etc && cd /etc/gitlab/config_backup && cp $(ls -t | head -n1) /secret/gitlab/backups/'