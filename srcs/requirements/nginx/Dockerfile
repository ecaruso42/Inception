FROM debian:buster

RUN apt update -y
RUN apt upgrade -y
RUN apt install nginx -y
RUN apt install vim -y
RUN apt install curl -y
#riga 6 e 7 per installare vim e curl e avere un terminale più comdo nel container, forse da cancellare
RUN mkdir -p /etc/nginx/ssl
RUN apt install openssl -y
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=IT/ST=IDF/L=Italy/O=42/OU=42/CN=ecaruso.42.fr/UID=ecaruso"
#(riga 10 crea un certificato senza password,devo capire se serve questa parte)
RUN mkdir -p /var/run/nginx
RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD [ "nginx", "-g", "daemon off;" ]
#riga 18 da rivedere