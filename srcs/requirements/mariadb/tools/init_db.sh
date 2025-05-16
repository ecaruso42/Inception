#!/bin/bash

mysqld_safe &

MAX_RETRIES=30
RETRY_COUNT=0

echo "⏳ Aspettando che MariaDB si avvii..."
until mysqladmin ping --silent --wait=1 >/dev/null 2>&1; do
    sleep 1
    RETRY_COUNT=$((RETRY_COUNT + 1))
    if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
        echo "❌ Timeout: MariaDB non si è avviato entro $MAX_RETRIES secondi."
        exit 1
    fi
done

echo "✅ MariaDB è attivo."

echo "⚙️ Inizializzo il database..."

mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
mysql -e "FLUSH PRIVILEGES;"


echo "✅ Inizializzazione completata."

echo "⏹️ Arresto MariaDB temporaneamente per esecuzione in foreground..."
mysqladmin -uroot -p"${SQL_ROOT_PASSWORD}" shutdown

exec mysqld_safe