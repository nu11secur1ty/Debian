# Install DNS Server
```bash
apt install -y bind9 bind9utils bind9-doc dnsutils
```
# Configure DNS Server
The `/etc/bind/` is the configuration directory of bind9, holds configuration files and zone lookup files. The global configuration file is `/etc/bind/named.conf`.

- Create Zones:

Let us begin by creating a forward zone for your domain.
You should not use the global configuration file for the local DNS zone rather you can use `/etc/bind/named.conf.local` file.

```bash
vim /etc/bind/named.conf.local
```

# Forward Zone

The following is the forward zone entry for the `yourzone.local` domain in the `named.conf.local` file.

```bash
zone "yourzone.local" IN { //Domain name

     type master; //Primary DNS

     file "/etc/bind/forward.yourzone.local.db"; //Forward lookup file

     allow-update { none; }; // Since this is the primary DNS, it should be none.

};
```

# Reverse Zone

The following is for the reverse zone in the named.conf.local file.

```bash
zone "0.168.192.in-addr.arpa" IN { //Reverse lookup name, should match your network in reverse order

     type master; // Primary DNS

     file "/etc/bind/reverse.yourzone.local.db"; //Reverse lookup file

     allow-update { none; }; //Since this is the primary DNS, it should be none.

};
```

# Create Zone lookup file

Once zones are created, you can go ahead and create zone data files for the forward zone and reverse zone.

- Forward Zone

Copy the sample entries to zone file called forward.yourzone.local.db for the forward zone under /etc/bind directory.

Record types in the zone file,

SOA – Start of Authority
NS – Name Server
A – A record
MX – Mail for Exchange
CN – Canonical Name

Domain names should end with a dot (.).

```bash
cp /etc/bind/db.local /etc/bind/forward.yourzone.local.db
```

- Edit the zone.

```bash
vim /etc/bind/forward.yourzone.local.db
```
Update the content as shown below.

```xml
Whenever you change any records in the lookup file, make sure you update the serial number to some random number, higher than current.
```

```bash
;
; BIND data file for local loopback interface
;
$TTL    604800zone yourzone.local/IN: loaded serial 2
OK
@       IN      SOA     ns1.yourzone.local. root.yourzone.local. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
; Commentout below three lines
;@      IN      NS      localhost.
;@      IN      A       127.0.0.1
;@      IN      AAAA    ::1

;Name Server Information

@       IN      NS      ns1.yourzone.local.

;IP address of Name Server

ns1     IN      A       192.168.0.10

;Mail Exchanger

yourzone.local.   IN     MX   10   mail.yourzone.local.

;A – Record HostName To Ip Address

www     IN       A      192.168.0.100
mail    IN       A      192.168.0.150

;CNAME record

ftp     IN      CNAME   www.yourzone.local.
```

# Reverse Zone

Copy the sample entries to zone file called `reverse.yourzone.local.db` for the reverse zone under `/etc/bind` directory and create reverse pointers for the above forward zone records.

PTR – Pointer
SOA – Start of Authority

```bash
cp /etc/bind/db.127 /etc/bind/reverse.yourzone.local.db
```

Edit the reverse zone file.

```bash
vim /etc/bind/reverse.yourzone.local.db
```
Update the content as shown below.

```xml
Whenever you change any records in the lookup file, make sure you update the serial number to some random number, higher than current.
```

```bash
;
; BIND reverse data file for local loopback interface
;
$TTL    604800
@       IN      SOA     yourzone.local. root.yourzone.local. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
; Commentout below two lines

;@      IN      NS      localhost.
;1.0.0  IN      PTR     localhost.

;Name Server Information

@       IN      NS     ns1.yourzone.local.

;Reverse lookup for Name Server

10      IN      PTR    ns1.yourzone.local.

;PTR Record IP address to HostName

100     IN      PTR    www.yourzone.local.
150     IN      PTR    mail.yourzone.local.
```

# Check BIND Configuration Syntax

Use `named-checkconf` command to check the syntax of `named.conf*` files for any errors.


```bash
named-checkconf
```

Command will return to the shell if there are no errors.
Also, you can use named-checkzone to check the syntax errors in zone files.

# Forward Zone

```bash
named-checkzone yourzone.local /etc/bind/forward.yourzone.local.db
```

# Output:

```bash
zone yourzone.local/IN: loaded serial 2
OK
```

# Reverse Zone

```bash
named-checkzone 0.168.192.in-addr.arpa /etc/bind/reverse.yourzone.local.db
```

# Output:

```bash
zone 0.168.192.in-addr.arpa/IN: loaded serial 2
OK
```

# Restart bind service.

```bash
systemctl restart bind9
```

# Check the status of the bind9 service.

```bash
systemctl status bind9
```

# Verify DNS

Go to any client machine and add our new DNS server IP Address in `/etc/resolv.conf` file.

```bash
vim /etc/resolv.conf
```

- Make an entry like below.

```bash 
nameserver 192.168.0.10
```

You can either use `nslookup` or `dig` command to verify the DNS server.
Use the dig command to verify the forward lookup.

```bash
dig www.yourzone.local
```
If you get command not found, install `bind-utils` on Red Hat derivatives or `dnsutils` on the Debian derivatives package.

# Output:

```bash
; <<>> DiG 9.11.5-P4-5.1-Debian <<>> www.yourzone.local
;; global options: +cmd
;; Got answer:
;; WARNING: .local is reserved for Multicast DNS
;; You are currently testing what happens when an mDNS query is leaked to DNS
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 41979
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: c51856f159ddf40dadc13b835e1024a996e2a306d7888afe (good)
;; QUESTION SECTION:
;www.yourzone.local.             IN      A

;; ANSWER SECTION:
www.yourzone.local.      604800  IN      A       192.168.0.100

;; AUTHORITY SECTION:
yourzone.local.          604800  IN      NS      ns1.yourzone.local.

;; ADDITIONAL SECTION:
ns1.yourzone.local.      604800  IN      A       192.168.0.10

;; Query time: 1 msec
;; SERVER: 192.168.0.10#53(192.168.0.10)
;; WHEN: Sat Jan 04 05:37:45 UTC 2020
;; MSG SIZE  rcvd: 124
```

***The DNS server’s answer for the forward lookup www.itzgeek.local is 192.168.0.100.***

Confirm the reverse lookup with dig command.
