#!/bin/sh
set -e
sleep 5

sleep 2

echo "updating con jobs via whenever"
whenever --update-crontab
echo "updating con jobs via whenever... done"
crontab -l
echo "starting cron in foreground"
/usr/sbin/crond -f
exec "$@"
