# How to use
1. Use below command to start docker in local.
2. run `docker inspect www`
3. Add you site into sites-enabled folder.
4. Edit /etc/hosts
# 
```shell
docker run -d --name www -v ~/magento2-multiple-php-environment/sites-enabled:/etc/apache2/sites-enabled -v ~/website:/home/www/website ~/db:/var/lib/mysql -p80:80 -p443:443 -p3306:3306 www
```