#!/bin/bash 
echo "Hello world2" > /home/ec2-user/hello.txt 
yum update -y
yum install httpd -y
systemctl enable httpd
systemctl start httpd
