# Install Apache2
```bash 
apt install apache2 -y
```

# Enabling Apache2
```bash
systemctl enable apache2
```
- What is a virtual host?

Apache virtual hosts are set of configuration directives which allow you to host as many websites as you want, using a single web server.Apache web server tsupports two types of virtual hosts:

Name-based virtual hosts
IP based virtual hosts

The name-based virtual host is commonly used to host multiple websites on the same server, while in IP based virtual host we can only configure one website on one IP address. In this tutorial will show you how to create name-based virtual hosts. For this purpose, we will host two websites using the following domain names, domain1.com and domain2.com. You can also replace them with your actual domain names.

---------------------------------------------------------------------------------------------------------------------


