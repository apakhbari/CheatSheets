- Search for your timezone
```
timedatectl list-timezones
```

- Set your timezone
```
sudo timedatectl set-timezone Asia/Tehran
```

- Enable timesyncd. With this, time should be set and synchronized.
```
sudo timedatectl set-ntp on
```