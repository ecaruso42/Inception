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

COPY conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf

#Questo serve a installare CLI per configurare automaticamente wordpress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY tools/setup-wordpress.sh /setup-wordpress.sh
RUN chmod +x /setup-wordpress.sh

EXPOSE 9000

CMD ["bash", "-c", "/setup-wordpress.sh && php-fpm7.3 -F"]