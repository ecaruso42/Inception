FROM debian:buster

RUN apt update -y
RUN apt upgrade -y
RUN apt-get install mariadb-server -y

COPY conf/50-server.cnf	/etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/init_db.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/init_db.sh

ENTRYPOINT ["/usr/local/bin/init_db.sh"]