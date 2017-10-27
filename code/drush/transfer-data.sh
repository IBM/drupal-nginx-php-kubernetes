#!/bin/bash

# Dump production data
/usr/bin/mysqldump --add-drop-table -Q -u${MYSQL_USER_PRD} -p${MYSQL_PASS_PRD} -h${MYSQL_HOST_PRD} ${MYSQL_NAME_PRD} > /root/backups/production-backup.sql
CURRENT_DATE=`/bin/date "+%m-%d-%y"`
/bin/tar -zcvf /root/backups/backup-${CURRENT_DATE}.tar.gz /root/backups/production-backup.sql

# Restore data into staging
mysql -u${MYSQL_USER_STG} -p${MYSQL_PASS_STG} -h${MYSQL_HOST_STG} ${MYSQL_NAME_STG} < /root/backups/production-backup.sql
