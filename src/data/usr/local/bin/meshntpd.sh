#! /bin/sh

UPDATE=/etc/cron.daily/meshntp-update

if [ "$1" = "stop" ]; then
    if [ -f ${UPDATE} ]; then
        mv ${UPDATE} ${UPDATE}.disabled
    fi
    killall ntpd
else
    if [ -f ${UPDATE}.disabled ]; then
        mv ${UPDATE}.disabled ${UPDATE}
    fi

    # Wait before attempting to configure server. This gives OLSRD time
    # to find servers on the network
    sleep 120

    /etc/init.d/ntpclient stop 2> /dev/null
    exec ${UPDATE}
fi
