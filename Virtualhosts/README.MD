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


# Create the webroot directories


Before setting up the virtual hosts, we will need to create the document root directories for our websites. Let’s create them in the /var/www/html directory with the following commands:

```bash
mkdir -p /var/www/html/domain1.com
mkdir -p /var/www/html/domain2.com
```

Let’s also create a test demo page for each of our domain, so we can later test our configuration.
Navigate to the domain1.com document root directory:

```bash
cd /var/www/html/domain1.com
```

Create a new index.html page with:

```bash
vim index.html
```

-add

```bash
<html>
 <body>
  <h1>This is domain1.com!</h1>
 </body>
</html>
```

Now lets, do the following for the domain2.com domain.

```bash
cd /var/www/html/domain2.com
vim index.html
```
- And add the following content:

```bash
<html>
 <body>
  <h1>This is domain2.com!</h1>
 </body>
</html>
```

We have now successfully created the test pages for both domains. In order for our Apache webserver to be able to access these files, we also need to give them appropriate permissions and set the user and group to the www-data. We update the permissions to the whole /var/www/html directory, with the following command.


```bash
chown -R www-data: /var/www/html
```
# Create the Virtual Host Files

We can now create our virtual host files. The virtual host configuration files usually end with .conf extension.
Run the following command to create the virtual host configuration file for our first domain, domain1.com:

```bash 
vim /etc/apache2/sites-available/domain1.com.conf
```
- And add the following content to the file:

```bash
<VirtualHost *:80>

ServerAdmin admin@domain1.com
ServerName domain1.com
ServerAlias www.domain1.com
DocumentRoot /var/www/html/domain1.com

ErrorLog ${APACHE_LOG_DIR}/domain1.com_error.log
CustomLog ${APACHE_LOG_DIR}/domain2.com_access.log combined

</VirtualHost>
```
- Now, let’s do the same for our second domain name, domain2.com:

```bash
vim /etc/apache2/sites-available/domain2.com.conf
```
- And add the following code:

```bash
<VirtualHost *:80>

ServerAdmin admin@domain2.com
ServerName domain2.com
ServerAlias www.domain2.com
DocumentRoot /var/www/html/domain2.com

ErrorLog ${APACHE_LOG_DIR}/domain2.com_error.log
CustomLog ${APACHE_LOG_DIR}/domain2.com_access.log combined

</VirtualHost>
```
# Explenation
-------------------------------------------------------------------------
Here is a short explanation about each line in our virtual host files.

The following lines shows that the virtual host is listening on port 80:

```bash
<VirtualHost *:80>
```
The ServerAdmin sets the contact address that the server includes in any error messages it returns to the client. You can specify your email address here, or even remove the line.

```bash
ServerAdmin admin@domain1.com
```
ServerName is the domain name and the ServerAlias defines additional names that should match as if they are the original domain names.

```bash
ServerName domain1.com
ServerAlias www.domain1.com
```

The DocumentRoot defines the location where Apache should look for when processing a request for the domain defined in ServerName or ServerAlias.

```bash
DocumentRoot /var/www/html/domain1.com
```

The last two lines, define the location of the log files:

```bash
ErrorLog ${APACHE_LOG_DIR}/domain1.com_error.log
CustomLog ${APACHE_LOG_DIR}/domain1.com_access.log combined
```

The next step would be to enable the virtual hosts we have just created. You can do this with the following commands:

# Disable default
```bash
a2dissite 000-default.conf
```
- Enable your new vhost domains

```bash
a2ensite domain1.com.conf
a2ensite domain2.com.conf
```


Another alternative way to do this is by creating a symbolic link for each virtual host in /etc/apache2/sites-enabled

```bash
ln -s /etc/apache2/sites-available/domain1.com.conf /etc/apache2/sites-enabled/
ln -s /etc/apache2/sites-available/domain2.com.conf /etc/apache2/sites-enabled/
```

Once you enable the virtual hosts, using either of above methods, you will need to restart the Apache web server:

```bash
systemctl restart apache2
```
That’s it. If you all the instructions properly you should now be able to open each of the domains in your web browser and get the following result.

```bash
http://domain1.com
http://domain2.com
```

# NOTE: If not having a DNS Server zone:

- Add the folowing in to your `/etc/hosts` file

```bash
127.0.0.1 domain1.com
127.0.0.1 domain2.com
```
# BR 
