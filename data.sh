#!/bin/bash
sudo su
yum update -y
yum install git -y 
yum install httpd -y
git clone https://github.com/Filgeary/demo-website-skyline.git
cp -rn demo-website-skyline/* /var/www/html/
systemctl restart httpd && systemctl enable httpd