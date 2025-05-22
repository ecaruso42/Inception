#!/bin/bash
set -e

RETRY_COUNT=0
MAX_RETRIES=30

# Attende MariaDB
echo "⏳ Aspetto MariaDB..."
until mysqladmin ping -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
    sleep 1
    RETRY_COUNT=$((RETRY_COUNT + 1))
    if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
        echo "❌ Timeout: MySql non si è avviato entro $MAX_RETRIES secondi."
        exit 1
    fi
done
echo "✅ MariaDB è attivo."

# Configura WordPress
echo "⚙️ Creo il file wp-config.php..."
wp config create \
    --dbname="$MYSQL_DATABASE" \
    --dbuser="$MYSQL_USER" \
    --dbpass="$MYSQL_PASSWORD" \
    --dbhost="$MYSQL_HOST" \
    --path="/var/www/html" \
    --allow-root

echo "📦 Installo WordPress..."
wp core install \
    --url="$DOMAIN_NAME" \
    --title="42 WP Site" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --path="/var/www/html" \
    --skip-email \
    --allow-root

echo "👤 Creo utente secondario..."
wp user create "$WP_USER" "$WP_USER_EMAIL" \
    --user_pass="$WP_USER_PASS" \
    --role=editor \
    --path="/var/www/html" \
    --allow-root

# Avvia PHP-FPM in foreground
echo "🚀 Avvio php-fpm..."
exec php-fpm7.3 -F