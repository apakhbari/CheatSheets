find /srv/gitlab/data/backups -type f -mtime +8 -name '*.tar' -execdir rm -- '{}' \;
