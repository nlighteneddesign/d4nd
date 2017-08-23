#! /bin/bash

cp -a /var/www/tests/. /var/www/nodeapp/tests
rm -rf /var/www/tests

/sbin/my_init