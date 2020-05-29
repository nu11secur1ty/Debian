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
http_port 3128
```
Running Squid on all interfaces and on the default port should be fine for most users.

The Access Control Lists (ACLs) allows you to control how the clients can access web resources. By default, Squid allows access only from the localhost.

If all of the clients that will use the proxy have a static IP address the simplest option is to create an ACL that will include the allowed IPs.

Instead of adding the IP addresses in the main configuration file we will create a new include file that will store the IP addresses:

- - - Restart service

```bash
sudo service squid restart
````
# Allow All Traffic

```bash
 http_access allow all
 #http_access deny all
```
# Block Specific Website with Squid

Create a file `/etc/squid/blockwebsites.lst` and put domain names one per line and add below rule in the squid configuration file.


```bash
acl blocksitelist dstdomain "/etc/squid/blockwebsites.lst"
http_access deny blocksitelist
```

- - - blockwebsites.lst file content example:

```bash
cat /etc/squid/blockwebsites.lst

yahoo.com
www.rediff.com
```

# Block Specific Keyword with Squid

Add below rules to block specific website before any allow all rules. Below example will block all pages having keyword yahoo or Gmail.

```
acl blockkeyword1 url_regex yahoo
acl blockkeyword2 url_regex gmail
http_access deny blockkeyword1
http_access deny blockkeyword2
```

If you have a long list of keywords, Create a file `/etc/squid/blockkeywords.lst` and put keywords one per line and add below rule in the squid configuration file.

```
acl blockkeywordlist url_regex "/etc/squid/blockkeywords.lst"
http_access deny blockkeywordlist
```
- - - blockkeywords.lst file content example:

```
cat /etc/squid/blockkeywords.lst

yahoo
gmail
facebook
```
# Good luck =)
