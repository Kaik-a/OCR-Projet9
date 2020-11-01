#!/bin/bash
USER=$1
PASSWORD=$2
SAVE_DIRECTORY=$3

SAVE_PASSWORD="password_created_from_us"
SAVE_USER="ocpizza-save"

echo "Creating user making backups"
mysql -u "$USER" -p"$PASSWORD" -e "CREATE USER '$SAVE_USER'@'localhost' IDENTIFIED BY '$SAVE_PASSWORD';"

echo "Granting privileges to ocpizza-save"
mysql -u "$USER" -p"$PASSWORD" -e "GRANT RELOAD, PROCESS, REPLICATION CLIENT ON *.* TO 'ocpizza-save'@'localhost';"
mysql -u "$USER" -p"$PASSWORD" -e "FLUSH PRIVILEGES;"

echo "Create hour-to-hour backup job"
(crontab -l ; echo "00 * * * * /etc/oc-pizza/backup.sh $SAVE_USER $SAVE_PASSWORD $SAVE_DIRECTORY >> /etc/oc-pizza/logs/backup.log 2>&1") | crontab
