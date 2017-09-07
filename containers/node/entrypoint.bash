#! /bin/bash


cp -a /var/www/node_modules/. /var/www/nodeapp/node_modules
rm -rf /var/www/node_modules

cd /var/www/nodeapp
npm start

/sbin/my_init
