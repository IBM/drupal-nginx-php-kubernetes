#!/bin/bash

CURRENT_DATE=`/bin/date "+%m-%d-%y"`

# Dump production data
echo "Extracting production data from the ${MYSQL_NAME_PRD} database on ${MYSQL_HOST_PRD}."
mysqldump --verbose --add-drop-table --quote-names -u${MYSQL_USER_PRD} -p${MYSQL_PASS_PRD} -h${MYSQL_HOST_PRD} ${MYSQL_NAME_PRD} > /root/backups/production-backup.sql
tar -zcvf /root/backups/backup-${CURRENT_DATE}.tar.gz /root/backups/production-backup.sql

# Restore data into staging
echo "Restoring production data to staging database ${MYSQL_NAME_STG} on ${MYSQL_HOST_STG}."
mysql --verbose -u${MYSQL_USER_STG} -p${MYSQL_PASS_STG} -h${MYSQL_HOST_STG} ${MYSQL_NAME_STG} < /root/backups/production-backup.sql
