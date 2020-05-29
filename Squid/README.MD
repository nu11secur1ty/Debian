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
# Configuring Squid 

Squid can be configured by editing the `/etc/squid/squid.conf` configuration file. Separate configuration files can be included using the “include” directive.
The `squid.conf` configuration file includes comments describing what each configuration option does.

- Before making any changes, it is always a good idea to back up the original file:

```bash
sudo cp /etc/squid/squid.conf{,.orginal}
```

- - - Configure

```bash
vim  /etc/squid/squid.conf
```

By default, Squid listens on port `3128` on all network interfaces.

If you want to change the port and set a listening interface, locate the line starting with `http_port` and specify the interface IP address and the new port. If no interface is specified Squid will listen on all interfaces.

```
# Squid normally listens to port 3128
http_port IP_ADDR:PORT
```
Running Squid on all interfaces and on the default port should be fine for most users.

The Access Control Lists (ACLs) allows you to control how the clients can access web resources. By default, Squid allows access only from the localhost.

If all of the clients that will use the proxy have a static IP address the simplest option is to create an ACL that will include the allowed IPs.

Instead of adding the IP addresses in the main configuration file we will create a new include file that will store the IP addresses:

```bash
vim /etc/squid/allowed_ips.txt
```











