#! /bin/sh

# Wait before attempting to configure server. This gives OLSRD time
# to find servers on the network
sleep 120

servers=""
candidate=$(uci -q get system.ntp.server)
if [ "${candidate}" != "" ]; then
    if $(ntpd -n -q -p ${candidate} > /dev/null 2>&1); then
        servers="${servers} -p ${candidate}"
    fi
fi

# NTP servers tend to be poorly advertised, so we have to use a bit of
# heuristics to find them
for candidate in $(grep -i ntp /var/run/services_olsr | sed "s/^http:\/\/\(.*\):.*$/\1/")
do
    if $(ntpd -n -q -p ${candidate} > /dev/null 2>&1); then
        servers="${servers} -p ${candidate}"
    fi
done


if [ "${servers}" != "" ]; then
    logger -p notice -t meshntpd "ntpd starting with servers ${servers}"
    /etc/init.d/ntpclient stop 2> /dev/null
    killall ntpd 2> /dev/null
    ntpd ${servers}
else
    logger -p notice -t meshntpd "No reachable servers, ntpd not started."
fi
