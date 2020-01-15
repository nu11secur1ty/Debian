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
$TTL    604800
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
@       IN      SOA     itzgeek.local. root.yourzone.local. (
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

