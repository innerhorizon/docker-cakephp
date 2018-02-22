#!/bin/bash
SERVER=localhost
while getopts s:p:f: option
do
 case "${option}"
 in
 s) SERVER=${OPTARG};;
 p) PRODUCT=${OPTARG};;
 f) FORMAT=$OPTARG;;
 esac
done
sed -i -e 's/SERVER_NAME/'$SERVER'/g' /etc/apache2/apache2.conf
sed -i -e 's/SERVER_NAME/'$SERVER'/g' /etc/apache2/sites-available/000-default.conf

