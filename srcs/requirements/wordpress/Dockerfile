FROM debian:buster

RUN apt update -y
RUN apt upgrade -y
RUN apt-get -y install wget
RUN apt-get update && apt-get install -y \
    wget \
    php \
    php-fpm \
    php-mysql \
    mariadb-client \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN wget https://it.wordpress.org/wordpress-6.8.1-it_IT.tar.gz -P /var/www
RUN cd /var/www && tar -xzf wordpress-6.8.1-it_IT.tar.gz && rm wordpress-6.8.1-it_IT.tar.gz
RUN chown -R root:root /var/www/wordpress