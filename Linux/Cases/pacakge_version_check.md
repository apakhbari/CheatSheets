0. List all installed packages
```
apt list
```

1. Find installed version
1.1. dpkg
Use dpkg -l pkg-name to get package version, e.g:
```
$ dpkg -l firefox
```
it's going to give you some information:
```
||/ Name         Version                  Architecture    Description
+++-==========================================================================
ii  firefox      53.0.3+build1-0ubuntu0.  amd64           Safe and easy web brow
```
1.2. pkg --version
Depends on your package switches like -v or --version might be available to you:
```
firefox -v
```

2. Last available version
2.1. apt show
Then use sudo apt update to make sure your sources are up to date, and use apt show firefox | grep -i version to see the last version available.

2.2. Ubuntu packages database
You can also check https://packages.ubuntu.com to search for your package version.

2.3. apt changelog
As an alternative you can use apt changelog pkg-name, e.g apt changelog firefox this will connect to internet to get the last "change log" data so you don't have to update your sources for using this command.

2.4. rmadison
The other option is rmadison, it remotely query the archive database about a packages, so you don't have to update your source in this option.

First install its package: sudo apt install devscripts, then use it like:
```
 rmadison -s zesty -a amd64  wget
 ```
it give you last available version of wget for "zesty" and "amd64" architecture