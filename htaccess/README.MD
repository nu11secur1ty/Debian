# Htaccess protecing a files

The Apache web server can read .htaccess files located anywhere in your document root to perform different tasks and control settings without changing the configuration files. This may be useful where you don’t have access to change the configuration files or don’t want to mangle with the configuration files to perform easy tasks. In this tutorial we’re going to password protect a single directory on your web site.

First we’ll need to create a file containing users and passwords:

```bash
htpasswd -c /etc/apache2/.htpasswd user1
htpasswd /etc/apache2/.htpasswd user2
```
