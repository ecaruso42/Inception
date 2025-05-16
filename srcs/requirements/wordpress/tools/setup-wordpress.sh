#!/bin/bash

until mysqladmin ping -h"$MYSQL_HOST" --silent; do
    echo "Aspettando MariaDB..."
    sleep 2
done

cd /var/www/wordpress

# Crea wp-config.php
wp config create \
    --dbname="$MYSQL_DATABASE" \
    --dbuser="$MYSQL_USER" \
    --dbpass="$MYSQL_PASSWORD" \
    --dbhost="$MYSQL_HOST" \
    --path="/var/www/wordpress" \
    --allow-root

# Installa WordPress
wp core install \
    --url="$DOMAIN_NAME" \
    --title="42 WP Site" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASS" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --path="/var/www/wordpress" \
    --skip-email \
    --allow-root

# Crea secondo utente
wp user create "$WP_USER" "$WP_USER_EMAIL" \
    --user_pass="$WP_USER_PASS" \
    --role=editor \
    --path="/var/www/wordpress" \
    --allow-root