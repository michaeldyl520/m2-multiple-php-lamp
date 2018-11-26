#!/bin/sh
# Note: I've written this using sh so it works in the busybox container too

# USE the trap if you need to also do manual cleanup after the service is stopped,
#     or need to start multiple services in the one container
trap "echo TRAPed signal" HUP INT QUIT TERM
service php5.6-fpm start
service php7.0-fpm start
service php7.1-fpm start
service php7.2-fpm start
service mysql start
/usr/sbin/apache2ctl -D FOREGROUND