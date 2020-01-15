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
