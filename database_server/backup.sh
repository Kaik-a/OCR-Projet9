#!/bin/bash
USER=$1
PASSWORD=$2
SAVE_DIRECTORY=$3

date=$(date +'%Y-%m-%d_%H:%M:%S')

/usr/local/bin/mysqldump --all-databases -u "$USER" -p$PASSWORD --master-data --single-transaction > $SAVE_DIRECTORY/full-"$date".sql