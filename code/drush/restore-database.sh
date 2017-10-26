#!/bin/bash
mysql -u${MYSQL_USER} -p${MYSQL_PASS} -h${MYSQL_HOST} ${MYSQL_NAME} < /root/backups/backup.sql
