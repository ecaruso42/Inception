FROM debian:buster

RUN apt update -y
RUN apt upgrade -y
RUN apt-get -y install wget
RUN apt-get install -y php7.3\
php-fpm\
php-mysql\
mariadb-client
RUN wget https://it.wordpress.org/wordpress-6.8.1-it_IT.tar.gz -P /var/www
RUN cd /var/www && tar -xzf wordpress-6.8.1-it_IT.tar.gz && rm wordpress-6.8.1-it_IT.tar.gz
RUN chown -R root:root /var/www/wordpress