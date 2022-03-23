#! /bin/sh

# Wait before attempting to configure server. This gives OLSRD time
# to find servers on the network
sleep 120

/etc/init.d/ntpclient stop 2> /dev/null
exec /etc/cron.daily/meshntp-update
