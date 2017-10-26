#!/bin/bash
cd /root/backups/
/usr/bin/mysqldump --add-drop-table -Q -u${MYSQL_USER} -p${MYSQL_PASS} -h${MYSQL_HOST} ${MYSQL_NAME} > backup.sql
CURRENT_DATE=`/bin/date "+%m-%d-%y"`
/bin/tar -zcvf backup-${CURRENT_DATE}.tar.gz backup.sql
