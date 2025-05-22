#!/bin/bash

mysqld_safe &

MAX_RETRIES=30
RETRY_COUNT=0

echo "⏳ Aspettando che MariaDB si avvii..."
until mysqladmin ping -h mariadb -u root -p"$SQL_ROOT_PASSWORD" --silent &> /dev/null; do
    sleep 1
    RETRY_COUNT=$((RETRY_COUNT + 1))
    if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
        echo "❌ Timeout: MariaDB non si è avviato entro $MAX_RETRIES secondi."
        exit 1
    fi
done

echo "✅ MariaDB è attivo."

echo "⚙️ Inizializzo il database..."

mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql -e "FLUSH PRIVILEGES;"


echo "✅ Inizializzazione completata."

echo "⏹️ Arresto MariaDB temporaneamente per esecuzione in foreground..."
mysqladmin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown

exec mysqld_safe