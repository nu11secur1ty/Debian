# Htaccess protecing a files

The Apache web server can read .htaccess files located anywhere in your document root to perform different tasks and control settings without changing the configuration files. This may be useful where you don’t have access to change the configuration files or don’t want to mangle with the configuration files to perform easy tasks. In this tutorial we’re going to password protect a single directory on your web site.

First we’ll need to create a file containing users and passwords:

```bash
htpasswd -c /etc/apache2/.htpasswd user1
htpasswd /etc/apache2/.htpasswd user2
```
You can store the password file anywhere you like but I chose to store it where the Apache configuration files are located.

Now create a .htaccess file in the folder you wish to protect (pico /var/www/secret/.htaccess)

```bash
AuthType Basic
AuthUserFile /etc/apache2/.htpasswd
AuthName "Enter password"
Require valid-user
```

Make sure Apache allows .htaccess to override settings. Add these lines into your virtual host configuration and change the directory to your document root (pico /etc/apache2/sites-enabled/000-default):

```bash
<Directory /var/www/>
 AllowOverride All
</Directory>
```

The AllowOverride setting may already be in your virtual host configuration. Make sure it is set to All.

If you changed the AllowOverride setting, restart Apache:

```bash
/etc/init.d/apache2 restart
# of 
systemctl restart apache2.service
``` 


