#!/bin/sh
# Note: I've written this using sh so it works in the busybox container too

# USE the trap if you need to also do manual cleanup after the service is stopped,
#     or need to start multiple services in the one container
trap "echo TRAPed signal" HUP INT QUIT TERM
service php5.6-fpm start
service php7.0-fpm start
service php7.1-fpm start
service php7.2-fpm start
service php7.3-fpm start
service mysql start
if [ $? -ne 0 ]; then
    echo "failed"
    mysql_install_db
    wait
    service mysql start
    wait
    mysql -e "UPDATE mysql.user SET plugin = '' WHERE User = 'root'"
    wait
    mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION"
    wait
    '/usr/bin/mysqladmin' -u root password '123456'
    if [ $? -ne 0 ]; then
        echo "update root password faild."
    else
        echo "update root password success."
    fi
else
    echo "succeed"
fi
/usr/sbin/apache2ctl -D FOREGROUND