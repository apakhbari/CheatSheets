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

---

Here’s how you can **check the version** of a package on your Ubuntu server and **install a specific version** if needed.

---

## **1. Check the Installed Version of a Package**

Use the `dpkg` or `apt` commands: 

### Method 1: Using `dpkg`
```bash
dpkg -l | grep <package_name>
```
This will show details of the installed package, including the version.

### Method 2: Using `apt`
```bash
apt list --installed | grep <package_name>
```
This command lists installed packages along with their versions.

Example:
```bash
apt list --installed | grep nginx
```

---

## **2. List Available Versions of a Package**

To see all versions available from your repositories, use:
```bash
apt policy <package_name>
```

Example:
```bash
apt policy nginx
```

Output:
```
nginx:
  Installed: 1.18.0-0ubuntu1
  Candidate: 1.18.0-0ubuntu2
  Version table:
     1.18.0-0ubuntu2 500
        500 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 Packages
     1.18.0-0ubuntu1 500
        500 http://archive.ubuntu.com/ubuntu focal/main amd64 Packages
```

---

## **3. Install a Specific Version of a Package**

If you found the specific version you want, you can install it by specifying the version.

```bash
sudo apt install <package_name>=<version>
```

Example:
```bash
sudo apt install nginx=1.18.0-0ubuntu1
```

---

## **4. Prevent a Package from Upgrading**

To prevent the package from upgrading after installing a specific version, use the `hold` option:

```bash
sudo apt-mark hold <package_name>
```

To release the hold and allow updates again:
```bash
sudo apt-mark unhold <package_name>
```

---

## **5. If the Version is Not in Repositories**

1. **Check Older Versions:**  
   You might need to enable additional repositories (like `universe` or `old-releases`).
   ```bash
   sudo add-apt-repository universe
   sudo apt update
   ```

2. **Manual Download:**  
   If the version isn’t available via repositories, download the `.deb` file manually from a package archive (like https://packages.ubuntu.com/) and install it:
   ```bash
   wget http://archive.ubuntu.com/ubuntu/pool/main/n/nginx/nginx_1.18.0-0ubuntu1_amd64.deb
   sudo dpkg -i nginx_1.18.0-0ubuntu1_amd64.deb
   ```

---

Let me know if you encounter any issues!