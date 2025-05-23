#!/bin/bash

mysqld --user=mysql --skip-networking &
pid="$!"

MAX_RETRIES=30
RETRY_COUNT=0

echo "⏳ Aspettando che MariaDB si avvii..."
until mysqladmin ping >/dev/null 2>&1; do
    sleep 1
    RETRY_COUNT=$((RETRY_COUNT + 1))
    if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
        echo "❌ Timeout: MariaDB non si è avviato entro $MAX_RETRIES secondi."
        exit 1
    fi
done

echo "✅ MariaDB è attivo."

echo "⚙️ Inizializzo il database..."

mysql -uroot -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
#riga 24 e 26 da rimpiazzare % con localhost prima di pushare
mysql -uroot -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -uroot -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"


echo "✅ Inizializzazione completata."

echo "⏹️ Arresto MariaDB temporaneamente per esecuzione in foreground..."
mysqladmin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown

exec mysqld_safe