FROM debian:stretch
LABEL maintainer="michaeldyl520@gmail.com"
COPY ./sources/sources.list /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install apt-transport-https vim
ADD ./sources/sources.list.d/php.list /etc/apt/sources.list.d/
RUN apt-get -y install apt-transport-https lsb-release ca-certificates curl && curl -sSL -o /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' 
RUN apt-get update 
RUN apt-get -y install apt-transport-https apache2 mariadb-server \
    php5.6-fpm php5.6-curl php5.6-bcmath php5.6-gd php5.6-dom php5.6-mcrypt php5.6-intl php5.6-mbstring php5.6-mysql php5.6-soap php5.6-zip php-xdebug \
    php7.0-fpm php7.0-curl php7.0-bcmath php7.0-gd php7.0-dom php7.0-mcrypt php7.0-intl php7.0-mbstring php7.0-mysql php7.0-soap php7.0-zip \
    php7.1-fpm php7.1-curl php7.1-bcmath php7.1-gd php7.1-dom php7.1-mcrypt php7.1-intl php7.1-mbstring php7.1-mysql php7.1-soap php7.1-zip \
    php7.2-fpm php7.2-curl php7.2-bcmath php7.2-gd php7.2-dom php7.2-intl php7.2-mbstring php7.2-mysql php7.2-soap php7.2-zip php-xdebug \
    php7.3-fpm php7.3-curl php7.3-bcmath php7.3-gd php7.3-dom php7.3-intl php7.3-mbstring php7.3-mysql php7.3-soap php7.3-zip php-xdebug
RUN useradd -ms /bin/bash www
WORKDIR /home/www
RUN mkdir website && chown www:www /home/www * -R
COPY ./etc/apache2/* /etc/apache2/

COPY ./etc/php/5.6/fpm/php.ini /etc/php/5.6/fpm/
COPY ./etc/php/7.0/fpm/php.ini /etc/php/7.0/fpm/
COPY ./etc/php/7.1/fpm/php.ini /etc/php/7.1/fpm/
COPY ./etc/php/7.2/fpm/php.ini /etc/php/7.2/fpm/
COPY ./etc/php/7.3/fpm/php.ini /etc/php/7.3/fpm/

COPY ./etc/php/5.6/fpm/pool.d/* /etc/php/5.6/fpm/pool.d/
COPY ./etc/php/7.0/fpm/pool.d/* /etc/php/7.0/fpm/pool.d/
COPY ./etc/php/7.1/fpm/pool.d/* /etc/php/7.1/fpm/pool.d/
COPY ./etc/php/7.2/fpm/pool.d/* /etc/php/7.2/fpm/pool.d/
COPY ./etc/php/7.3/fpm/pool.d/* /etc/php/7.3/fpm/pool.d/

COPY ./etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/mariadb.conf.d/

RUN a2enmod rewrite ssl proxy proxy_fcgi

EXPOSE 80 443 3306

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]