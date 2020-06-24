#!/bin/bash
##################################################
# Add route table                                #
# Author by Dethroner, 2020                      #
##################################################

echo "192.168.112.157	gitlab.sam-solutions.net" >> /etc/hosts
echo "192.168.112.101	owncloud.sam-solutions.net" >> /etc/hosts
echo "192.168.121.214	komus-qa.sam-solutions.net" >> /etc/hosts

route add -net 192.168.112.0/24 gw 10.0.2.2
route add -net 192.168.121.0/24 gw 10.0.2.2
