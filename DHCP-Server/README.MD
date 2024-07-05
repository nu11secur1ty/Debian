## Debian 12 DHCP server - home router and more.

## 1. Install packages
```
apt install isc-dhcp-server
```
## 1.1 Pre-configuration
In file:
```
vim /etc/default/isc-dhcp-server
```
## Let's uncomment:
- the timing and bring the file to the form where in the INTERFACESv4 field we indicate the port for the local network, in our case enp1s0.

```
DHCPDv4_CONF=/etc/dhcp/dhcpd.conf
DHCPDv4_PID=/var/run/dhcpd.pid
INTERFACESv4="enp1s0"
```
## 1.2 Configuring 
- the enp1s0 interface itself if it is not configured
```
vim /etc/network/interfaces
```
- edit with yours:
```
auto enp1s0
     iface enp1s0 inet static
     address 100.100.100.1
     netmask 255.255.255.0
```
## 1.2.1 Restart the service

```
service networking restart
```

## 1.3 Basic settings for dhcp service
```
vim /etc/dhcp/dhcpd.conf
```
- setup with yours
```
option domain-name "localhost.localdomain";
option domain-name-servers 100.100.100.1, 8.8.8.8;
default-lease-time 32400;
max-lease-time 604800;
log-facility local7;
authoritative;

subnet 100.100.100.0 netmask 255.255.255.0 {
   range 100.100.100.2 100.100.100.250;
   option broadcast-address 100.100.100.255;
   option routers 100.100.100.1;
}
```

## 1.3.1 Setting up a static IP by MAC address
```
vim /etc/dhcp/dhcpd.conf
```
- Client MAC
```
host mini-pc {
     hardware ethernet 06:e0:4c:6a:04:14;
     fixed-address 100.100.100.101;
}
```
## 1.4 Let's start the service and add it to startup
```
systemctl start isc-dhcp-server
systemctl enable isc-dhcp-server
```
## 1.5 Add rules to iptables
```
iptables -A INPUT -p tcp --dport 67 -j ACCEPT
iptables-save > /etc/iptables/rules.v4
```
## 1.6 Logging
If it is necessary to include a log file, install the service:
```
apt install rsyslog
```
## Let's add the configuration:

```
vim /etc/rsyslog.conf
```
- the setup
```
local7.* /var/log/dhcpd.log
```
## Let's restart the service
```
systemctl restart rsyslog
systemctl restart isc-dhcp-server.service
```

## FORWARD!
```
apt update -y && apt install iptables-persistent
```
## 3. Enable NAT with iptables
```
iptables -t nat -A POSTROUTING -j MASQUERADE
```

## iptables routing: 
This command will save the iptables rules to /etc/iptables/rules.v4, where later it will be restored by iptables-persistent on every reboot.
```
iptables-save > /etc/iptables/rules.v4
```

## Logs

A log file will be created and accessed at /var/log/dhcpd.log

The setup is complete, the server is configured and distributes IP addresses to devices connected via a port dedicated to the local network.
