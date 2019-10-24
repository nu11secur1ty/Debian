#!/usr/bin/python
# Author @nu11secur1ty
import os 
os.system("apt update -y");
os.system("apt upgrade -y");
os.system("apt dist-upgrade -y");
os.system("apt autoremove -y");
os.system("apt --fix-broken install -y");
os.system("cp /etc/apt/sources.list /etc/apt/sources.list_backup");
os.system("echo Type your country for exam: br, eu, gr");
os.system("read country");
os.system("echo Type your country which you want to use for exam: br, eu, gr");
os.system("read usage");
os.system("sed -i 's/$country/$usage/' /etc/apt/sources.list");
os.system("apt update -y");
os.system("apt upgrade -y");
os.system("apt dist-upgrade -y");
os.system("apt autoremove -y");
os.system("apt --fix-broken install -y");
