# Installing and configuring
- - - Installing Squid on Debian 
Squid package is included in the standard on Debian 10 repositories. Run the following commands as sudo user to install Squid:

```bash
sudo apt update
sudo apt install squid
```
- - - Check for status

```bash
sudo systemctl status squid
```
- out
```bash
● squid.service - LSB: Squid HTTP Proxy version 3.x
   Loaded: loaded (/etc/init.d/squid; generated)
   Active: active (running) since Sat 2019-08-03 08:52:47 PDT; 3s ago
...
```

